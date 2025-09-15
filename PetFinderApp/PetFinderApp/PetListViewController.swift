//
//  PetListViewController.swift
//  PetforPets
//
//  Created by Вилина Ольховская on 07.09.2025.
//

import UIKit
import Combine
import CoreLocation

final class PetListViewController: UIViewController, UISearchResultsUpdating, LocationPickerDelegate {

    // MARK: - Properties
    
    @MainActor private let viewModel = PetListViewModel()
    private var cancellables = Set<AnyCancellable>()
    
    private var selectedCoordinate: CLLocationCoordinate2D!
    private var selectedRadius: Double!
    private var selectedAddress: String!
    
    private var tableView: UITableView!
    private var activityIndicator: UIActivityIndicatorView!
    private let searchController = UISearchController(searchResultsController: nil)

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemGroupedBackground
        
        loadSavedLocation()
        
        setupTableView()
        setupSearchController()
        setupNavigationBar()
        setupActivityIndicator()
        setupBindings()
        fetchDataForCurrentLocation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchDataForCurrentLocation()
    }
    
    // MARK: - Setup
    
    private func setupTableView() {
        tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(PetTableViewCell.self, forCellReuseIdentifier: PetTableViewCell.reuseIdentifier)
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.contentInset.top = 10
        view.addSubview(tableView)
    }
    
    private func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Искать по описанию"
        tableView.tableHeaderView = searchController.searchBar
        definesPresentationContext = true
    }
    
    private func setupNavigationBar() {
        let profileButton = UIButton(type: .custom)
        profileButton.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
        profileButton.setImage(UIImage(systemName: "person.crop.circle"), for: .normal)
        profileButton.imageView?.contentMode = .scaleAspectFill
        profileButton.clipsToBounds = true
        profileButton.layer.cornerRadius = 22
        profileButton.addTarget(self, action: #selector(profileButtonTapped), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: profileButton)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(addButtonTapped))
        
        let locationButton = UIButton(type: .custom)
        
        let titleLabel = UILabel()
        titleLabel.text = self.selectedAddress
        titleLabel.font = .systemFont(ofSize: 17, weight: .semibold)
        titleLabel.textColor = .label
        
        let subtitleLabel = UILabel()
        subtitleLabel.text = "\(Int(self.selectedRadius)) км"
        subtitleLabel.font = .systemFont(ofSize: 14)
        subtitleLabel.textColor = .gray
        
        let vStack = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])
        vStack.axis = .vertical
        vStack.alignment = .center
        vStack.spacing = 0
        vStack.isUserInteractionEnabled = false
        
        locationButton.addSubview(vStack)
        vStack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            vStack.centerXAnchor.constraint(equalTo: locationButton.centerXAnchor),
            vStack.centerYAnchor.constraint(equalTo: locationButton.centerYAnchor)
        ])
        
        locationButton.addTarget(self, action: #selector(locationTitleTapped), for: .touchUpInside)
        navigationItem.titleView = locationButton
    }
    
    private func setupActivityIndicator() {
        activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.hidesWhenStopped = true
        view.addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func setupBindings() {
        viewModel.$pets.receive(on: DispatchQueue.main).sink { [weak self] _ in
            self?.tableView.reloadData()
        }.store(in: &cancellables)

        viewModel.$isLoading.receive(on: DispatchQueue.main).sink { [weak self] isLoading in
            isLoading ? self?.activityIndicator.startAnimating() : self?.activityIndicator.stopAnimating()
        }.store(in: &cancellables)

        viewModel.$errorMessage.compactMap { $0 }.receive(on: DispatchQueue.main).sink { message in
            print("ПОЛУЧЕНА ОШИБКА: \(message)")
        }.store(in: &cancellables)
    }

    // MARK: - Data
    
    private func fetchDataForCurrentLocation() {
        let searchText = searchController.searchBar.text
        Task {
            await viewModel.fetchPets(
                at: selectedCoordinate,
                with: selectedRadius,
                searchText: searchText
            )
        }
    }
    
    private func loadSavedLocation() {
        if let location = LocationService.shared.loadLocation() {
            self.selectedCoordinate = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
            self.selectedRadius = Double(location.radius)
            self.selectedAddress = location.address
        } else {
            let defaultLocation = LocationService.shared.getDefaultLocation()
            self.selectedCoordinate = CLLocationCoordinate2D(latitude: defaultLocation.latitude, longitude: defaultLocation.longitude)
            self.selectedRadius = Double(defaultLocation.radius)
            self.selectedAddress = defaultLocation.address
        }
    }
    
    // MARK: - Actions & Navigation
    
    @objc private func profileButtonTapped() {
        let profileVC = ProfileViewController()
        let navController = UINavigationController(rootViewController: profileVC)
        present(navController, animated: true)
    }
    
    @objc private func addButtonTapped() {
        let vm = AddEditPetViewModel()
        let vc = AddEditViewController(viewModel: vm)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func locationTitleTapped() {
        let locationPickerVC = LocationPickerViewController()
        locationPickerVC.delegate = self
        let navController = UINavigationController(rootViewController: locationPickerVC)
        navController.modalPresentationStyle = .fullScreen
        present(navController, animated: true)
    }
    
    // MARK: - UISearchResultsUpdating
    
    func updateSearchResults(for searchController: UISearchController) {
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(performSearch), object: nil)
        perform(#selector(performSearch), with: nil, afterDelay: 0.5)
    }
    
    @objc private func performSearch() {
        fetchDataForCurrentLocation()
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension PetListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.pets.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PetTableViewCell.reuseIdentifier, for: indexPath) as? PetTableViewCell else {
            return UITableViewCell()
        }
        let pet = viewModel.pets[indexPath.row]
        cell.configure(with: pet)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedPet = viewModel.pets[indexPath.row]
        let detailVC = PetDetailViewController(pet: selectedPet)
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
}

// MARK: - LocationPickerDelegate
extension PetListViewController {
    func didFinishPickingLocation(location: SavedLocation) {
        self.selectedCoordinate = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
        self.selectedRadius = Double(location.radius)
        self.selectedAddress = location.address
        
        setupNavigationBar()
        fetchDataForCurrentLocation()
    }
}

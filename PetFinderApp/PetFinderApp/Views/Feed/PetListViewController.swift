//
//  PetListViewController.swift
//  PetFinderApp
//
//  Created by Вилина Ольховская on 03.09.2025.
//

import UIKit
import Combine
import CoreLocation
import Kingfisher

final class PetListViewController: UIViewController, UISearchResultsUpdating, LocationPickerDelegate {

    // MARK: - Properties
    
    @MainActor private let viewModel = PetListViewModel()
    private var cancellables = Set<AnyCancellable>()
    
    private var selectedCoordinate: CLLocationCoordinate2D!
    private var selectedRadius: Double!
    private var selectedAddress: String!

    private var activeFilter = PetFilter()

    private var tableView: UITableView!
    private var activityIndicator: UIActivityIndicatorView!

    private let emptyStateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "В этом районе питомцев не найдено.\nПопробуйте увеличить радиус поиска."
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 16)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.isHidden = true
        return label
    }()
    private let searchController = UISearchController(searchResultsController: nil)

    private let fabButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .systemBlue
        button.tintColor = .white
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        if let imageView = button.imageView {
            imageView.preferredSymbolConfiguration = UIImage.SymbolConfiguration(pointSize: 22, weight: .medium)
        }
        button.layer.cornerRadius = 28
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 4)
        button.layer.shadowRadius = 8
        button.layer.shadowOpacity = 0.2
        return button
    }()

    private let profileButton: UIButton = {
        let btn = UIButton(type: .custom)
        btn.frame = CGRect(x: 0, y: 0, width: 32, height: 32)
        let config = UIImage.SymbolConfiguration(pointSize: 22, weight: .regular)
        btn.setImage(UIImage(systemName: "person.crop.circle", withConfiguration: config), for: .normal)
        btn.tintColor = .systemBlue
        btn.imageView?.contentMode = .scaleAspectFill
        btn.clipsToBounds = true
        btn.layer.cornerRadius = 16
        return btn
    }()

    private let bellButton: UIButton = {
        let btn = UIButton(type: .system)
        let config = UIImage.SymbolConfiguration(pointSize: 22, weight: .regular)
        btn.setImage(UIImage(systemName: "bell", withConfiguration: config), for: .normal)
        btn.frame = CGRect(x: 0, y: 0, width: 32, height: 32)
        return btn
    }()

    private let filterButton: UIButton = {
        let btn = UIButton(type: .system)
        let config = UIImage.SymbolConfiguration(pointSize: 20, weight: .regular)
        btn.setImage(UIImage(systemName: "line.3.horizontal.decrease.circle", withConfiguration: config), for: .normal)
        btn.tintColor = .label
        return btn
    }()
    private let bellBadgeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .systemBlue
        label.textColor = .white
        label.font = .systemFont(ofSize: 10, weight: .bold)
        label.textAlignment = .center
        label.layer.cornerRadius = 8
        label.clipsToBounds = true
        label.isHidden = true
        return label
    }()

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemGroupedBackground
        
        loadSavedLocation()

        setupTableView()
        setupSearchController()
        setupBellButton()
        setupNavigationBar()
        setupFAB()
        setupActivityIndicator()
        setupBindings()
        fetchDataForCurrentLocation()

        NotificationCenter.default.addObserver(
            self, selector: #selector(onNotificationsRead),
            name: .notificationsRead, object: nil
        )
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchDataForCurrentLocation()
        fetchUnreadCount()
        updateProfileAvatar()
    }

    private func updateProfileAvatar() {
        if let avatarURLString = AuthManager.shared.currentUser?.avatarURL,
           !avatarURLString.isEmpty,
           let url = URL(string: avatarURLString) {
            let config = UIImage.SymbolConfiguration(pointSize: 22, weight: .regular)
            let placeholder = UIImage(systemName: "person.crop.circle", withConfiguration: config)
            profileButton.kf.setImage(with: url, for: .normal, placeholder: placeholder)
            profileButton.tintColor = .systemBlue
        } else {
            let config = UIImage.SymbolConfiguration(pointSize: 22, weight: .regular)
            profileButton.setImage(
                UIImage(systemName: "person.crop.circle", withConfiguration: config),
                for: .normal
            )
            profileButton.tintColor = .systemBlue
        }
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
        searchController.searchBar.placeholder = "Поиск"
        searchController.searchBar.showsBookmarkButton = true
        searchController.searchBar.setImage(
            UIImage(systemName: "line.3.horizontal.decrease.circle"),
            for: .bookmark, state: .normal
        )
        searchController.searchBar.delegate = self
        definesPresentationContext = true

        let searchBar = searchController.searchBar
        let header = UIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 56))
        header.backgroundColor = .systemBackground
        searchBar.frame = header.bounds
        header.addSubview(searchBar)
        tableView.tableHeaderView = header
    }
    
    private func setupNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: bellButton)

        let maxTitleWidth = view.bounds.width - 44 * 2 - 16

        let titleLabel = UILabel()
        titleLabel.text = self.selectedAddress
        titleLabel.font = .systemFont(ofSize: 15, weight: .semibold)
        titleLabel.textColor = .label
        titleLabel.lineBreakMode = .byTruncatingTail
        titleLabel.numberOfLines = 1

        let subtitleLabel = UILabel()
        subtitleLabel.text = "\(Int(self.selectedRadius)) км"
        subtitleLabel.font = .systemFont(ofSize: 12)
        subtitleLabel.textColor = .secondaryLabel

        let vStack = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])
        vStack.axis = .vertical
        vStack.alignment = .center
        vStack.spacing = 0
        vStack.translatesAutoresizingMaskIntoConstraints = false
        vStack.isUserInteractionEnabled = false

        let container = UIButton(type: .custom)
        container.frame = CGRect(x: 0, y: 0, width: maxTitleWidth, height: 44)
        container.addSubview(vStack)
        NSLayoutConstraint.activate([
            vStack.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            vStack.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            vStack.widthAnchor.constraint(lessThanOrEqualToConstant: maxTitleWidth)
        ])

        container.addTarget(self, action: #selector(locationTitleTapped), for: .touchUpInside)
        navigationItem.titleView = container
    }
    
    private func setupFAB() {
        view.addSubview(fabButton)
        fabButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        NSLayoutConstraint.activate([
            fabButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            fabButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            fabButton.widthAnchor.constraint(equalToConstant: 56),
            fabButton.heightAnchor.constraint(equalToConstant: 56)
        ])
    }

    private func setupActivityIndicator() {
        activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.hidesWhenStopped = true
        view.addSubview(activityIndicator)
        view.addSubview(emptyStateLabel)

        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),

            emptyStateLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyStateLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            emptyStateLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            emptyStateLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32)
        ])
    }
    
    private var displayPets: [Pet] {
        let myID = AuthManager.shared.currentUser?.id
        let mine = viewModel.pets.filter { $0.ownerId == myID }
        let others = viewModel.pets.filter { $0.ownerId != myID }
        return mine + others
    }

    private func setupBindings() {
        viewModel.$pets.receive(on: DispatchQueue.main).sink { [weak self] pets in
            guard let self else { return }
            self.tableView.reloadData()
            self.emptyStateLabel.isHidden = !pets.isEmpty || self.viewModel.isLoading
        }.store(in: &cancellables)

        viewModel.$isLoading.receive(on: DispatchQueue.main).sink { [weak self] isLoading in
            guard let self else { return }
            isLoading ? self.activityIndicator.startAnimating() : self.activityIndicator.stopAnimating()
            if isLoading { self.emptyStateLabel.isHidden = true }
        }.store(in: &cancellables)

        viewModel.$errorMessage.compactMap { $0 }.receive(on: DispatchQueue.main).sink { message in
        }.store(in: &cancellables)
    }

    // MARK: - Data
    
    private func fetchDataForCurrentLocation() {
        let searchText = searchController.searchBar.text
        Task {
            await viewModel.fetchPets(
                at: selectedCoordinate,
                with: selectedRadius,
                searchText: searchText,
                petType: activeFilter.petType,
                lostFrom: activeFilter.lostFrom,
                lostTo: activeFilter.lostTo,
                breed: activeFilter.breed
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
    
    // MARK: - Notifications badge

    private func setupBellButton() {
        bellButton.addTarget(self, action: #selector(bellButtonTapped), for: .touchUpInside)
        bellButton.addSubview(bellBadgeLabel)
        NSLayoutConstraint.activate([
            bellBadgeLabel.topAnchor.constraint(equalTo: bellButton.topAnchor, constant: -4),
            bellBadgeLabel.leadingAnchor.constraint(equalTo: bellButton.trailingAnchor, constant: -10),
            bellBadgeLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 18),
            bellBadgeLabel.heightAnchor.constraint(equalToConstant: 18)
        ])
    }

    private func fetchUnreadCount() {
        Task {
            do {
                struct CountResponse: Decodable { let count: Int }
                let resp: CountResponse = try await APIClient.shared.request(
                    "GET", path: "/notifications/unread-count"
                )
                await MainActor.run { self.updateBellBadge(count: resp.count) }
            } catch {
            }
        }
    }

    private func updateBellBadge(count: Int) {
        if count > 0 {
            bellBadgeLabel.text = count > 99 ? "99+" : "\(count)"
            bellBadgeLabel.isHidden = false
            bellButton.setImage(UIImage(systemName: "bell"), for: .normal)
            bellButton.tintColor = .label
        } else {
            bellBadgeLabel.isHidden = true
            bellButton.setImage(UIImage(systemName: "bell"), for: .normal)
            bellButton.tintColor = .label
        }
    }

    @objc private func bellButtonTapped() {
        navigationItem.backButtonTitle = "Лента"
        let notifVC = NotificationsViewController()
        navigationController?.pushViewController(notifVC, animated: true)
    }

    @objc private func onNotificationsRead() {
        updateBellBadge(count: 0)
    }

    @objc private func profileButtonTapped() {
        let profileVC = ProfileViewController()
        let navController = UINavigationController(rootViewController: profileVC)
        present(navController, animated: true)
    }
    
    @objc private func addButtonTapped() {
        let vm = AddEditPetViewModel()
        let vc = AddEditViewController(viewModel: vm)
        navigationItem.backButtonTitle = "Лента"
        navigationController?.pushViewController(vc, animated: true)
    }

    
    @objc private func locationTitleTapped() {
        let locationPickerVC = LocationPickerViewController()
        locationPickerVC.delegate = self
        let navController = UINavigationController(rootViewController: locationPickerVC)
        navController.modalPresentationStyle = .fullScreen
        present(navController, animated: true)
    }
    
    @objc private func filterButtonTapped() {
        let sheet = FilterSheetViewController(currentFilter: activeFilter)
        sheet.delegate = self
        if let presentationController = sheet.sheetPresentationController {
            if #available(iOS 16.0, *) {
                let custom = UISheetPresentationController.Detent.custom(
                    identifier: .init("filter")
                ) { _ in 460 }
                presentationController.detents = [custom]
                presentationController.selectedDetentIdentifier = .init("filter")
            } else {
                presentationController.detents = [.medium()]
                presentationController.selectedDetentIdentifier = .medium
            }
            presentationController.prefersGrabberVisible = true
            presentationController.preferredCornerRadius = 20
            presentationController.prefersScrollingExpandsWhenScrolledToEdge = false
        }
        present(sheet, animated: true)
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
        return displayPets.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PetTableViewCell.reuseIdentifier, for: indexPath) as? PetTableViewCell else {
            return UITableViewCell()
        }
        cell.configure(with: displayPets[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailVC = PetDetailViewController(pet: displayPets[indexPath.row])
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

// MARK: - UISearchBarDelegate
extension PetListViewController: UISearchBarDelegate {
    func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar) {
        filterButtonTapped()
    }
}

// MARK: - FilterSheetDelegate
extension PetListViewController: FilterSheetDelegate {
    func filterSheetDidApply(_ filter: PetFilter) {
        activeFilter = filter
        filterButton.tintColor = filter.isActive ? .systemBlue : .label
        fetchDataForCurrentLocation()
    }
}

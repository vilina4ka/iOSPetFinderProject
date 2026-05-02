//
//  MyPetsViewController.swift
//  PetFinderApp
//
//  Created by Вилина Ольховская on 10.04.2026.
//
import UIKit

final class MyPetsViewController: UIViewController {

    // MARK: - ViewModel

    private let viewModel = MyPetsViewModel()

    // MARK: - UI

    private let tableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .plain)
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.register(PetTableViewCell.self, forCellReuseIdentifier: PetTableViewCell.reuseIdentifier)
        tv.rowHeight = UITableView.automaticDimension
        tv.estimatedRowHeight = 120
        tv.separatorStyle = .none
        tv.backgroundColor = .systemGroupedBackground
        return tv
    }()

    private let emptyView: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.isHidden = true

        let iv = UIImageView(image: UIImage(systemName: "pawprint"))
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.tintColor = .systemGray3
        iv.contentMode = .scaleAspectFit

        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "У вас пока нет объявлений"
        label.font = .systemFont(ofSize: 17)
        label.textColor = .secondaryLabel
        label.textAlignment = .center

        let sub = UILabel()
        sub.translatesAutoresizingMaskIntoConstraints = false
        sub.text = "Нажмите «+», чтобы создать первое"
        sub.font = .systemFont(ofSize: 14)
        sub.textColor = .tertiaryLabel
        sub.textAlignment = .center

        v.addSubview(iv)
        v.addSubview(label)
        v.addSubview(sub)
        NSLayoutConstraint.activate([
            iv.centerXAnchor.constraint(equalTo: v.centerXAnchor),
            iv.centerYAnchor.constraint(equalTo: v.centerYAnchor, constant: -40),
            iv.widthAnchor.constraint(equalToConstant: 60),
            iv.heightAnchor.constraint(equalToConstant: 60),
            label.topAnchor.constraint(equalTo: iv.bottomAnchor, constant: 16),
            label.centerXAnchor.constraint(equalTo: v.centerXAnchor),
            sub.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 6),
            sub.centerXAnchor.constraint(equalTo: v.centerXAnchor)
        ])
        return v
    }()

    private let activityIndicator: UIActivityIndicatorView = {
        let ai = UIActivityIndicatorView(style: .medium)
        ai.translatesAutoresizingMaskIntoConstraints = false
        ai.hidesWhenStopped = true
        return ai
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Мои объявления"
        view.backgroundColor = .systemGroupedBackground

        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addPetTapped)
        )

        view.addSubview(tableView)
        view.addSubview(emptyView)
        view.addSubview(activityIndicator)

        tableView.dataSource = self
        tableView.delegate = self

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            emptyView.topAnchor.constraint(equalTo: view.topAnchor),
            emptyView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            emptyView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            emptyView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadPets()
    }

    // MARK: - Load

    private func loadPets() {
        activityIndicator.startAnimating()
        tableView.isHidden = true
        emptyView.isHidden = true

        Task {
            await viewModel.fetchPets()
            self.activityIndicator.stopAnimating()
            self.tableView.reloadData()
            if viewModel.errorMessage != nil {
                self.emptyView.isHidden = false
            } else {
                self.tableView.isHidden = viewModel.pets.isEmpty
                self.emptyView.isHidden = !viewModel.pets.isEmpty
            }
        }
    }

    // MARK: - Actions

    @objc private func addPetTapped() {
        let vm = AddEditPetViewModel()
        let vc = AddEditViewController(viewModel: vm)
        navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - UITableViewDataSource

extension MyPetsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.pets.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: PetTableViewCell.reuseIdentifier, for: indexPath
        ) as! PetTableViewCell
        cell.configure(with: viewModel.pets[indexPath.row])
        return cell
    }
}

// MARK: - UITableViewDelegate

extension MyPetsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let pet = viewModel.pets[indexPath.row]
        let detailVC = PetDetailViewController(pet: pet)
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

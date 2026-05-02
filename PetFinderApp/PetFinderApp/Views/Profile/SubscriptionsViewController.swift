//
//  SubscriptionsViewController.swift
//  PetFinderApp
//
//  Created by Вилина Ольховская on 12.04.2026.
//
import UIKit

final class SubscriptionsViewController: UIViewController {

    // MARK: - ViewModel

    private let viewModel = SubscriptionsViewModel()

    // MARK: - UI

    private var tableView: UITableView!
    private let emptyLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Вы ещё не следите ни за одним питомцем.\nОткройте анкету и нажмите ♥"
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 16)
        return label
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Мои подписки"
        view.backgroundColor = .systemGroupedBackground

        setupTableView()
        setupEmptyLabel()
        loadSubscriptions()
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

    private func setupEmptyLabel() {
        view.addSubview(emptyLabel)
        NSLayoutConstraint.activate([
            emptyLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            emptyLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            emptyLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32)
        ])
        emptyLabel.isHidden = true
    }

    // MARK: - Load

    private func loadSubscriptions() {
        Task {
            await viewModel.fetchSubscriptions()
            self.tableView.reloadData()
            if let msg = viewModel.errorMessage {
                self.emptyLabel.text = msg
                self.emptyLabel.isHidden = false
            } else {
                self.emptyLabel.isHidden = !viewModel.pets.isEmpty
            }
        }
    }
}

// MARK: - UITableViewDataSource / Delegate

extension SubscriptionsViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.pets.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: PetTableViewCell.reuseIdentifier, for: indexPath
        ) as? PetTableViewCell else { return UITableViewCell() }
        cell.configure(with: viewModel.pets[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailVC = PetDetailViewController(pet: viewModel.pets[indexPath.row])
        navigationController?.pushViewController(detailVC, animated: true)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        140
    }
}

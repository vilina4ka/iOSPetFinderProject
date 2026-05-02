//
//  SightingsListViewController.swift
//  PetFinderApp
//
//  Created by Вилина Ольховская on 28.03.2026.
//

import UIKit
import Kingfisher

final class SightingsListViewController: UIViewController {

    // MARK: - Properties

    private var sightings: [Sighting]
    private let pet: Pet

    // MARK: - UI

    private let tableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .insetGrouped)
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.register(SightingCell.self, forCellReuseIdentifier: SightingCell.reuseID)
        tv.rowHeight = UITableView.automaticDimension
        tv.estimatedRowHeight = 90
        return tv
    }()

    private let emptyLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Наблюдений пока нет"
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 17)
        label.textAlignment = .center
        label.isHidden = true
        return label
    }()

    // MARK: - Init

    init(sightings: [Sighting], pet: Pet) {
        self.sightings = sightings
        self.pet = pet
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { fatalError() }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Наблюдения"
        view.backgroundColor = .systemBackground

        view.addSubview(tableView)
        view.addSubview(emptyLabel)

        tableView.dataSource = self
        tableView.delegate = self

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            emptyLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])

        updateEmptyState()

        NotificationCenter.default.addObserver(self, selector: #selector(refreshSightings),
                                               name: .sightingStatusChanged, object: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.deselectRow(at: tableView.indexPathForSelectedRow ?? IndexPath(), animated: true)
    }

    private func updateEmptyState() {
        emptyLabel.isHidden = !sightings.isEmpty
        tableView.isHidden = sightings.isEmpty
    }

    @objc private func refreshSightings() {
        Task {
            do {
                let result: [Sighting] = try await APIClient.shared.request(
                    "GET", path: "/pets/\(pet.id)/sightings"
                )
                await MainActor.run {
                    self.sightings = result
                    self.tableView.reloadData()
                    self.updateEmptyState()
                }
            } catch {
            }
        }
    }
}

// MARK: - UITableViewDataSource

extension SightingsListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        sightings.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SightingCell.reuseID, for: indexPath) as! SightingCell
        cell.configure(with: sightings[indexPath.row])
        return cell
    }
}

// MARK: - UITableViewDelegate

extension SightingsListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sighting = sightings[indexPath.row]
        let detailVC = SightingDetailViewController(sighting: sighting, pet: pet, isOwner: true)
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

// MARK: - SightingCell

private final class SightingCell: UITableViewCell {

    static let reuseID = "SightingCell"

    private let thumbImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 10
        iv.backgroundColor = .systemGray5
        return iv
    }()

    private let placeholderIcon: UIImageView = {
        let iv = UIImageView(image: UIImage(systemName: "eye.fill"))
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.tintColor = .systemGray3
        iv.contentMode = .scaleAspectFit
        return iv
    }()

    private let addressLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .semibold)
        label.numberOfLines = 2
        return label
    }()

    private let metaLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13)
        label.textColor = .secondaryLabel
        label.numberOfLines = 1
        return label
    }()

    private let statusBadge: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 11, weight: .semibold)
        label.layer.cornerRadius = 5
        label.clipsToBounds = true
        label.textAlignment = .center
        return label
    }()

    private var textLeadingWithPhoto: NSLayoutConstraint?
    private var textLeadingNoPhoto: NSLayoutConstraint?
    private let textStack = UIStackView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        accessoryType = .disclosureIndicator
        selectionStyle = .default

        thumbImageView.addSubview(placeholderIcon)

        textStack.axis = .vertical
        textStack.spacing = 4
        textStack.alignment = .leading
        textStack.translatesAutoresizingMaskIntoConstraints = false
        [addressLabel, metaLabel, statusBadge].forEach(textStack.addArrangedSubview)

        contentView.addSubview(thumbImageView)
        contentView.addSubview(textStack)

        textLeadingWithPhoto = textStack.leadingAnchor.constraint(equalTo: thumbImageView.trailingAnchor, constant: 12)
        textLeadingNoPhoto   = textStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16)

        NSLayoutConstraint.activate([
            thumbImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            thumbImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            thumbImageView.widthAnchor.constraint(equalToConstant: 64),
            thumbImageView.heightAnchor.constraint(equalToConstant: 64),
            thumbImageView.topAnchor.constraint(greaterThanOrEqualTo: contentView.topAnchor, constant: 12),
            thumbImageView.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -12),

            placeholderIcon.centerXAnchor.constraint(equalTo: thumbImageView.centerXAnchor),
            placeholderIcon.centerYAnchor.constraint(equalTo: thumbImageView.centerYAnchor),
            placeholderIcon.widthAnchor.constraint(equalToConstant: 24),
            placeholderIcon.heightAnchor.constraint(equalToConstant: 24),

            textStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            textStack.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            textStack.topAnchor.constraint(greaterThanOrEqualTo: contentView.topAnchor, constant: 12),
            textStack.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -12)
        ])
    }

    required init?(coder: NSCoder) { fatalError() }

    func configure(with sighting: Sighting) {
        let hasPhoto = !sighting.imageUrls.isEmpty
        thumbImageView.isHidden = !hasPhoto
        textLeadingWithPhoto?.isActive = hasPhoto
        textLeadingNoPhoto?.isActive = !hasPhoto

        if hasPhoto, let urlString = sighting.imageUrls.first, let url = URL(string: urlString) {
            thumbImageView.kf.setImage(with: url, placeholder: nil) { [weak self] result in
                if case .failure = result {
                    self?.placeholderIcon.isHidden = false
                } else {
                    self?.placeholderIcon.isHidden = true
                }
            }
        }

        addressLabel.text = "📍 \(sighting.address)"

        let name = sighting.reporterName.isEmpty ? "Аноним" : sighting.reporterName
        let dateStr = sighting.createdAt.map { formatDate($0) } ?? ""
        metaLabel.text = "\(name)  ·  \(dateStr)"

        switch sighting.status {
        case "confirmed":
            statusBadge.text = "  ✓ Подтверждено  "
            statusBadge.backgroundColor = UIColor.systemGreen.withAlphaComponent(0.15)
            statusBadge.textColor = .systemGreen
        case "rejected":
            statusBadge.text = "  ✗ Отклонено  "
            statusBadge.backgroundColor = UIColor.systemRed.withAlphaComponent(0.15)
            statusBadge.textColor = .systemRed
        default:
            statusBadge.text = "  ● Новое  "
            statusBadge.backgroundColor = UIColor.systemOrange.withAlphaComponent(0.15)
            statusBadge.textColor = .systemOrange
        }
    }

    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMM, HH:mm"
        formatter.locale = Locale(identifier: "ru_RU")
        return formatter.string(from: date)
    }
}

//
//  NotificationsViewController.swift
//  PetFinderApp
//
//  Created by Вилина Ольховская on 05.04.2026.
//

import UIKit

// MARK: - Model

struct AppNotification: Decodable {
    let id: String
    let type: String        // "sighting", "message"
    let petId: String?
    let title: String
    let body: String
    let isRead: Bool
    let createdAt: Date
}

// MARK: - ViewController

final class NotificationsViewController: UIViewController {

    // MARK: - UI

    private let tableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .plain)
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        tv.register(NotificationCell.self, forCellReuseIdentifier: NotificationCell.reuseID)
        return tv
    }()

    private let emptyLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Уведомлений пока нет"
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 17)
        label.textAlignment = .center
        label.isHidden = true
        return label
    }()

    private let activityIndicator: UIActivityIndicatorView = {
        let ai = UIActivityIndicatorView(style: .medium)
        ai.translatesAutoresizingMaskIntoConstraints = false
        ai.hidesWhenStopped = true
        return ai
    }()

    // MARK: - Data

    private var notifications: [AppNotification] = []

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Уведомления"
        view.backgroundColor = .systemBackground

        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Прочитать все",
            style: .plain,
            target: self,
            action: #selector(markAllReadTapped)
        )

        setupUI()
        loadNotifications()
    }

    // MARK: - Setup

    private func setupUI() {
        view.addSubview(tableView)
        view.addSubview(emptyLabel)
        view.addSubview(activityIndicator)

        tableView.dataSource = self
        tableView.delegate = self

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            emptyLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),

            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    // MARK: - Networking

    private func loadNotifications() {
        activityIndicator.startAnimating()
        emptyLabel.isHidden = true

        Task {
            do {
                let items: [AppNotification] = try await APIClient.shared.request(
                    "GET", path: "/notifications"
                )
                await MainActor.run {
                    self.activityIndicator.stopAnimating()
                    self.notifications = items
                    self.tableView.reloadData()
                    self.emptyLabel.isHidden = !items.isEmpty
                }
            } catch {
                await MainActor.run {
                    self.activityIndicator.stopAnimating()
                    self.emptyLabel.isHidden = false
                    self.emptyLabel.text = "Не удалось загрузить уведомления"
                }
            }
        }
    }

    @objc private func markAllReadTapped() {
        Task {
            do {
                let _: EmptyResponse = try await APIClient.shared.request(
                    "POST", path: "/notifications/read-all"
                )
                await MainActor.run {
                    self.notifications = self.notifications.map { n in
                        AppNotification(
                            id: n.id, type: n.type, petId: n.petId,
                            title: n.title, body: n.body,
                            isRead: true, createdAt: n.createdAt
                        )
                    }
                    self.tableView.reloadData()
                    NotificationCenter.default.post(name: .notificationsRead, object: nil)
                }
            } catch {
            }
        }
    }
}

// MARK: - UITableViewDataSource / Delegate

extension NotificationsViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        notifications.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NotificationCell.reuseID, for: indexPath) as! NotificationCell
        cell.configure(with: notifications[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let notification = notifications[indexPath.row]
        handleNotificationTap(notification)
    }

    // MARK: - Notification Navigation

    private func handleNotificationTap(_ notification: AppNotification) {
        if !notification.isRead {
            markAsRead(notification)
        }
        switch notification.type {
        case "sighting":
            navigateToSightings(petId: notification.petId)
        case "message":
            navigateToChat(petId: notification.petId)
        case "update":
            navigateToPet(petId: notification.petId)
        default:
            break
        }
    }

    private func markAsRead(_ notification: AppNotification) {
        guard let index = notifications.firstIndex(where: { $0.id == notification.id }) else { return }
        notifications[index] = AppNotification(
            id: notification.id, type: notification.type, petId: notification.petId,
            title: notification.title, body: notification.body,
            isRead: true, createdAt: notification.createdAt
        )
        tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .none)
        NotificationCenter.default.post(name: .notificationsRead, object: nil)

        Task {
            let _: EmptyResponse? = try? await APIClient.shared.request(
                "POST", path: "/notifications/\(notification.id)/read"
            )
        }
    }

    private func navigateToSightings(petId: String?) {
        guard let petId else { return }
        Task {
            do {
                async let pet: Pet = APIClient.shared.request("GET", path: "/pets/\(petId)")
                async let sightings: [Sighting] = APIClient.shared.request("GET", path: "/pets/\(petId)/sightings")
                let (loadedPet, loadedSightings) = try await (pet, sightings)
                await MainActor.run {
                    let listVC = SightingsListViewController(sightings: loadedSightings, pet: loadedPet)
                    self.navigationController?.pushViewController(listVC, animated: true)
                }
            } catch {
            }
        }
    }

    private func navigateToPet(petId: String?) {
        guard let petId else { return }
        Task {
            do {
                let pet: Pet = try await APIClient.shared.request("GET", path: "/pets/\(petId)")
                await MainActor.run {
                    let detailVC = PetDetailViewController(pet: pet)
                    self.navigationController?.pushViewController(detailVC, animated: true)
                }
            } catch {
            }
        }
    }

    private func navigateToChat(petId: String?) {
        guard let petId else { return }
        Task {
            do {
                async let pet: Pet = APIClient.shared.request("GET", path: "/pets/\(petId)")
                async let threads: [ChatThread] = APIClient.shared.request("GET", path: "/chats")
                let (loadedPet, loadedThreads) = try await (pet, threads)
                guard let thread = loadedThreads.first(where: { $0.petId == petId }) else { return }
                await MainActor.run {
                    let chatVC = ChatViewController(
                        pet: loadedPet,
                        recipientId: thread.otherUserId,
                        sightingId: thread.sightingId
                    )
                    chatVC.title = thread.otherUserName.isEmpty ? "Чат" : thread.otherUserName
                    self.navigationController?.pushViewController(chatVC, animated: true)
                }
            } catch {
            }
        }
    }
}

// MARK: - Notification Name

extension Notification.Name {
    static let notificationsRead = Notification.Name("notificationsRead")
}

// MARK: - Cell

final class NotificationCell: UITableViewCell {

    static let reuseID = "NotificationCell"

    private let iconImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFit
        iv.tintColor = .systemBlue
        iv.widthAnchor.constraint(equalToConstant: 28).isActive = true
        iv.heightAnchor.constraint(equalToConstant: 28).isActive = true
        return iv
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 15, weight: .semibold)
        label.numberOfLines = 1
        return label
    }()

    private let bodyLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 14)
        label.textColor = .secondaryLabel
        label.numberOfLines = 2
        return label
    }()

    private let timeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 12)
        label.textColor = .tertiaryLabel
        return label
    }()

    private let unreadDot: UIView = {
        let dot = UIView()
        dot.translatesAutoresizingMaskIntoConstraints = false
        dot.backgroundColor = .systemBlue
        dot.layer.cornerRadius = 5
        dot.widthAnchor.constraint(equalToConstant: 10).isActive = true
        dot.heightAnchor.constraint(equalToConstant: 10).isActive = true
        return dot
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }

    required init?(coder: NSCoder) { fatalError() }

    private func setupLayout() {
        let textStack = UIStackView(arrangedSubviews: [titleLabel, bodyLabel, timeLabel])
        textStack.translatesAutoresizingMaskIntoConstraints = false
        textStack.axis = .vertical
        textStack.spacing = 2

        contentView.addSubview(iconImageView)
        contentView.addSubview(textStack)
        contentView.addSubview(unreadDot)

        NSLayoutConstraint.activate([
            iconImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            iconImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),

            textStack.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 12),
            textStack.trailingAnchor.constraint(equalTo: unreadDot.leadingAnchor, constant: -8),
            textStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            textStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),

            unreadDot.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            unreadDot.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }

    func configure(with notification: AppNotification) {
        titleLabel.text = notification.title
        bodyLabel.text = notification.body.isEmpty ? nil : notification.body
        bodyLabel.isHidden = notification.body.isEmpty

        switch notification.type {
        case "sighting":
            iconImageView.image = UIImage(systemName: "eye.fill")
            iconImageView.tintColor = .systemGreen
        case "message":
            iconImageView.image = UIImage(systemName: "message.fill")
            iconImageView.tintColor = .systemBlue
        default:
            iconImageView.image = UIImage(systemName: "bell.fill")
            iconImageView.tintColor = .systemOrange
        }

        timeLabel.text = notification.createdAt.relativeString()

        titleLabel.font = notification.isRead
            ? .systemFont(ofSize: 15, weight: .regular)
            : .systemFont(ofSize: 15, weight: .semibold)
        unreadDot.isHidden = notification.isRead
        backgroundColor = notification.isRead ? .systemBackground : .systemBlue.withAlphaComponent(0.05)
    }
}

// MARK: - Date extension

private extension Date {
    func relativeString() -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .short
        formatter.locale = Locale(identifier: "ru_RU")
        return formatter.localizedString(for: self, relativeTo: Date())
    }
}

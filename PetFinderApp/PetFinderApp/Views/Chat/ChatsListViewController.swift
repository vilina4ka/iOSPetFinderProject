//
//  ChatsListViewController.swift
//  PetFinderApp
//
//  Created by Вилина Ольховская on 19.03.2026.
//

import UIKit
import Kingfisher

final class ChatsListViewController: UIViewController {

    // MARK: - Properties

    private var threads: [ChatThread] = []

    // MARK: - UI

    private let tableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .plain)
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.register(ChatThreadCell.self, forCellReuseIdentifier: ChatThreadCell.reuseID)
        tv.rowHeight = 80
        tv.separatorInset = UIEdgeInsets(top: 0, left: 76, bottom: 0, right: 0)
        return tv
    }()

    private let emptyView: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.isHidden = true
        let iv = UIImageView(image: UIImage(systemName: "message"))
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.tintColor = .systemGray3
        iv.contentMode = .scaleAspectFit
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Нет диалогов"
        label.font = .systemFont(ofSize: 17)
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        let sub = UILabel()
        sub.translatesAutoresizingMaskIntoConstraints = false
        sub.text = "Чаты появятся когда кто-то\nотзовётся на наблюдение"
        sub.font = .systemFont(ofSize: 14)
        sub.textColor = .tertiaryLabel
        sub.textAlignment = .center
        sub.numberOfLines = 2
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

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Чаты"
        view.backgroundColor = .systemBackground
        view.addSubview(tableView)
        view.addSubview(emptyView)
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
            emptyView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.deselectRow(at: tableView.indexPathForSelectedRow ?? IndexPath(), animated: true)
        loadChats()
    }

    // MARK: - Load

    private func loadChats() {
        Task {
            do {
                let result: [ChatThread] = try await APIClient.shared.request("GET", path: "/chats")
                await MainActor.run {
                    self.threads = result
                    self.tableView.reloadData()
                    self.emptyView.isHidden = !result.isEmpty
                    self.tableView.isHidden = result.isEmpty
                    self.updateBadge()
                }
            } catch {
            }
        }
    }

    private func updateBadge() {
        let total = threads.reduce(0) { $0 + $1.unreadCount }
        tabBarItem.badgeValue = total > 0 ? "\(total)" : nil
    }
}

// MARK: - UITableViewDataSource

extension ChatsListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        threads.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ChatThreadCell.reuseID, for: indexPath) as! ChatThreadCell
        cell.configure(with: threads[indexPath.row])
        return cell
    }
}

// MARK: - UITableViewDelegate

extension ChatsListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let thread = threads[indexPath.row]
        Task {
            do {
                let pet: Pet = try await APIClient.shared.request("GET", path: "/pets/\(thread.petId)")
                await MainActor.run {
                    let chatVC = ChatViewController(
                        pet: pet,
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

// MARK: - ChatThreadCell

private final class ChatThreadCell: UITableViewCell {

    static let reuseID = "ChatThreadCell"

    private let petImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 24
        iv.backgroundColor = .systemGray5
        return iv
    }()

    private let nameLabel: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 16, weight: .semibold)
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    private let petLabel: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 13)
        l.textColor = .secondaryLabel
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    private let lastMessageLabel: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 14)
        l.textColor = .secondaryLabel
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    private let timeLabel: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 12)
        l.textColor = .tertiaryLabel
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    private let badgeLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.backgroundColor = .systemBlue
        l.textColor = .white
        l.font = .systemFont(ofSize: 12, weight: .bold)
        l.textAlignment = .center
        l.clipsToBounds = true
        l.layer.cornerRadius = 10
        l.isHidden = true
        return l
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        accessoryType = .none

        let rightStack = UIStackView(arrangedSubviews: [timeLabel, badgeLabel])
        rightStack.axis = .vertical
        rightStack.alignment = .trailing
        rightStack.spacing = 4
        rightStack.translatesAutoresizingMaskIntoConstraints = false

        let textStack = UIStackView(arrangedSubviews: [nameLabel, petLabel, lastMessageLabel])
        textStack.axis = .vertical
        textStack.spacing = 2
        textStack.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(petImageView)
        contentView.addSubview(rightStack)
        contentView.addSubview(textStack)

        NSLayoutConstraint.activate([
            petImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            petImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            petImageView.widthAnchor.constraint(equalToConstant: 48),
            petImageView.heightAnchor.constraint(equalToConstant: 48),

            rightStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            rightStack.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),

            badgeLabel.heightAnchor.constraint(equalToConstant: 20),
            badgeLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 20),

            textStack.leadingAnchor.constraint(equalTo: petImageView.trailingAnchor, constant: 12),
            textStack.trailingAnchor.constraint(equalTo: rightStack.leadingAnchor, constant: -8),
            textStack.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }

    required init?(coder: NSCoder) { fatalError() }

    func configure(with thread: ChatThread) {
        nameLabel.text = thread.otherUserName.isEmpty ? "Аноним" : thread.otherUserName
        petLabel.text = "🐾 \(thread.petName)"
        lastMessageLabel.text = thread.lastMessage

        if let url = URL(string: thread.petImageUrl), !thread.petImageUrl.isEmpty {
            petImageView.kf.setImage(with: url, placeholder: UIImage(systemName: "pawprint.fill"))
        } else {
            petImageView.image = UIImage(systemName: "pawprint.fill")
            petImageView.tintColor = .systemGray3
        }

        if let date = thread.lastMessageAt {
            timeLabel.text = formatTime(date)
        }

        if thread.unreadCount > 0 {
            badgeLabel.isHidden = false
            badgeLabel.text = " \(thread.unreadCount) "
        } else {
            badgeLabel.isHidden = true
            badgeLabel.text = nil
        }
    }

    private func formatTime(_ date: Date) -> String {
        let cal = Calendar.current
        if cal.isDateInToday(date) {
            let f = DateFormatter()
            f.dateFormat = "HH:mm"
            return f.string(from: date)
        } else if cal.isDateInYesterday(date) {
            return "вчера"
        } else {
            let f = DateFormatter()
            f.dateFormat = "d MMM"
            f.locale = Locale(identifier: "ru_RU")
            return f.string(from: date)
        }
    }
}

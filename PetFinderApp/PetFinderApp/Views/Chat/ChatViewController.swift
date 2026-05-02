//
//  ChatViewController.swift
//  PetFinderApp
//
//  Created by Вилина Ольховская on 18.03.2026.
//

import UIKit
import Combine

final class ChatViewController: UIViewController {

    // MARK: - Properties

    private let viewModel: ChatViewModel
    private var cancellables = Set<AnyCancellable>()

    // MARK: - UI

    private let tableView: UITableView = {
        let tv = UITableView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.separatorStyle = .none
        tv.backgroundColor = .systemBackground
        tv.register(ChatMessageCell.self, forCellReuseIdentifier: "ChatMessageCell")
        tv.estimatedRowHeight = 50
        tv.rowHeight = UITableView.automaticDimension
        return tv
    }()

    private let inputContainer: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = .systemBackground
        v.layer.shadowColor = UIColor.black.cgColor
        v.layer.shadowOpacity = 0.1
        v.layer.shadowOffset = CGSize(width: 0, height: -1)
        return v
    }()

    private let textField: UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.placeholder = "Написать сообщение..."
        tf.borderStyle = .roundedRect
        tf.backgroundColor = .systemGray6
        tf.layer.cornerRadius = 20
        tf.layer.masksToBounds = true
        tf.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 0))
        tf.leftViewMode = .always
        return tf
    }()

    private let sendButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setImage(UIImage(systemName: "paperplane.fill"), for: .normal)
        btn.tintColor = .systemBlue
        return btn
    }()

    // MARK: - Init

    init(pet: Pet, recipientId: String, sightingId: String? = nil) {
        self.viewModel = ChatViewModel(pet: pet, recipientId: recipientId, sightingId: sightingId)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { fatalError() }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Чат"
        setupUI()
        tableView.dataSource = self
        tableView.delegate = self
        bindViewModel()

        Task {
            await viewModel.loadMessages()
            await viewModel.markMessagesRead()
            NotificationCenter.default.post(name: .notificationsRead, object: nil)
        }

        NotificationCenter.default.addObserver(
            self, selector: #selector(keyboardWillChange),
            name: UIResponder.keyboardWillChangeFrameNotification, object: nil
        )
    }

    // MARK: - Setup

    private func setupUI() {
        view.addSubview(tableView)
        view.addSubview(inputContainer)
        inputContainer.addSubview(textField)
        inputContainer.addSubview(sendButton)
        sendButton.addTarget(self, action: #selector(sendTapped), for: .touchUpInside)

        let p: CGFloat = 16
        let safe = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: safe.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: inputContainer.topAnchor),

            inputContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            inputContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            inputContainer.bottomAnchor.constraint(equalTo: safe.bottomAnchor),
            inputContainer.heightAnchor.constraint(greaterThanOrEqualToConstant: 60),

            textField.topAnchor.constraint(equalTo: inputContainer.topAnchor, constant: p),
            textField.leadingAnchor.constraint(equalTo: inputContainer.leadingAnchor, constant: p),
            textField.bottomAnchor.constraint(equalTo: inputContainer.bottomAnchor, constant: -p),

            sendButton.leadingAnchor.constraint(equalTo: textField.trailingAnchor, constant: 12),
            sendButton.trailingAnchor.constraint(equalTo: inputContainer.trailingAnchor, constant: -p),
            sendButton.centerYAnchor.constraint(equalTo: textField.centerYAnchor),
            sendButton.widthAnchor.constraint(equalToConstant: 40),
            sendButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }

    private func bindViewModel() {
        viewModel.$messages
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.tableView.reloadData()
                self?.scrollToBottom()
            }
            .store(in: &cancellables)

        viewModel.$isSending
            .receive(on: DispatchQueue.main)
            .sink { [weak self] sending in
                self?.sendButton.isEnabled = !sending
                self?.textField.isEnabled = !sending
            }
            .store(in: &cancellables)
    }

    // MARK: - Actions

    @objc private func sendTapped() {
        guard let text = textField.text, !text.isEmpty else { return }
        textField.text = ""
        Task {
            do {
                try await viewModel.sendMessage(text)
            } catch {
                await MainActor.run { self.textField.text = text }
            }
        }
    }

    @objc private func keyboardWillChange(_ notification: Notification) {
        guard let frame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
              let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double
        else { return }
        let keyboardHeight = max(0, view.bounds.height - frame.origin.y)
        UIView.animate(withDuration: duration) {
            self.tableView.contentInset.bottom = keyboardHeight
            self.tableView.verticalScrollIndicatorInsets.bottom = keyboardHeight
        }
        scrollToBottom()
    }

    private func scrollToBottom() {
        let count = viewModel.messages.count
        guard count > 0 else { return }
        tableView.scrollToRow(at: IndexPath(row: count - 1, section: 0), at: .bottom, animated: false)
    }
}

// MARK: - UITableViewDataSource / Delegate

extension ChatViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.messages.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatMessageCell", for: indexPath) as! ChatMessageCell
        let msg = viewModel.messages[indexPath.row]
        cell.configure(with: msg, isFromCurrentUser: msg.senderId == viewModel.currentUserId)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - ChatMessageCell

final class ChatMessageCell: UITableViewCell {

    private let bubbleView: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.layer.cornerRadius = 16
        v.clipsToBounds = true
        return v
    }()

    private let messageLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = .systemFont(ofSize: 16)
        l.numberOfLines = 0
        return l
    }()

    private var leadingConstraint: NSLayoutConstraint?
    private var trailingConstraint: NSLayoutConstraint?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .systemBackground
        contentView.addSubview(bubbleView)
        bubbleView.addSubview(messageLabel)

        leadingConstraint = bubbleView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16)
        trailingConstraint = bubbleView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)

        NSLayoutConstraint.activate([
            bubbleView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6),
            bubbleView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -6),
            bubbleView.widthAnchor.constraint(lessThanOrEqualToConstant: 280),

            messageLabel.topAnchor.constraint(equalTo: bubbleView.topAnchor, constant: 10),
            messageLabel.bottomAnchor.constraint(equalTo: bubbleView.bottomAnchor, constant: -10),
            messageLabel.leadingAnchor.constraint(equalTo: bubbleView.leadingAnchor, constant: 12),
            messageLabel.trailingAnchor.constraint(equalTo: bubbleView.trailingAnchor, constant: -12)
        ])
    }

    required init?(coder: NSCoder) { fatalError() }

    func configure(with message: ChatMessage, isFromCurrentUser: Bool) {
        messageLabel.text = message.text
        if isFromCurrentUser {
            bubbleView.backgroundColor = .systemBlue
            messageLabel.textColor = .white
            leadingConstraint?.isActive = false
            trailingConstraint?.isActive = true
        } else {
            bubbleView.backgroundColor = .systemGray6
            messageLabel.textColor = .label
            trailingConstraint?.isActive = false
            leadingConstraint?.isActive = true
        }
    }
}

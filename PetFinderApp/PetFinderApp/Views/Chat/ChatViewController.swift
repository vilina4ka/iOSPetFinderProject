//
//  ChatViewController.swift
//  PetFinderApp
//
//  Created by Вилина Ольховская on 18.03.2026.
//
import UIKit
import Combine
import PhotosUI
import Kingfisher
import UniformTypeIdentifiers

final class ChatViewController: UIViewController {

    // MARK: - Properties

    private let viewModel: ChatViewModel
    private var cancellables = Set<AnyCancellable>()
    private var editingMessageId: String?
    private var editBannerHeightConstraint: NSLayoutConstraint!
    private var inputContainerBottomConstraint: NSLayoutConstraint!

    // MARK: - UI

    private let tableView: UITableView = {
        let tv = UITableView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.separatorStyle = .none
        tv.backgroundColor = .systemBackground
        tv.register(ChatMessageCell.self, forCellReuseIdentifier: "ChatMessageCell")
        tv.estimatedRowHeight = 80
        tv.rowHeight = UITableView.automaticDimension
        tv.keyboardDismissMode = .interactive
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

    // Edit banner
    private let editBanner: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = UIColor.accent.withAlphaComponent(0.12)
        v.isHidden = true
        return v
    }()
    private let editBannerLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = .systemFont(ofSize: 13)
        l.textColor = .accent
        l.text = "Редактирование сообщения"
        return l
    }()
    private let editBannerCancelButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
        btn.tintColor = .accent
        return btn
    }()

    private let attachButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setImage(UIImage(systemName: "paperclip"), for: .normal)
        btn.tintColor = .accent
        return btn
    }()

    // Multiline text view replacing UITextField
    private let textView: UITextView = {
        let tv = UITextView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.font = .systemFont(ofSize: 16)
        tv.backgroundColor = .systemGray6
        tv.layer.cornerRadius = 16
        tv.layer.masksToBounds = true
        tv.textContainerInset = UIEdgeInsets(top: 8, left: 12, bottom: 8, right: 12)
        tv.textContainer.lineFragmentPadding = 0
        tv.isScrollEnabled = false
        tv.returnKeyType = .default
        return tv
    }()

    private let placeholderLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.text = "Написать сообщение..."
        l.font = .systemFont(ofSize: 16)
        l.textColor = .placeholderText
        return l
    }()

    private let sendButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setImage(UIImage(systemName: "paperplane.fill"), for: .normal)
        btn.tintColor = .accent
        return btn
    }()

    // MARK: - Init

    init(
        pet: Pet,
        recipientId: String,
        recipientName: String = "",
        recipientAvatar: String = "",
        sightingId: String? = nil
    ) {
        self.viewModel = ChatViewModel(
            pet: pet,
            recipientId: recipientId,
            recipientName: recipientName,
            recipientAvatar: recipientAvatar,
            sightingId: sightingId
        )
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { fatalError() }

    // MARK: - Lifecycle

    deinit {
        viewModel.disconnectWebSocket()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupTitleView()
        setupUI()
        tableView.dataSource = self
        tableView.delegate = self
        textView.delegate = self
        bindViewModel()

        Task {
            await viewModel.loadMessages()
            await viewModel.markMessagesRead()
            NotificationCenter.default.post(name: .notificationsRead, object: nil)
        }

        viewModel.connectWebSocket()

        NotificationCenter.default.addObserver(
            self, selector: #selector(keyboardWillChange),
            name: UIResponder.keyboardWillChangeFrameNotification, object: nil
        )
    }

    // MARK: - Title View

    private func setupTitleView() {
        let nameLabel = UILabel()
        nameLabel.font = .systemFont(ofSize: 17, weight: .bold)
        nameLabel.textAlignment = .center
        nameLabel.text = viewModel.recipientName.isEmpty ? "Чат" : viewModel.recipientName

        let subtitleLabel = UILabel()
        subtitleLabel.font = .systemFont(ofSize: 12)
        subtitleLabel.textColor = .secondaryLabel
        subtitleLabel.textAlignment = .center
        subtitleLabel.text = "по объявлению: \(viewModel.petName)"

        let stack = UIStackView(arrangedSubviews: [nameLabel, subtitleLabel])
        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = 1
        navigationItem.titleView = stack
    }

    // MARK: - Setup

    private func setupUI() {
        view.addSubview(tableView)
        view.addSubview(inputContainer)

        inputContainer.addSubview(editBanner)
        editBanner.addSubview(editBannerLabel)
        editBanner.addSubview(editBannerCancelButton)

        inputContainer.addSubview(attachButton)
        inputContainer.addSubview(textView)
        textView.addSubview(placeholderLabel)
        inputContainer.addSubview(sendButton)

        attachButton.addTarget(self, action: #selector(attachTapped), for: .touchUpInside)
        sendButton.addTarget(self, action: #selector(sendTapped), for: .touchUpInside)
        editBannerCancelButton.addTarget(self, action: #selector(cancelEdit), for: .touchUpInside)

        let p: CGFloat = 8
        let safe = view.safeAreaLayoutGuide

        editBannerHeightConstraint = editBanner.heightAnchor.constraint(equalToConstant: 0)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: safe.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: inputContainer.topAnchor),

            inputContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            inputContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
        inputContainerBottomConstraint = inputContainer.bottomAnchor.constraint(equalTo: safe.bottomAnchor)
        inputContainerBottomConstraint.isActive = true
        NSLayoutConstraint.activate([

            // Edit banner — height 0 when hidden, 28 when active
            editBanner.topAnchor.constraint(equalTo: inputContainer.topAnchor),
            editBanner.leadingAnchor.constraint(equalTo: inputContainer.leadingAnchor),
            editBanner.trailingAnchor.constraint(equalTo: inputContainer.trailingAnchor),
            editBannerHeightConstraint,

            editBannerLabel.leadingAnchor.constraint(equalTo: editBanner.leadingAnchor, constant: 12),
            editBannerLabel.centerYAnchor.constraint(equalTo: editBanner.centerYAnchor),
            editBannerCancelButton.trailingAnchor.constraint(equalTo: editBanner.trailingAnchor, constant: -8),
            editBannerCancelButton.centerYAnchor.constraint(equalTo: editBanner.centerYAnchor),
            editBannerCancelButton.widthAnchor.constraint(equalToConstant: 24),
            editBannerCancelButton.heightAnchor.constraint(equalToConstant: 24),

            // Attach button
            attachButton.leadingAnchor.constraint(equalTo: inputContainer.leadingAnchor, constant: p),
            attachButton.bottomAnchor.constraint(equalTo: inputContainer.bottomAnchor, constant: -p),
            attachButton.widthAnchor.constraint(equalToConstant: 30),
            attachButton.heightAnchor.constraint(equalToConstant: 30),

            // Send button
            sendButton.trailingAnchor.constraint(equalTo: inputContainer.trailingAnchor, constant: -p),
            sendButton.bottomAnchor.constraint(equalTo: inputContainer.bottomAnchor, constant: -p),
            sendButton.widthAnchor.constraint(equalToConstant: 30),
            sendButton.heightAnchor.constraint(equalToConstant: 30),

            // Text view expands between attach and send, up to 5 lines
            textView.topAnchor.constraint(equalTo: editBanner.bottomAnchor, constant: p),
            textView.leadingAnchor.constraint(equalTo: attachButton.trailingAnchor, constant: 6),
            textView.trailingAnchor.constraint(equalTo: sendButton.leadingAnchor, constant: -6),
            textView.bottomAnchor.constraint(equalTo: inputContainer.bottomAnchor, constant: -p),
            textView.heightAnchor.constraint(greaterThanOrEqualToConstant: 36),
            textView.heightAnchor.constraint(lessThanOrEqualToConstant: 120),

            // Placeholder inside textView
            placeholderLabel.leadingAnchor.constraint(equalTo: textView.leadingAnchor, constant: 17),
            placeholderLabel.centerYAnchor.constraint(equalTo: textView.centerYAnchor),
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
                self?.textView.isEditable = !sending
                self?.attachButton.isEnabled = !sending
            }
            .store(in: &cancellables)

        viewModel.$errorMessage
            .receive(on: DispatchQueue.main)
            .compactMap { $0 }
            .sink { [weak self] message in
                let alert = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                self?.present(alert, animated: true)
            }
            .store(in: &cancellables)
    }

    // MARK: - Edit mode

    private func startEditing(message: ChatMessage) {
        editingMessageId = message.id
        textView.text = message.text
        placeholderLabel.isHidden = true
        textView.becomeFirstResponder()
        editBannerHeightConstraint.constant = 28
        editBanner.isHidden = false
        sendButton.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
        attachButton.isHidden = true
    }

    @objc private func cancelEdit() {
        editingMessageId = nil
        textView.text = ""
        placeholderLabel.isHidden = false
        editBannerHeightConstraint.constant = 0
        editBanner.isHidden = true
        sendButton.setImage(UIImage(systemName: "paperplane.fill"), for: .normal)
        attachButton.isHidden = false
        textView.resignFirstResponder()
        textView.isScrollEnabled = false
    }

    // MARK: - Actions

    @objc private func attachTapped() {
        let sheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        sheet.addAction(UIAlertAction(title: "Фото", style: .default) { [weak self] _ in self?.presentPhotoPicker() })
        sheet.addAction(UIAlertAction(title: "Файл",  style: .default) { [weak self] _ in self?.presentFilePicker()  })
        sheet.addAction(UIAlertAction(title: "Отмена", style: .cancel))
        present(sheet, animated: true)
    }

    private func presentPhotoPicker() {
        var config = PHPickerConfiguration()
        config.selectionLimit = 5
        config.filter = .images
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = self
        present(picker, animated: true)
    }

    private func presentFilePicker() {
        let picker = UIDocumentPickerViewController(forOpeningContentTypes: [.item], asCopy: true)
        picker.allowsMultipleSelection = true
        picker.delegate = self
        present(picker, animated: true)
    }

    @objc private func sendTapped() {
        let text = textView.text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !text.isEmpty else { return }

        if let editId = editingMessageId {
            let finalText = text
            cancelEdit()
            Task {
                do { try await viewModel.editMessage(id: editId, text: finalText) }
                catch { showError("Не удалось изменить сообщение") }
            }
        } else {
            textView.text = ""
            placeholderLabel.isHidden = false
            textView.isScrollEnabled = false
            Task {
                do { try await viewModel.sendMessage(text) }
                catch { await MainActor.run { self.textView.text = text; self.placeholderLabel.isHidden = true } }
            }
        }
    }

    @objc private func keyboardWillChange(_ notification: Notification) {
        guard let frame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
              let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double
        else { return }
        let keyboardHeight = max(0, view.bounds.height - frame.origin.y)
        let safeBottom = view.safeAreaInsets.bottom
        let offset = keyboardHeight > 0 ? -(keyboardHeight - safeBottom) : 0
        inputContainerBottomConstraint.constant = offset
        UIView.animate(withDuration: duration) {
            self.view.layoutIfNeeded()
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

    private func showError(_ message: String) {
        let alert = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - UITextViewDelegate

extension ChatViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = !textView.text.isEmpty
        // Allow the view to grow up to the lessThanOrEqualTo 120 constraint.
        // Enable scrolling once we hit the cap so content stays accessible.
        let size = textView.sizeThatFits(CGSize(width: textView.frame.width, height: .infinity))
        textView.isScrollEnabled = size.height > 120
    }
}

// MARK: - PHPickerViewControllerDelegate

extension ChatViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        guard !results.isEmpty else { return }
        Task { @MainActor [weak self] in
            guard let self else { return }
            for result in results {
                let provider = result.itemProvider
                guard provider.canLoadObject(ofClass: UIImage.self) else { continue }
                do {
                    let image: UIImage = try await withCheckedThrowingContinuation { cont in
                        provider.loadObject(ofClass: UIImage.self) { obj, err in
                            if let img = obj as? UIImage { cont.resume(returning: img) }
                            else { cont.resume(throwing: err ?? APIError.unknown) }
                        }
                    }
                    try await self.viewModel.sendImageMessage(image)
                } catch {
                    self.showError("Не удалось отправить изображение"); break
                }
            }
        }
    }
}

// MARK: - UIDocumentPickerDelegate

extension ChatViewController: UIDocumentPickerDelegate {
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        Task { @MainActor [weak self] in
            guard let self else { return }
            for url in urls {
                do { try await self.viewModel.sendFileMessage(fileURL: url) }
                catch { self.showError("Не удалось отправить файл: \(url.lastPathComponent)"); break }
            }
        }
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
        let isFromCurrentUser = msg.senderId == viewModel.currentUserId
        cell.configure(
            with: msg,
            isFromCurrentUser: isFromCurrentUser,
            senderName: isFromCurrentUser ? "" : viewModel.recipientName,
            avatarURL:  isFromCurrentUser ? "" : viewModel.recipientAvatar
        )
        cell.onFileTapped = { [weak self] fileURL in
            guard let self else { return }
            let vc = UIActivityViewController(activityItems: [fileURL], applicationActivities: nil)
            self.present(vc, animated: true)
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    // MARK: Context menu — edit / delete own messages

    func tableView(
        _ tableView: UITableView,
        contextMenuConfigurationForRowAt indexPath: IndexPath,
        point: CGPoint
    ) -> UIContextMenuConfiguration? {
        let msg = viewModel.messages[indexPath.row]
        guard msg.senderId == viewModel.currentUserId else { return nil }

        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { [weak self] _ in
            guard let self else { return UIMenu(title: "", children: []) }
            var actions: [UIAction] = []

            if !msg.text.isEmpty && msg.fileName == nil && msg.imageUrl == nil {
                actions.append(UIAction(title: "Редактировать", image: UIImage(systemName: "pencil")) { [weak self] _ in
                    self?.startEditing(message: msg)
                })
            }
            actions.append(UIAction(title: "Удалить", image: UIImage(systemName: "trash"), attributes: .destructive) { [weak self] _ in
                self?.confirmDelete(message: msg)
            })
            return UIMenu(title: "", children: actions)
        }
    }

    private func confirmDelete(message: ChatMessage) {
        let alert = UIAlertController(title: "Удалить сообщение?", message: "Это действие нельзя отменить.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel))
        alert.addAction(UIAlertAction(title: "Удалить", style: .destructive) { [weak self] _ in
            Task {
                do { try await self?.viewModel.deleteMessage(id: message.id) }
                catch { self?.showError("Не удалось удалить сообщение") }
            }
        })
        present(alert, animated: true)
    }
}

// MARK: - ChatMessageCell

final class ChatMessageCell: UITableViewCell {

    var onFileTapped: ((URL) -> Void)?
    private var currentFileURL: URL?

    // MARK: Avatar

    private let avatarContainer: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = UIColor.accent.withAlphaComponent(0.15)
        v.layer.cornerRadius = 16
        v.clipsToBounds = true
        return v
    }()
    private let avatarInitialLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = .systemFont(ofSize: 14, weight: .semibold)
        l.textColor = .accent
        l.textAlignment = .center
        return l
    }()
    private let avatarImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 16
        return iv
    }()

    // MARK: Sender name

    private let senderNameLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = .systemFont(ofSize: 11)
        l.textColor = .secondaryLabel
        return l
    }()

    // MARK: Bubble

    private let bubbleView: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.layer.cornerRadius = 18
        v.clipsToBounds = true
        return v
    }()

    // Photo fills top of bubble edge-to-edge
    private let attachedImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.isHidden = true
        return iv
    }()

    // File attachment row
    private let fileAttachmentView: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.isHidden = true
        return v
    }()
    private let fileIconImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFit
        iv.preferredSymbolConfiguration = UIImage.SymbolConfiguration(pointSize: 28, weight: .medium)
        return iv
    }()
    private let fileNameLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = .systemFont(ofSize: 14, weight: .medium)
        l.numberOfLines = 2
        l.lineBreakMode = .byTruncatingMiddle
        return l
    }()

    private let messageLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = .systemFont(ofSize: 16)
        l.numberOfLines = 0
        return l
    }()

    private let timeLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = .systemFont(ofSize: 10)
        l.textAlignment = .right
        return l
    }()

    /// Semi-transparent dark pill shown behind time when overlaid on a photo.
    private let timePillView: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = UIColor.black.withAlphaComponent(0.42)
        v.layer.cornerRadius = 8
        v.isHidden = true
        return v
    }()

    // MARK: Constraints — direction

    private var incomingConstraints: [NSLayoutConstraint] = []
    private var outgoingConstraints: [NSLayoutConstraint] = []

    // MARK: Constraints — content type

    /// Force bubble to maxWidth when showing a photo or file (prevents narrow-image bug).
    private var bubbleFullWidthConstraint: NSLayoutConstraint!
    /// 4:3 aspect ratio for image view.
    private var imgAspectConstraint: NSLayoutConstraint!
    /// Image bottom == bubble bottom (image-only, full-bleed).
    private var imgBottomToBubble: NSLayoutConstraint!
    /// messageLabel.top == image.bottom + 8 (image + text).
    private var imgBottomToText: NSLayoutConstraint!
    /// messageLabel.top == bubble.top + 10 (text-only).
    private var textTopToBubble: NSLayoutConstraint!
    /// timeLabel.top == messageLabel.bottom + 4.
    private var timeToText: NSLayoutConstraint!
    /// fileAttachmentView.top == bubble.top + 10.
    private var fileTopToBubble: NSLayoutConstraint!
    /// timeLabel.top == fileView.bottom + 4.
    private var timeToFile: NSLayoutConstraint!

    // MARK: Init

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        contentView.backgroundColor = .systemBackground

        avatarContainer.addSubview(avatarInitialLabel)
        avatarContainer.addSubview(avatarImageView)
        contentView.addSubview(avatarContainer)
        contentView.addSubview(senderNameLabel)

        fileAttachmentView.addSubview(fileIconImageView)
        fileAttachmentView.addSubview(fileNameLabel)

        bubbleView.addSubview(attachedImageView)
        bubbleView.addSubview(fileAttachmentView)
        bubbleView.addSubview(messageLabel)
        bubbleView.addSubview(timePillView)   // behind
        bubbleView.addSubview(timeLabel)      // on top
        contentView.addSubview(bubbleView)

        let maxWidth = UIScreen.main.bounds.width * 0.72

        NSLayoutConstraint.activate([
            // Avatar
            avatarContainer.widthAnchor.constraint(equalToConstant: 32),
            avatarContainer.heightAnchor.constraint(equalToConstant: 32),
            avatarContainer.bottomAnchor.constraint(equalTo: bubbleView.bottomAnchor),
            avatarInitialLabel.centerXAnchor.constraint(equalTo: avatarContainer.centerXAnchor),
            avatarInitialLabel.centerYAnchor.constraint(equalTo: avatarContainer.centerYAnchor),
            avatarImageView.topAnchor.constraint(equalTo: avatarContainer.topAnchor),
            avatarImageView.bottomAnchor.constraint(equalTo: avatarContainer.bottomAnchor),
            avatarImageView.leadingAnchor.constraint(equalTo: avatarContainer.leadingAnchor),
            avatarImageView.trailingAnchor.constraint(equalTo: avatarContainer.trailingAnchor),

            // Sender name
            senderNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6),

            // Bubble: max width
            bubbleView.widthAnchor.constraint(lessThanOrEqualToConstant: maxWidth),
            bubbleView.topAnchor.constraint(equalTo: senderNameLabel.bottomAnchor, constant: 2),
            bubbleView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -6),

            // Image: always top/leading/trailing of bubble
            attachedImageView.topAnchor.constraint(equalTo: bubbleView.topAnchor),
            attachedImageView.leadingAnchor.constraint(equalTo: bubbleView.leadingAnchor),
            attachedImageView.trailingAnchor.constraint(equalTo: bubbleView.trailingAnchor),

            // File attachment view
            fileAttachmentView.leadingAnchor.constraint(equalTo: bubbleView.leadingAnchor, constant: 12),
            fileAttachmentView.trailingAnchor.constraint(equalTo: bubbleView.trailingAnchor, constant: -12),
            fileAttachmentView.heightAnchor.constraint(greaterThanOrEqualToConstant: 44),
            fileIconImageView.leadingAnchor.constraint(equalTo: fileAttachmentView.leadingAnchor),
            fileIconImageView.centerYAnchor.constraint(equalTo: fileAttachmentView.centerYAnchor),
            fileIconImageView.widthAnchor.constraint(equalToConstant: 32),
            fileIconImageView.heightAnchor.constraint(equalToConstant: 36),
            fileNameLabel.leadingAnchor.constraint(equalTo: fileIconImageView.trailingAnchor, constant: 10),
            fileNameLabel.trailingAnchor.constraint(equalTo: fileAttachmentView.trailingAnchor),
            fileNameLabel.topAnchor.constraint(equalTo: fileAttachmentView.topAnchor),
            fileNameLabel.bottomAnchor.constraint(equalTo: fileAttachmentView.bottomAnchor),

            // Message label
            messageLabel.leadingAnchor.constraint(equalTo: bubbleView.leadingAnchor, constant: 12),
            messageLabel.trailingAnchor.constraint(equalTo: bubbleView.trailingAnchor, constant: -12),

            // Time label: always bottom-right
            timeLabel.trailingAnchor.constraint(equalTo: bubbleView.trailingAnchor, constant: -10),
            timeLabel.bottomAnchor.constraint(equalTo: bubbleView.bottomAnchor, constant: -8),

            // Time pill: sits around timeLabel
            timePillView.topAnchor.constraint(equalTo: timeLabel.topAnchor, constant: -3),
            timePillView.bottomAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 3),
            timePillView.leadingAnchor.constraint(equalTo: timeLabel.leadingAnchor, constant: -5),
            timePillView.trailingAnchor.constraint(equalTo: timeLabel.trailingAnchor, constant: 5),
        ])

        // Conditional constraints
        bubbleFullWidthConstraint = bubbleView.widthAnchor.constraint(equalToConstant: maxWidth)
        bubbleFullWidthConstraint.priority = .defaultHigh   // overrides the lessThanOrEqual

        imgAspectConstraint  = attachedImageView.heightAnchor.constraint(equalTo: attachedImageView.widthAnchor, multiplier: 0.75)
        imgAspectConstraint.priority = .defaultHigh

        imgBottomToBubble    = attachedImageView.bottomAnchor.constraint(equalTo: bubbleView.bottomAnchor)
        imgBottomToText      = messageLabel.topAnchor.constraint(equalTo: attachedImageView.bottomAnchor, constant: 8)
        textTopToBubble      = messageLabel.topAnchor.constraint(equalTo: bubbleView.topAnchor, constant: 10)
        timeToText           = timeLabel.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 4)
        fileTopToBubble      = fileAttachmentView.topAnchor.constraint(equalTo: bubbleView.topAnchor, constant: 10)
        timeToFile           = timeLabel.topAnchor.constraint(equalTo: fileAttachmentView.bottomAnchor, constant: 4)

        incomingConstraints = [
            avatarContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            bubbleView.leadingAnchor.constraint(equalTo: avatarContainer.trailingAnchor, constant: 8),
            senderNameLabel.leadingAnchor.constraint(equalTo: avatarContainer.trailingAnchor, constant: 8),
        ]
        outgoingConstraints = [
            bubbleView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            senderNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
        ]

        let tap = UITapGestureRecognizer(target: self, action: #selector(fileViewTapped))
        fileAttachmentView.addGestureRecognizer(tap)
        fileAttachmentView.isUserInteractionEnabled = true
    }

    required init?(coder: NSCoder) { fatalError() }

    @objc private func fileViewTapped() {
        guard let url = currentFileURL else { return }
        onFileTapped?(url)
    }

    // MARK: Configure

    func configure(
        with message: ChatMessage,
        isFromCurrentUser: Bool,
        senderName: String,
        avatarURL: String
    ) {
        let hasImage = !(message.imageUrl ?? "").isEmpty && message.fileName == nil
        let hasFile  = message.fileName != nil
        let hasText  = !message.text.isEmpty

        // Reset all conditional constraints
        NSLayoutConstraint.deactivate([
            bubbleFullWidthConstraint,
            imgAspectConstraint, imgBottomToBubble, imgBottomToText,
            textTopToBubble, timeToText,
            fileTopToBubble, timeToFile,
        ])
        timePillView.isHidden = true

        if hasFile, let urlStr = message.imageUrl, let fileURL = URL(string: urlStr) {
            // ── File ──
            currentFileURL = fileURL
            attachedImageView.isHidden  = true
            messageLabel.isHidden       = true
            fileAttachmentView.isHidden = false
            fileNameLabel.text          = message.fileName
            fileIconImageView.image     = sfSymbol(for: message.fileName ?? "")
            NSLayoutConstraint.activate([bubbleFullWidthConstraint, fileTopToBubble, timeToFile])

        } else if hasImage, let urlStr = message.imageUrl, let url = URL(string: urlStr) {
            // ── Photo ──
            currentFileURL = nil
            attachedImageView.isHidden  = false
            attachedImageView.kf.setImage(with: url)
            fileAttachmentView.isHidden = true
            // Force bubble to full width so image isn't narrow before Kingfisher finishes
            NSLayoutConstraint.activate([bubbleFullWidthConstraint, imgAspectConstraint])

            if hasText {
                messageLabel.isHidden = false
                messageLabel.text     = message.text
                NSLayoutConstraint.activate([imgBottomToText, timeToText])
            } else {
                // Full-bleed: image fills entire bubble, time overlaid
                messageLabel.isHidden = true
                NSLayoutConstraint.activate([imgBottomToBubble])
                timePillView.isHidden = false
            }

        } else {
            // ── Text only ──
            currentFileURL = nil
            attachedImageView.isHidden  = true
            attachedImageView.image     = nil
            fileAttachmentView.isHidden = true
            messageLabel.isHidden       = false
            messageLabel.text           = message.text
            NSLayoutConstraint.activate([textTopToBubble, timeToText])
        }

        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        timeLabel.text = message.createdAt.map { formatter.string(from: $0) } ?? ""

        NSLayoutConstraint.deactivate(incomingConstraints)
        NSLayoutConstraint.deactivate(outgoingConstraints)

        if isFromCurrentUser {
            bubbleView.backgroundColor  = .accent
            messageLabel.textColor      = .white
            timeLabel.textColor         = UIColor.white.withAlphaComponent(0.85)
            fileNameLabel.textColor     = .white
            fileIconImageView.tintColor = UIColor.white.withAlphaComponent(0.9)
            avatarContainer.isHidden    = true
            senderNameLabel.isHidden    = true
            NSLayoutConstraint.activate(outgoingConstraints)
        } else {
            bubbleView.backgroundColor  = .systemGray6
            messageLabel.textColor      = .label
            timeLabel.textColor         = .tertiaryLabel
            fileNameLabel.textColor     = .label
            fileIconImageView.tintColor = .secondaryLabel
            avatarContainer.isHidden    = false
            senderNameLabel.isHidden    = false
            senderNameLabel.text = senderName
            if !avatarURL.isEmpty, let url = URL(string: avatarURL) {
                avatarInitialLabel.isHidden = true
                avatarImageView.isHidden    = false
                avatarImageView.tintColor   = nil
                avatarImageView.kf.setImage(with: url)
            } else if let firstChar = senderName.first {
                avatarInitialLabel.isHidden = false
                avatarInitialLabel.text     = String(firstChar).uppercased()
                avatarImageView.isHidden    = true
                avatarImageView.image       = nil
            } else {
                // Нет имени и нет аватара — показываем иконку person
                avatarInitialLabel.isHidden = true
                avatarImageView.isHidden    = false
                avatarImageView.image       = UIImage(systemName: "person.circle.fill")
                avatarImageView.tintColor   = .accent
                avatarImageView.contentMode = .scaleAspectFit
            }
            NSLayoutConstraint.activate(incomingConstraints)
        }
    }

    private func sfSymbol(for filename: String) -> UIImage? {
        let ext = (filename as NSString).pathExtension.lowercased()
        let name: String
        switch ext {
        case "pdf":                       name = "doc.richtext.fill"
        case "doc", "docx":               name = "doc.fill"
        case "xls", "xlsx":               name = "tablecells.fill"
        case "ppt", "pptx":               name = "play.rectangle.fill"
        case "jpg","jpeg","png","gif",
             "webp","heic":               name = "photo.fill"
        case "mp4","mov","avi","mkv":     name = "video.fill"
        case "mp3","aac","wav","m4a":     name = "music.note"
        case "zip","rar","7z":            name = "archivebox.fill"
        case "txt":                       name = "doc.text.fill"
        default:                          name = "doc.fill"
        }
        return UIImage(systemName: name)
    }

    // MARK: Reuse

    override func prepareForReuse() {
        super.prepareForReuse()
        NSLayoutConstraint.deactivate(incomingConstraints)
        NSLayoutConstraint.deactivate(outgoingConstraints)
        NSLayoutConstraint.deactivate([
            bubbleFullWidthConstraint,
            imgAspectConstraint, imgBottomToBubble, imgBottomToText,
            textTopToBubble, timeToText,
            fileTopToBubble, timeToFile,
        ])
        avatarImageView.kf.cancelDownloadTask()
        attachedImageView.kf.cancelDownloadTask()
        avatarImageView.image       = nil
        avatarImageView.tintColor   = nil
        avatarInitialLabel.isHidden = false
        avatarImageView.isHidden    = true
        attachedImageView.image     = nil
        attachedImageView.isHidden  = true
        fileAttachmentView.isHidden = true
        timePillView.isHidden       = true
        messageLabel.isHidden       = false
        messageLabel.text           = nil
        senderNameLabel.text        = nil
        avatarInitialLabel.text     = nil
        timeLabel.text              = nil
        fileNameLabel.text          = nil
        currentFileURL              = nil
        onFileTapped                = nil
    }
}

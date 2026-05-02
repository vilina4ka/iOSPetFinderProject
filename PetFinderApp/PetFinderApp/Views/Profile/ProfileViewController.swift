//
//  ProfileViewController.swift
//  PetFinderApp
//
//  Created by Вилина Ольховская on 07.09.2025.
//

import UIKit
import Kingfisher

class ProfileViewController: UIViewController {

    // MARK: - UI Elements

    private let profileHeaderView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 40
        imageView.clipsToBounds = true
        imageView.backgroundColor = .systemGray4
        return imageView
    }()

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 22, weight: .bold)
        return label
    }()

    private let emailLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 16)
        label.textColor = .secondaryLabel
        return label
    }()

    private let phoneLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 16)
        label.textColor = .secondaryLabel
        return label
    }()

    private lazy var myPetsButton = createMenuButton(title: "Мои объявления", iconName: "pawprint.fill")
    private lazy var formButton = createMenuButton(title: "Создать объявление", iconName: "plus.circle")
    private lazy var settingsButton = createMenuButton(title: "Настройки", iconName: "gearshape")
    private lazy var chatsButton = createMenuButton(title: "Чаты", iconName: "message")
    private lazy var favoritesButton = createMenuButton(title: "Подписки", iconName: "heart")

    private lazy var signOutButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Выйти из аккаунта", for: .normal)
        button.setTitleColor(.systemRed, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17)
        button.addTarget(self, action: #selector(signOutTapped), for: .touchUpInside)
        return button
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGroupedBackground
        title = "Профиль"
        setupUI()
        updateUserInfo()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateUserInfo()
    }

    // MARK: - UI Setup

    private func setupUI() {
        myPetsButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(myPetsButtonTapped)))
        formButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(formButtonTapped)))
        favoritesButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(favoritesButtonTapped)))
        settingsButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(settingsButtonTapped)))

        let stackView = UIStackView(arrangedSubviews: [myPetsButton, formButton, favoritesButton, settingsButton])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 12
        stackView.distribution = .fillEqually

        view.addSubview(profileHeaderView)
        profileHeaderView.addSubview(avatarImageView)
        profileHeaderView.addSubview(nameLabel)
        profileHeaderView.addSubview(emailLabel)
        profileHeaderView.addSubview(phoneLabel)

        view.addSubview(stackView)
        view.addSubview(signOutButton)

        let padding: CGFloat = 16
        let safeArea = view.safeAreaLayoutGuide

        NSLayoutConstraint.activate([
            profileHeaderView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            profileHeaderView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            profileHeaderView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            profileHeaderView.heightAnchor.constraint(greaterThanOrEqualToConstant: 120),

            avatarImageView.topAnchor.constraint(equalTo: profileHeaderView.topAnchor, constant: padding),
            avatarImageView.leadingAnchor.constraint(equalTo: profileHeaderView.leadingAnchor, constant: padding),
            avatarImageView.widthAnchor.constraint(equalToConstant: 80),
            avatarImageView.heightAnchor.constraint(equalToConstant: 80),

            nameLabel.topAnchor.constraint(equalTo: profileHeaderView.topAnchor, constant: padding),
            nameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: padding),
            nameLabel.trailingAnchor.constraint(equalTo: profileHeaderView.trailingAnchor, constant: -padding),

            emailLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            emailLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            emailLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),

            phoneLabel.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 2),
            phoneLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            phoneLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),
            phoneLabel.bottomAnchor.constraint(equalTo: profileHeaderView.bottomAnchor, constant: -padding),

            stackView.topAnchor.constraint(equalTo: profileHeaderView.bottomAnchor, constant: padding),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),

            signOutButton.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -20),
            signOutButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }

    private func createMenuButton(title: String, iconName: String) -> UIView {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        container.backgroundColor = .systemBackground
        container.layer.cornerRadius = 16

        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = title
        titleLabel.font = .systemFont(ofSize: 17, weight: .medium)

        let iconImageView = UIImageView(image: UIImage(systemName: iconName))
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        iconImageView.tintColor = .secondaryLabel
        iconImageView.contentMode = .scaleAspectFit

        container.addSubview(titleLabel)
        container.addSubview(iconImageView)

        NSLayoutConstraint.activate([
            container.heightAnchor.constraint(equalToConstant: 60),

            titleLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16),
            titleLabel.centerYAnchor.constraint(equalTo: container.centerYAnchor),

            iconImageView.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16),
            iconImageView.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 24),
            iconImageView.heightAnchor.constraint(equalToConstant: 24)
        ])

        return container
    }

    private func updateUserInfo() {
        if let user = AuthManager.shared.currentUser {
            nameLabel.text = user.name
            emailLabel.text = user.email ?? ""
            emailLabel.isHidden = (user.email == nil || user.email?.isEmpty == true)
            phoneLabel.text = user.phone ?? ""
            phoneLabel.isHidden = (user.phone == nil || user.phone?.isEmpty == true)

            if let avatarURL = user.avatarURL, !avatarURL.isEmpty, let url = URL(string: avatarURL) {
                URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
                    guard let data, let image = UIImage(data: data) else { return }
                    DispatchQueue.main.async {
                        self?.avatarImageView.image = image
                    }
                }.resume()
            } else {
                avatarImageView.image = UIImage(systemName: "person.circle.fill")
                avatarImageView.tintColor = .systemGray4
            }
        } else {
            nameLabel.text = "Не авторизирован"
            emailLabel.text = ""
            phoneLabel.text = ""
            avatarImageView.image = UIImage(systemName: "person.circle")
        }
    }

    // MARK: - Actions

    @objc private func myPetsButtonTapped() {
        let vc = MyPetsViewController()
        navigationController?.pushViewController(vc, animated: true)
    }

    @objc private func formButtonTapped() {
        let viewModel = AddEditPetViewModel()
        let vc = AddEditViewController(viewModel: viewModel)
        navigationItem.backButtonTitle = "Профиль"
        navigationController?.pushViewController(vc, animated: true)
    }

    @objc private func favoritesButtonTapped() {
        let vc = SubscriptionsViewController()
        navigationController?.pushViewController(vc, animated: true)
    }

    @objc private func settingsButtonTapped() {
        let vc = SettingsViewController()
        navigationController?.pushViewController(vc, animated: true)
    }

    @objc private func signOutTapped() {
        Task {
            do {
                try await AuthManager.shared.signOut()

                if let window = view.window, let sceneDelegate = window.windowScene?.delegate as? SceneDelegate {
                    sceneDelegate.showLoginScreen(on: window.windowScene!)
                }
            } catch {
            }
        }
    }
}

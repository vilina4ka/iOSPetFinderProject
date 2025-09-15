//
//  ProfileViewController.swift
//  PetFinderApp
//
//  Created by Вилина Ольховская on 11.09.2025.
//

import UIKit

class ProfileViewController: UIViewController {

    // MARK: - UI Elements
    
    private let profileHeaderView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var formButton = createMenuButton(title: "Заполнить форму", iconName: "doc.text")
    private lazy var settingsButton = createMenuButton(title: "Настройки", iconName: "gearshape")
    private lazy var chatsButton = createMenuButton(title: "Чаты", iconName: "message")
    private lazy var favoritesButton = createMenuButton(title: "Избранное", iconName: "heart")
    
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
    }
    
    // MARK: - UI Setup
    
    private func setupUI() {
        formButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(formButtonTapped)))
        
        let stackView = UIStackView(arrangedSubviews: [formButton, settingsButton, chatsButton, favoritesButton])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 12
        stackView.distribution = .fillEqually
        
        //view.addSubview(profileHeaderView) // TODO: Наполнить header
        view.addSubview(stackView)
        view.addSubview(signOutButton)
        
        NSLayoutConstraint.activate([
            /*
            profileHeaderView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            profileHeaderView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            profileHeaderView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            profileHeaderView.heightAnchor.constraint(equalToConstant: 100),
            */
            
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            signOutButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
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
    
    // MARK: - Actions
    
    @objc private func formButtonTapped() {
        let viewModel = AddEditPetViewModel()
        let vc = AddEditViewController(viewModel: viewModel)
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
                print("Ошибка выхода: \(error.localizedDescription)")
            }
        }
    }
}

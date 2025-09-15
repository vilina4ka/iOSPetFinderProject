//
//  LoginViewController.swift
//  PetFinderApp
//
//  Created by Вилина Ольховская on 11.09.2025.
//

import UIKit

class LoginViewController: UIViewController {

    // MARK: - UI Elements
    
    private let logoImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "logo_lapki"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Портал для поиска\nдомашних животных"
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.textColor = .darkGray
        label.textAlignment = .center
        label.numberOfLines = 2
        return label
    }()
    
    private let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Войти", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        button.backgroundColor = UIColor(red: 0, green: 149/255, blue: 255/255, alpha: 1.0) // Ярко-синий
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 28
        button.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupUI()
    }
    
    // MARK: - UI Setup
    
    private func setupUI() {
        view.addSubview(logoImageView)
        view.addSubview(subtitleLabel)
        view.addSubview(loginButton)
        
        NSLayoutConstraint.activate([
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -100),
            logoImageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.6),
            
            subtitleLabel.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 16),
            subtitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            loginButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            loginButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            loginButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30),
            loginButton.heightAnchor.constraint(equalToConstant: 56)
        ])
    }
    
    // MARK: - Actions
    
    @objc private func loginButtonTapped() {
        loginButton.isEnabled = false
        
        Task {
            do {
                try await AuthManager.shared.signInWithYandex()
                if let window = view.window, let sceneDelegate = window.windowScene?.delegate as? SceneDelegate {
                    sceneDelegate.showMainScreen(on: window.windowScene!)
                }
            } catch {
                let alert = UIAlertController(title: "Ошибка", message: error.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(alert, animated: true)
                
                self.loginButton.isEnabled = true
            }
        }
    }
}

//
//  SceneDelegate.swift
//  PetFinderApp
//
//  Created by Вилина Ольховская on 25.08.2025.
//

import UIKit
import Combine

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    // MARK: - Properties

    var window: UIWindow?
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Lifecycle

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options: UIScene.ConnectionOptions) {

        if APIClient.shared.isLoggedIn {
            showMainScreen(on: scene)
        } else {
            showLoginScreen(on: scene)
        }

        setupAuthListener(for: scene)
    }

    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        guard let url = URLContexts.first?.url else {
            return
        }


        if let components = URLComponents(url: url, resolvingAgainstBaseURL: true),
           components.scheme == "lapki",
           components.host == "auth" {
        }
    }

    // MARK: - Auth Listener

    private func setupAuthListener(for scene: UIScene) {
        AuthManager.shared.$currentUser
            .receive(on: DispatchQueue.main)
            .sink { [weak self] user in
                if user != nil {
                    self?.showMainScreen(on: scene)
                } else {
                    self?.showLoginScreen(on: scene)
                }
            }
            .store(in: &cancellables)
    }

    // MARK: - Navigation Helpers

    func showLoginScreen(on scene: UIScene) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)

        let loginVC = LoginViewController()
        window?.rootViewController = loginVC
        window?.makeKeyAndVisible()
    }

    func showMainScreen(on scene: UIScene) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)

        let feedVC = PetListViewController()
        let feedNav = UINavigationController(rootViewController: feedVC)
        feedNav.tabBarItem = UITabBarItem(
            title: "Лента",
            image: UIImage(systemName: "magnifyingglass"),
            selectedImage: UIImage(systemName: "magnifyingglass")
        )

        let chatsVC = ChatsListViewController()
        let chatsNav = UINavigationController(rootViewController: chatsVC)
        chatsNav.tabBarItem = UITabBarItem(
            title: "Чаты",
            image: UIImage(systemName: "message"),
            selectedImage: UIImage(systemName: "message.fill")
        )

        let profileVC = ProfileViewController()
        let profileNav = UINavigationController(rootViewController: profileVC)
        profileNav.tabBarItem = UITabBarItem(
            title: "Профиль",
            image: UIImage(systemName: "person"),
            selectedImage: UIImage(systemName: "person.fill")
        )

        let tabBar = UITabBarController()
        tabBar.viewControllers = [feedNav, chatsNav, profileNav]
        tabBar.tabBar.tintColor = .systemBlue

        window?.rootViewController = tabBar
        window?.makeKeyAndVisible()
    }

    // MARK: - Standard SceneDelegate Methods

    func sceneDidDisconnect(_ scene: UIScene) {
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
    }

    func sceneWillResignActive(_ scene: UIScene) {
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
    }
}

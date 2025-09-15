//
//  SceneDelegate.swift
//  PetFinderApp
//
//  Created by Вилина Ольховская on 08.09.2025.
//

import UIKit
import Supabase
import Combine

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    private var cancellables = Set<AnyCancellable>()
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options: UIScene.ConnectionOptions) {
        
        if AuthManager.shared.currentSession == nil {
            print("Сессия не найдена, показываем экран входа.")
            showLoginScreen(on: scene)
        } else {
            print("Активная сессия найдена, показываем главный экран.")
            showMainScreen(on: scene)
        }
    }
    /*
    private func setupAuthListener(for scene: UIScene) {
        AuthManager.shared.sessionStatusChanged
                .receive(on: DispatchQueue.main)
                .sink { [weak self] in
                    if AuthManager.shared.currentSession == nil {
                        self?.showLoginScreen(on: scene)
                    } else {
                        self?.showMainScreen(on: scene)
                    }
                }
                .store(in: &cancellables)
        }
    */
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        guard let url = URLContexts.first?.url else {
            return
        }
        
        print("Приложение было открыто по URL: \(url)")

        Task {
            do {
                _ = try await supabase.auth.session(from: url)
                print("Сессия успешно получена из URL.")
            
                showMainScreen(on: scene)
                
            } catch {
                print("Ошибка при получении сессии из URL: \(error)")
            }
        }
    }
    
    // MARK: - Вспомогательные функции для навигации
    
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
        
        let petListVC = PetListViewController()
        let navigationController = UINavigationController(rootViewController: petListVC)
        
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
    
    // MARK: - Стандартные методы SceneDelegate
    
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
    }
}

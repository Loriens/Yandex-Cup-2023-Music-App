//
//  SceneDelegate.swift
//  YandexCup2023MusicApp
//
//  Created by Vladislav Markov on 31.10.2023.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        let window = UIWindow(windowScene: windowScene)

        let viewController = MainAssembly.create()

        window.rootViewController = viewController
        self.window = window
        window.makeKeyAndVisible()
    }
}


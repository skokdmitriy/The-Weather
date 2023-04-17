//
//  SceneDelegate.swift
//  The Weather
//
//  Created by Дмитрий Скок on 14.04.2023.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        window?.windowScene = windowScene
        let rootViewController = WeatherViewController()
        window?.rootViewController = rootViewController
        window?.makeKeyAndVisible()
    }
}


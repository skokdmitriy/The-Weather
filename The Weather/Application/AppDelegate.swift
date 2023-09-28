//
//  AppDelegate.swift
//  The Weather
//
//  Created by Дмитрий Скок on 14.04.2023.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        let rootViewController = WeatherViewController()
        window?.rootViewController = rootViewController
        window?.makeKeyAndVisible()
        return true
    }
}

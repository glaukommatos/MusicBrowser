//
//  AppDelegate.swift
//  MusicBrowser
//
//  Created by Kyle Pointer on 24.07.21.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        setupRootViewController()
        return true
    }

    private func setupRootViewController() {
        window = UIWindow()

        let navigationController = UINavigationController(
            rootViewController: DiscoverViewController(
                collectionViewLayout: DualColumnFlowLayout()
            )
        )

        navigationController.navigationBar.prefersLargeTitles = true
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
}

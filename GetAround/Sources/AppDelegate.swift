//
//  AppDelegate.swift
//  GetAround
//
//  Created by JBR on 02/12/2019.
//  Copyright © 2019 Jérémy Brault. All rights reserved.
//

import Backend
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    // MARK: - Properties

    let window = UIWindow(frame: UIScreen.main.bounds)

    private var appCoordinator: AppCoordinator?

    // MARK: - Funcs

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        setupBackendConfiguration()

        startAppCoordinator()

        return true
    }

    private func setupBackendConfiguration() {
        guard let backendConfiguration = BackendConfiguration(rawValue: Plist.backendConfiguration) else {
            fatalError("Could not find backend configuration \"\(Plist.backendConfiguration)\" from build settings.")
        }
        BackendConfiguration.current = backendConfiguration
    }

    private func startAppCoordinator() {
        let rootViewController = UIViewController()
        window.rootViewController = rootViewController
        window.makeKeyAndVisible()

        appCoordinator = AppCoordinator(rootViewController: rootViewController)
        appCoordinator?.start()
    }
}

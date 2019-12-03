//
//  AppCoordinator.swift
//  GetAround
//
//  Created by JBR on 02/12/2019.
//  Copyright © 2019 Jérémy Brault. All rights reserved.
//

import Foundation
import UIKitUtils

final class AppCoordinator: Coordinator {

    // MARK: - Properties

    private(set) var child: Coordinator?

    unowned let rootViewController: UIViewController

    // MARK: - Init

    init(rootViewController: UIViewController) {
        self.rootViewController = rootViewController
    }

    // MARK: - Funcs

    func start() {
        startCarsFlowCoordinator()
    }

    private func startCarsFlowCoordinator() {
        child?.stop()

        let carsFlowCoordinator = CarsFlowCoordinator()
        carsFlowCoordinator.start()
        carsFlowCoordinator.rootViewController.embed(in: rootViewController, replace: true)

        child = carsFlowCoordinator
    }
}

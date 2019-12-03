//
//  CarsFlowCoordinator.swift
//  GetAround
//
//  Created by JBR on 02/12/2019.
//  Copyright © 2019 Jérémy Brault. All rights reserved.
//

import Backend
import Domain
import Foundation
import UIKitUtils

final class CarsFlowCoordinator: Coordinator {

    // MARK: - Properties

    private let navigationController = UINavigationController()

    var rootViewController: UIViewController {
        return navigationController
    }

    // MARK: - Funcs

    func start() {
        displayCarsList()
    }

    private func displayCarsList() {
        let provider = CarsProvider(remoteProvider: GetCarsWebService())
        let viewInteractor = CarsViewInteractor(provider: provider)

        let viewController = CarsViewController.create(interactor: viewInteractor)
        navigationController.pushViewController(viewController, animated: false)
    }
}

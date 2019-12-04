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

    var rootViewController: UIViewController {
        return navigationController
    }

    private let navigationController = UINavigationController()

    // MARK: - Funcs

    func start() {
        displayCarsList()
    }

    private func displayCarsList() {
        let provider = CarsProvider(remoteProvider: GetCarsWebService())
        let viewInteractor = CarsViewInteractor(provider: provider)
        viewInteractor.onCarSelected = { [unowned self] car in
            self.displayDetails(of: car)
        }

        let viewController = CarsViewController.create(interactor: viewInteractor)
        navigationController.pushViewController(viewController, animated: false)
    }

    private func displayDetails(of car: Car) {
        let viewController = CarDetailsViewController.create(state: CarDetailsViewState(car: car))
        navigationController.pushViewController(viewController, animated: false)
    }
}

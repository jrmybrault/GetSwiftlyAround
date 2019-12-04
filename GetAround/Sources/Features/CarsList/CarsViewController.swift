//
//  CarsViewController.swift
//  GetAround
//
//  Created by JBR on 02/12/2019.
//  Copyright © 2019 Jérémy Brault. All rights reserved.
//

import Domain
import FoundationUtils
import UIKitUtils

final class CarsViewState {

    var isRefreshing = Observable<Bool>(false)
    var shouldDisplayRefreshError = Observable<Bool>(false)

    var cars = Observable<[DisplayableCarItem]>([])
}

final class CarsViewController: UIViewController {

    // MARK: - Constants

    private enum Constants {

        static let estimatedRowHeight: CGFloat = 206
    }

    // MARK: - Properties

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(cellType: CarViewCell.self)
        tableView.estimatedRowHeight = Constants.estimatedRowHeight
        tableView.rowHeight = UITableView.automaticDimension
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        tableView.refreshControl = refreshControl

        tableView.dataSource = self
        tableView.delegate = self

        return tableView
    }()
    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(onPullToRefresh), for: .valueChanged)
        return refreshControl
    }()

    private var state: CarsViewState!
    private var observingTokens = [ObservingToken]()

    private let delegateQueue = DispatchQueue.global(qos: .userInitiated)

    // MARK: - Dependencies

    private var interactor: CarsViewInteractor!

    private var photoProvider: PhotoProvider!

    // MARK: - Init

    static func create(interactor: CarsViewInteractor,
                       photoProvider: PhotoProvider = PhotoProviderFactory.create(),
                       state: CarsViewState = CarsViewState()) -> CarsViewController {
        let viewController = CarsViewController()
        viewController.interactor = interactor
        viewController.photoProvider = photoProvider
        viewController.state = state

        return viewController
    }

    deinit {
        interactor.viewState = state
    }

    // MARK: - Funcs

    override func viewDidLoad() {
        super.viewDidLoad()

        title = Translation.Car.List.title
        setupSubviewsHierarchy()

        interactor.viewState = state
    }

    private func setupSubviewsHierarchy() {
        tableView.pin(in: view)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        setupStateObserving()
    }

    private func setupStateObserving() {
        observingTokens.append(state.isRefreshing.subscribe { [weak self] isRefreshing in
            isRefreshing ? self?.refreshControl.beginRefreshing() : self?.refreshControl.endRefreshing()
        })
        observingTokens.append(state.shouldDisplayRefreshError.subscribe { [weak self] shouldDisplayRefreshError in
            if shouldDisplayRefreshError { self?.displayRefreshError() }
        })
        observingTokens.append(state.cars.subscribe { [weak self] _ in
            self?.tableView.reloadData()
        })
    }

    private func displayRefreshError() {
        let errorAlertController = UIAlertController(title: Translation.Car.List.RefreshError.title,
                                                     message: Translation.Car.List.RefreshError.message,
                                                     preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: Translation.Common.confirm, style: .default, handler: nil)

        errorAlertController.addAction(confirmAction)
        present(errorAlertController, animated: true, completion: nil)
    }

    @objc private func onPullToRefresh() {
        delegateQueue.async {
            self.interactor.onPullToRefresh()
        }
    }
}

// MARK: - UITableViewDataSource

extension CarsViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return state.cars.value.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let car = state.cars.value[indexPath.row]

        let cell: CarViewCell = tableView.dequeueReusableCell(for: indexPath)
        cell.displayCar(car, photoProvider: photoProvider)
        cell.selectionStyle = .none
        
        return cell
    }
}

// MARK: - UITableViewDelegate

extension CarsViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.interactor.onSelectCar(at: indexPath.unsignedRow)
    }
}

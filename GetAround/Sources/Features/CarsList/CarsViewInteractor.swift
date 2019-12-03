//
//  CarsViewInteractor.swift
//  GetAround
//
//  Created by JBR on 02/12/2019.
//  Copyright © 2019 Jérémy Brault. All rights reserved.
//

import Domain
import FoundationUtils

final class CarsViewInteractor {

    // MARK: - Properties

    weak var viewState: CarsViewState? {
        didSet {
            if viewState != nil {
                setupProviderObserving()

                refresh()
            } else {
                tearDownProviderObserving()
            }
        }
    }

    private var cars = [DisplayableCarItem]() {
        didSet { self.viewState?.cars.value = self.cars }
    }

    private var refreshTask: CancellableTask?

    var workQueue = DispatchQueue.global(qos: .userInitiated)

    // MARK: - Dependencies

    private let provider: CarsProvider

    // MARK: - Init

    init(provider: CarsProvider) {
        self.provider = provider
    }

    // MARK: - Funcs

    private func setupProviderObserving() {
        provider.onLoadingStateChange = { [weak self] state in
            self?.onLoadingStateChanged(state)
        }
    }

    private func onLoadingStateChanged(_ state: CarsProvider.RefreshState) {
        switch state {
        case .pending: viewState?.isRefreshing.value = true
        case .error:
            viewState?.shouldDisplayRefreshError.value = true
            viewState?.isRefreshing.value = false
        case let .succeed(cars):
            viewState?.cars.value = workQueue.sync { cars.map(DisplayableCarItem.init) }
            viewState?.isRefreshing.value = false
        }
    }

    func onPullToRefresh() {
        refresh()
    }

    private func refresh() {
        refreshTask?.cancel()
        refreshTask = provider.refresh()
    }

    private func tearDownProviderObserving() {
        provider.onLoadingStateChange = nil
    }
}

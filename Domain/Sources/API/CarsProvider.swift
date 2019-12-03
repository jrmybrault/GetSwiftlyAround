//
//  CarsProvider.swift
//  Domain
//
//  Created by JBR on 02/12/2019.
//  Copyright © 2019 Jérémy Brault. All rights reserved.
//

import FoundationUtils

public final class CarsProvider {

    public enum RefreshState {

        case pending
        case error(RefreshError)
        case succeed([Car])
    }

    public struct RefreshError: Error { }

    // MARK: - Properties

    public var onLoadingStateChange: Consumer<RefreshState>?

    // MARK: - Dependencies

    private let remoteProvider: CarsRemoteProvider

    // MARK: - Init

    public init(remoteProvider: CarsRemoteProvider) {
        self.remoteProvider = remoteProvider
    }

    // MARK: - Funcs

    public func refresh() -> CancellableTask? {
        onLoadingStateChange?(.pending)

        return remoteProvider.fetch { [weak self] result in
            switch result {
            case let .success(cars): self?.onLoadingStateChange?(RefreshState.succeed(cars))
            case .failure: self?.onLoadingStateChange?(.error(RefreshError()))
            }
        }
    }
}

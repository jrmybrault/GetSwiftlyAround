//
//  CarPhotoProvider.swift
//  Domain
//
//  Created by JBR on 02/12/2019.
//  Copyright © 2019 Jérémy Brault. All rights reserved.
//

import FoundationUtils
import UIKitUtils

public final class CarPhotoProvider {

    public enum RefreshState {

        case pending
        case error(RefreshError)
        case succeed(UIImage)
    }

    public struct RefreshError: Error { }

    // MARK: - Properties

   // public var onLoadingStateChange: Consumer<RefreshState>?

   // private var fetchTask: CancellableTask?

    // MARK: - Dependencies

    private let remoteProvider: CarPhotoRemoteProvider

    // MARK: - Init

    public init(remoteProvider: CarPhotoRemoteProvider) {
        self.remoteProvider = remoteProvider
    }

    // MARK: - Funcs

    public func refresh(photoAt url: URL, onStateChanged: @escaping Consumer<RefreshState>) -> CancellableTask? {
        onStateChanged(.pending)

        return remoteProvider.fetch(photoAt: url) { result in
            switch result {
            case let .success(image): onStateChanged(RefreshState.succeed(image))
            case .failure: onStateChanged(.error(RefreshError()))
            }
        }
    }
}

//
//  PhotoProvider.swift
//  Domain
//
//  Created by JBR on 02/12/2019.
//  Copyright © 2019 Jérémy Brault. All rights reserved.
//

import FoundationUtils
import UIKitUtils

public final class PhotoProvider {

    public enum RefreshState {

        case pending
        case error(RefreshError)
        case succeed(UIImage)
    }

    public struct RefreshError: Error { }

    // MARK: - Dependencies

    private let remoteProvider: PhotoRemoteProvider

    // MARK: - Init

    public init(remoteProvider: PhotoRemoteProvider) {
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

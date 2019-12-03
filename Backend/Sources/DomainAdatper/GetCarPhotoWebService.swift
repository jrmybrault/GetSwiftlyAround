//
//  GetCarPhotoWebService.swift
//  Backend
//
//  Created by JBR on 02/12/2019.
//  Copyright © 2019 Jérémy Brault. All rights reserved.
//

import Domain
import FoundationUtils

public final class GetCarPhotoWebService: WebService, CarPhotoRemoteProvider {

    public struct FetchError: Error { }

    // MARK: - Properties

    private let cache = NSCache<NSString, UIImage>()

    private let workQueue = DispatchQueue.global(qos: .userInitiated)

    // MARK: - Init

    public init() { }

    // MARK: - Funcs

    public func fetch(photoAt url: URL, _ onResult: @escaping Consumer<Result<UIImage, Error>>) -> CancellableTask {
        if let cachedPhoto = cachedPhoto(for: url) {
            onResult(.success(cachedPhoto))
            return CleanTask()
        }

        return httpCaller.call(url: url, onResult: { [weak self] result in
            guard case let .success(response) = result,
                let photoData = response.data else {
                    onResult(.failure(FetchError()))
                    return
            }

            self?.workQueue.async {
                guard let photoImage = UIImage(data: photoData) else {
                    onResult(.failure(FetchError()))
                    return
                }

                self?.cachePhoto(photoImage, for: url)

                onResult(.success(photoImage))
            }
        })
    }

    private func cachedPhoto(for photoURL: URL) -> UIImage? {
        return cache.object(forKey: photoURL.absoluteString as NSString)
    }

    private func cachePhoto(_ image: UIImage, for url: URL) {
        return cache.setObject(image, forKey: url.absoluteString as NSString)
    }
}

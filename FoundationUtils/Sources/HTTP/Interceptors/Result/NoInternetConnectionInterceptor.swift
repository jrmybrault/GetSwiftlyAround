//
//  NoInternetConnectionInterceptor.swift
//  FoundationUtils
//
//  Created by JBR on 21/01/2019.
//  Copyright © 2019 open. All rights reserved.
//

import Foundation

public final class NoInternetConnectionInterceptor: HTTPResultInterceptor {

    // MARK: - Properties

    private let callback: Runnable

    // MARK: - Init

    public init(callback: @escaping Runnable) {
        self.callback = callback
    }

    // MARK: - Funcs

    public func intercept(_ result: HTTPCallResult, for request: HTTPRequest) {
        if case let .failure(error) = result,
            let urlError = error as? URLError, urlError.code == URLError.notConnectedToInternet {

             callback()
        }
    }
}

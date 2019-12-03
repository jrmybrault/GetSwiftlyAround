//
//  StatusCodeResultInterceptor.swift
//  FoundationUtils
//
//  Created by JBR on 21/01/2019.
//  Copyright © 2019 open. All rights reserved.
//

import Foundation

public final class StatusCodeResultInterceptor: HTTPResultInterceptor {

    // MARK: - Properties

    private let statusCode: HTTPStatusCode

    private let callback: Runnable

    // MARK: - Init

    public init(statusCode: HTTPStatusCode, callback: @escaping Runnable) {
        self.statusCode = statusCode
        self.callback = callback
    }

    // MARK: - Funcs

    public func intercept(_ result: HTTPCallResult, for request: HTTPRequest) {
        if let responseStatusCode = result.statusCode, responseStatusCode == statusCode {
            callback()
        }
    }
}

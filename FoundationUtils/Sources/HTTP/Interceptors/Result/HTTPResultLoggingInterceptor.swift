//
//  HTTPResultLoggingInterceptor.swift
//  FoundationUtils
//
//  Created by JBR on 30/01/2019.
//  Copyright © 2019 Jérémy Brault. All rights reserved.
//

import Foundation

public final class HTTPResultLoggingInterceptor: HTTPResultInterceptor {

    // MARK: - Init

    public init() { }

    // MARK: - Funcs

    public func priority() -> UInt {
        return 0
    }

    public func intercept(_ result: HTTPCallResult, for request: HTTPRequest) {
        switch result {
        case .success: printDebug(result)
        case let .failure(error): printDebug(result, type: .error(error))
        }
    }
}

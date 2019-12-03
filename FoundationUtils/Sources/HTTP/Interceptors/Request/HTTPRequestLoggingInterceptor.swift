//
//  HTTPRequestLoggingInterceptor.swift
//  FoundationUtils
//
//  Created by JBR on 30/01/2019.
//  Copyright © 2019 Jérémy Brault. All rights reserved.
//

import Foundation

public final class HTTPRequestLoggingInterceptor: HTTPRequestInterceptor {

    // MARK: - Init

    public init() {
    }

    // MARK: - Funcs

    public func priority() -> UInt {
        return 0
    }

    public func intercept(_ request: HTTPRequest) -> HTTPRequest {
        printDebug(request)

        return request
    }
}

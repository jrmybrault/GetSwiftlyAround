//
//  AuthorizationRequestInterceptor.swift
//  FoundationUtils
//
//  Created by JBR on 20/01/2019.
//  Copyright © 2019 open. All rights reserved.
//

import Foundation

public final class AuthorizationRequestInterceptor: HTTPRequestInterceptor {

    // MARK: - Properties

    private let authorization: Authorization

    // MARK: - Init

    public init(authorization: Authorization) {
        self.authorization = authorization
    }

    // MARK: - Funcs

    public func intercept(_ request: HTTPRequest) -> HTTPRequest {
        guard let authorizationValue = authorization.value() else {
            return request
        }

        return HTTPRequest(request: request,
                           additionalHeaders: [.authorization(.bearer(authorizationValue))])
    }
}

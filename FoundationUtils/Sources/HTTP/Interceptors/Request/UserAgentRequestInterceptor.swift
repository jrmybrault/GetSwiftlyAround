//
//  UserAgentRequestInterceptor.swift
//  FoundationUtils
//
//  Created by JBR on 20/01/2019.
//  Copyright © 2019 open. All rights reserved.
//

import Foundation

public final class UserAgentRequestInterceptor: HTTPRequestInterceptor {

    // MARK: - Properties

    private let userAgent: String

    // MARK: - Init

    public init(userAgent: String) {
        self.userAgent = userAgent
    }

    // MARK: - Funcs

    public func intercept(_ request: HTTPRequest) -> HTTPRequest {
        return HTTPRequest(request: request,
                           additionalHeaders: [.userAgent(userAgent)])
    }
}

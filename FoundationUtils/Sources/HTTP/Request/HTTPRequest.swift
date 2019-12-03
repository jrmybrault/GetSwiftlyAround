//
//  HTTPRequest.swift
//  FoundationUtils
//
//  Created by JBR on 10/01/2019.
//  Copyright © 2019 open. All rights reserved.
//

import Foundation

public typealias HTTPQueryParameters = [String: String]

public struct HTTPRequest: Equatable {

    // MARK: - Properties

    public let api: HTTPAPI

    public let identifier: String
    public let method: HTTPMethod

    public let queryParameters: HTTPQueryParameters?
    public let bodyParameter: HTTPBodyParameter?

    public let headers: [HTTPHeader]

    public let interceptionName: String? // A practical way to identify a request within an interceptor

    // MARK: - Init

    public init(api: HTTPAPI,
                identifier: String,
                method: HTTPMethod = .get,
                queryParameters: HTTPQueryParameters? = nil,
                bodyParameter: HTTPBodyParameter? = nil,
                headers: [HTTPHeader] = [],
                interceptionName: String? = nil) {
        self.api = api
        self.identifier = identifier
        self.method = method
        self.queryParameters = queryParameters
        self.bodyParameter = bodyParameter
        self.headers = headers
        self.interceptionName = interceptionName
    }
    
    public init(request: HTTPRequest, additionalHeaders: [HTTPHeader]) {
        var headers = request.headers
        headers.append(contentsOf: additionalHeaders)

        self.init(api: request.api,
                  identifier: request.identifier,
                  method: request.method,
                  queryParameters: request.queryParameters,
                  bodyParameter: request.bodyParameter,
                  headers: headers,
                  interceptionName: request.interceptionName)
    }

    // MARK: - Funcs

    public static func == (lhs: HTTPRequest, rhs: HTTPRequest) -> Bool {
        return lhs.api == rhs.api
            && lhs.identifier == rhs.identifier
            && lhs.method == rhs.method
            && lhs.queryParameters == rhs.queryParameters
            && lhs.headers == rhs.headers
    }
}

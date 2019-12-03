//
//  HTTPAPI.swift
//  FoundationUtils
//
//  Created by JBR on 10/01/2019.
//  Copyright © 2019 open. All rights reserved.
//

import Foundation

public struct HTTPAPI: Equatable {

    // MARK: - Properties

    public let scheme: HTTPScheme
    public let host: String
    public let port: Int?
    public let version: String?
    public let path: String?

    public var urlComponents: URLComponents {
        var components = URLComponents()
        components.scheme = scheme.rawValue
        components.host = host.description
        components.port = port

        if let uwpVersion = version {
            components.path.append("\(uwpVersion.description)/")
        }
        if let uwpPath = path {
            components.path.append("\(uwpPath)/")
        }

        return components
    }

    public var url: URL {
        guard let url = urlComponents.url else {
            fatalError("Could not construct url from components \(urlComponents).")
        }

        return url
    }

    // MARK: - Init

    public init(scheme: HTTPScheme, host: String, port: Int? = nil, version: String? = nil, path: String? = nil) {
        self.scheme = scheme
        self.host = host
        self.port = port
        self.version = version
        self.path = path
    }
}

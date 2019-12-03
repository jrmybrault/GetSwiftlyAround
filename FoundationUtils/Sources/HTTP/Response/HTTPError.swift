//
//  HTTPError.swift
//  FoundationUtils
//
//  Created by JBR on 23/01/2019.
//  Copyright © 2019 open. All rights reserved.
//

import Foundation

public enum HTTPError: Error, CustomStringConvertible {

    case unknown
    case cancelled
    case other(HTTPURLResponse, Data?)

    // MARK: - Funcs

    public var description: String {
        let description: String

        switch self {
        case .unknown: description = "An unknowned error occured."
        case .cancelled: description = "The task has been cancelled."
        case let .other(response, data):
            let statusCode = response.statusCode()
            var otherDescription = "An HTTP error occured with status: \(statusCode) (\(statusCode.rawValue))"
            if let uwpData = data {
                otherDescription.append(" data: \(String(data: uwpData, encoding: .utf8) ?? "")")
            }
            description = otherDescription
        }

        return description
    }
}

public struct HTTPUnexpectedEmptyDataError: Error, CustomStringConvertible {

    // MARK: - Funcs

    public var description: String {
        return "A response body was expected but it was empty."
    }
}

public struct HTTPDataDecodingError: Error, CustomStringConvertible {

    // MARK: - Properties

    private let rootError: Error?

    // MARK: - Public

    init(rootError: Error?) {
        self.rootError = rootError
    }

    // MARK: - Funcs

    public var description: String {
        return "The response body decoding failed with error: \(String(describing: rootError))."
    }
}

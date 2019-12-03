//
//  HTTPCallResult.swift
//  Common
//
//  Created by JBR on 19/01/2019.
//  Copyright © 2019 open. All rights reserved.
//

import Foundation

public struct HTTPCallResponse {

    // MARK: - Properties

    let httpResponse: HTTPURLResponse
    public let data: Data?

    // MARK: - Init

    public init(httpResponse: HTTPURLResponse, data: Data?) {
        self.httpResponse = httpResponse
        self.data = data
    }
}

public struct HTTPCallDecodedResponse<Value> {

    // MARK: - Properties

    let httpResponse: HTTPURLResponse
    public let value: Value

    // MARK: - Init

    public init(httpResponse: HTTPURLResponse, value: Value) {
        self.httpResponse = httpResponse
        self.value = value
    }
}

public typealias HTTPCallResult = Result<HTTPCallResponse, Error>
public typealias HTTPCallDecodedResult<Value: Decodable> = Result<HTTPCallDecodedResponse<Value>, Error>

extension HTTPCallResult {

    public var statusCode: HTTPStatusCode? {
        switch self {
        case let .success(response): return response.httpResponse.statusCode()
        case let .failure(error):
            guard case let .some(.other(httpResponse, _)) = error as? HTTPError else { return nil }
            return httpResponse.statusCode()
        }
    }

    public var debugDescription: String {
        switch self {
        case let .success(response): return successDebugDescription(response: response)
        case let .failure(error):
            guard case let .some(.other(httpResponse, _)) = error as? HTTPError else { return "Response: \(error.localizedDescription)" }
            return "Response: \(httpResponse)"
        }
    }

    private func successDebugDescription(response: HTTPCallResponse) -> String {
        var description = "Response: \(response.httpResponse)"

        if let data = response.data,
            let dataString = String(data: data, encoding: .utf8) {

            description.append("\nData: \(dataString)")
        }

        return description
    }
}

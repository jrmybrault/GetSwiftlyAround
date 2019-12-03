//
//  URLSessionRequestLauncher.swift
//  FoundationUtils
//
//  Created by JBR on 15/05/2019.
//  Copyright © 2019 Jérémy Brault. All rights reserved.
//

import Foundation

public final class URLSessionRequestLauncher: RequestLauncher {

    // MARK: - Properties

    private let session: URLSession

    private let jsonEncoder: JSONEncoder

    // MARK: - Init

    public init(session: URLSession = URLSession.shared, jsonEncoder: JSONEncoder = JSONEncoder()) {
        self.session = session
        self.jsonEncoder = jsonEncoder
    }

    // MARK: - Funcs

    public func launch(url: URL, onResult: @escaping Consumer<HTTPCallResult>) -> CancellableTask {
        let task = session.dataTask(with: url) { [weak self] data, response, error in
            guard let strongSelf = self else { return }

            let callResponse: HTTPCallResult

            if let httpResponse = response as? HTTPURLResponse {
                callResponse = strongSelf.callResponse(data: data, response: httpResponse, error: error)
            } else {
                if let urlError = error as? URLError, urlError.isCancellation {
                    callResponse = .failure(HTTPError.cancelled)
                } else {
                    callResponse = .failure(HTTPError.unknown)
                }
            }

            onResult(callResponse)
        }

        task.resume()

        return task
    }

    public func launch(request: HTTPRequest, onResult: @escaping Consumer<HTTPCallResult>) -> CancellableTask {
        let urlRequest = request.urlRequest

        let task = session.dataTask(with: urlRequest) { [weak self] data, response, error in
            guard let strongSelf = self else { return }

            let callResponse: HTTPCallResult

            if let httpResponse = response as? HTTPURLResponse {
                callResponse = strongSelf.callResponse(data: data, response: httpResponse, error: error)
            } else {
                callResponse = .failure(HTTPError.unknown)
            }

            onResult(callResponse)
        }

        task.resume()

        return task
    }

    private func callResponse(data: Data?, response: HTTPURLResponse, error: Error?) -> HTTPCallResult {
        let callResponse: HTTPCallResult

        let statusCode = response.statusCode()

        if error != nil {
            if let urlError = error as? URLError, urlError.isCancellation {
                callResponse = .failure(HTTPError.cancelled)
            } else {
                callResponse = .failure(HTTPError.other(response, data))
            }
        } else {
            if statusCode.isSuccess {
                callResponse = .success(HTTPCallResponse(httpResponse: response, data: data))
            } else {
                callResponse = .failure(HTTPError.other(response, data))
            }
        }

        return callResponse
    }

    public func upload(request: HTTPRequest, onResult: @escaping Consumer<HTTPCallResult>) -> CancellableTask {
        let urlRequest = request.urlRequest

        let task = session.uploadTask(with: urlRequest, from: urlRequest.httpBody) { [weak self] data, response, error in
            guard let strongSelf = self else { return }

            let callResponse: HTTPCallResult

            if let httpResponse = response as? HTTPURLResponse {
                callResponse = strongSelf.callResponse(data: data, response: httpResponse, error: error)
            } else {
                callResponse = .failure(HTTPError.unknown)
            }

            onResult(callResponse)
        }

        task.resume()

        return task
    }
}

extension URLSessionDataTask: CancellableTask {

    public var isCancelled: Bool {
        return state == .canceling
    }
}

extension HTTPRequest {

    fileprivate var urlRequest: URLRequest {
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue

        var requestHeaders = headers

        if let bodyParameter = bodyParameter {
            if let bodyData = bodyParameter.data {
                urlRequest.httpBody = bodyData

                requestHeaders.append(.contentType(bodyParameter.mimeType))
                requestHeaders.append(.contentLength(UInt(bodyData.count)))
            }
        }

        requestHeaders.forEach({ urlRequest.addValue($0.value, forHTTPHeaderField: $0.key) })

        return urlRequest
    }

    fileprivate var url: URL {
        var components = api.urlComponents
        components.path.append(identifier)

        if let uwpQueryParameters = queryParameters {
            components.queryItems = uwpQueryParameters.map(URLQueryItem.init)
            components.percentEncodedQuery = components.percentEncodedQuery?.replacingOccurrences(of: "+", with: "%2B")
        }

        guard let url = components.url else { fatalError("Could not build URL with components \(components).") }

        return url
    }
}

extension HTTPRequest: CustomDebugStringConvertible {

    public var debugDescription: String {
        var description = "Request: \(method.rawValue.uppercased()) \(url)"

        if let headers = urlRequest.allHTTPHeaderFields {
            description.append("\nHeaders: \(headers)")
        }

        if let bodyData = urlRequest.httpBody,
            let bodyString = String(data: bodyData, encoding: .utf8) {

            description.append("\nData: \(bodyString)")
        }

        return description
    }
}

//
//  HTTPCaller.swift
//  FoundationUtils
//
//  Created by JBR on 16/01/2019.
//  Copyright © 2019 open. All rights reserved.
//

import Foundation

public final class HTTPCaller {

    // MARK: - Properties

    private let requestLauncher: RequestLauncher

    private let jsonDecoder: JSONDecoder

    private var requestInterceptors = [HTTPRequestInterceptor]()
    private var resultInterceptors = [HTTPResultInterceptor]()

    // MARK: - Init

    public init(requestLauncher: RequestLauncher, jsonDecoder: JSONDecoder = JSONDecoder()) {
        self.requestLauncher = requestLauncher
        self.jsonDecoder = jsonDecoder
    }

    // MARK: - Funcs

    public func call(url: URL, onResult: @escaping Consumer<HTTPCallResult>) -> CancellableTask {
        setNetworkActivityVisibility(true)

        return requestLauncher.launch(url: url) { [weak self] result in
            guard let strongSelf = self else { return }

            onResult(result)

            strongSelf.setNetworkActivityVisibility(false)
        }
    }

    public func call(request: HTTPRequest, onResult: @escaping Consumer<HTTPCallResult>) -> CancellableTask {
        setNetworkActivityVisibility(true)

        return requestLauncher.launch(request: prepareRequest(request)) { [weak self] result in
            guard let strongSelf = self else { return }

            strongSelf.processResult(result, of: request)
            onResult(result)

            strongSelf.setNetworkActivityVisibility(false)
        }
    }

    public func call<Value>(request: HTTPRequest,
                            decodingType: Value.Type,
                            onResult: @escaping Consumer<HTTPCallDecodedResult<Value>>) -> CancellableTask where Value: Decodable {
        return call(request: request) { [weak self] result in
            guard let strongSelf = self else { return }

            let mappedResult = result
                .flatMap({ response -> HTTPCallDecodedResult<Value> in
                    guard let data = response.data else {
                        return .failure(HTTPUnexpectedEmptyDataError())
                    }

                    do {
                        let decodedValue = try strongSelf.jsonDecoder.decode(decodingType, from: data)

                        return .success(HTTPCallDecodedResponse(httpResponse: response.httpResponse, value: decodedValue))
                    } catch {
                        return .failure(HTTPDataDecodingError(rootError: error))
                    }
                })
                .flatMapError({ error -> HTTPCallDecodedResult<Value> in
                    .failure(error)
                })

            onResult(mappedResult)
        }
    }

    public func upload(request: HTTPRequest, onResult: @escaping Consumer<HTTPCallResult>) -> CancellableTask {
        setNetworkActivityVisibility(true)

        return requestLauncher.upload(request: prepareRequest(request)) { [weak self] result in
            guard let strongSelf = self else { return }

            strongSelf.processResult(result, of: request)
            onResult(result)

            strongSelf.setNetworkActivityVisibility(false)
        }
    }

    public func upload<Value>(request: HTTPRequest,
                              decodingType: Value.Type,
                              onResult: @escaping Consumer<HTTPCallDecodedResult<Value>>) -> CancellableTask where Value: Decodable {
        return upload(request: request) { [weak self] result in
            guard let strongSelf = self else { return }

            let mappedResult = result
                .flatMap({ response -> HTTPCallDecodedResult<Value> in
                    guard let data = response.data else {
                        return .failure(HTTPUnexpectedEmptyDataError())
                    }

                    do {
                        let decodedValue = try strongSelf.jsonDecoder.decode(decodingType, from: data)

                        return .success(HTTPCallDecodedResponse(httpResponse: response.httpResponse, value: decodedValue))
                    } catch {
                        return .failure(HTTPDataDecodingError(rootError: error))
                    }
                })
                .flatMapError({ error -> HTTPCallDecodedResult<Value> in
                    .failure(error)
                })

            strongSelf.processResult(result, of: request)
            onResult(mappedResult)
        }
    }

    private func prepareRequest(_ request: HTTPRequest) -> HTTPRequest {
        return requestInterceptors
            .sorted(by: { interceptor1, interceptor2 in
                interceptor1.priority() > interceptor2.priority()
            })
            .reduce(request, { request, interceptor in
                interceptor.intercept(request)
            })
    }

    private func processResult(_ result: HTTPCallResult, of request: HTTPRequest) {
        return resultInterceptors
            .filter({ $0.shouldIntercept(request) })
            .sorted(by: \.priority)
            .forEach({ $0.intercept(result, for: request) })
    }

    private func setNetworkActivityVisibility(_ visible: Bool) {
        DispatchQueue.main.async {
            UIApplication.shared.isNetworkActivityIndicatorVisible = visible
        }
    }

    public func addRequestInterceptor(_ interceptor: HTTPRequestInterceptor) {
        requestInterceptors.append(interceptor)
    }

    public func removeRequestInterceptor(_ interceptor: HTTPRequestInterceptor) {
        if let interceptorIndex = requestInterceptors.firstIndex(where: { $0 === interceptor }) {
            requestInterceptors.remove(at: interceptorIndex)
        }
    }

    public func addResultInterceptor(_ interceptor: HTTPResultInterceptor) {
        resultInterceptors.append(interceptor)
    }

    public func removeResultInterceptor(_ interceptor: HTTPResultInterceptor) {
        if let interceptorIndex = resultInterceptors.firstIndex(where: { $0 === interceptor }) {
            resultInterceptors.remove(at: interceptorIndex)
        }
    }
}

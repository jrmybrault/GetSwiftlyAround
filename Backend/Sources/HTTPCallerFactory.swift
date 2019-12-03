//
//  HTTPCallerFactory.swift
//  Backend
//
//  Created by JBR on 25/11/2019.
//  Copyright © 2019 Jérémy Brault. All rights reserved.
//

import FoundationUtils

enum HTTPCallerFactory {

    // MARK: - Constants

    private enum Constants {
        static var sharedHTTPCaller: HTTPCaller = {
            let requestLauncher = URLSessionRequestLauncher(jsonEncoder: .default)
            let caller = HTTPCaller(requestLauncher: requestLauncher, jsonDecoder: .default)

            caller.addRequestInterceptor(HTTPRequestLoggingInterceptor())
            caller.addResultInterceptor(HTTPResultLoggingInterceptor())

            return caller
        }()
    }

    // MARK: - Funcs

    static func create() -> HTTPCaller {
        return Constants.sharedHTTPCaller
    }
}

extension JSONEncoder {

    static var `default`: JSONEncoder {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601

        return encoder
    }
}

extension JSONDecoder {

    static var `default`: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        return decoder
    }
}

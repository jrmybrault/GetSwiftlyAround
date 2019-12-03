//
//  MockRequestLauncher.swift
//  Backend
//
//  Created by JBR on 25/11/2019.
//  Copyright © 2019 Jérémy Brault. All rights reserved.
//

import FoundationUtils

final class MockRequestLauncher: RequestLauncher {

    // MARK: - Properties

    var dispatchQueue: DispatchQueue = DispatchQueue.global(qos: .userInitiated)

    // MARK: - Funcs

    func launch(url: URL, onResult: @escaping Consumer<HTTPCallResult>) -> CancellableTask {
        return CleanTask()
    }

    func launch(request: HTTPRequest, onResult: @escaping Consumer<HTTPCallResult>) -> CancellableTask {
        dispatchQueue.sync {
            let requestMockMatcher = "\(request.method.rawValue)_\(request.identifier)"

            guard let mockPath = Bundle(for: MockRequestLauncher.self).path(forResource: requestMockMatcher, ofType: "json") else {
                let result: HTTPCallResult = .success(HTTPCallResponse(httpResponse: HTTPURLResponse(), data: nil))
                onResult(result)

                return
            }

            let mockURL = URL(fileURLWithPath: mockPath)

            guard let mockData = try? Data(contentsOf: mockURL) else {
                fatalError("Couldn't read data from mock at: \(mockURL).")
            }

            let result: HTTPCallResult = .success(HTTPCallResponse(httpResponse: HTTPURLResponse(), data: mockData))
            onResult(result)
        }

        return CleanTask()
    }

    func upload(request: HTTPRequest, onResult: @escaping Consumer<HTTPCallResult>) -> CancellableTask {
        return CleanTask()
    }
}

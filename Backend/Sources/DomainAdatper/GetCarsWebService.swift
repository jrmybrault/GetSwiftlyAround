//
//  GetCarsWebService.swift
//  GetAround
//
//  Created by JBR on 02/12/2019.
//  Copyright © 2019 Jérémy Brault. All rights reserved.
//

import Domain
import FoundationUtils

public final class GetCarsWebService: WebService, CarsRemoteProvider {

    // MARK: - Init

    public init() { }

    // MARK: - Funcs

    public func fetch(_ onResult: @escaping Consumer<Result<[Car], Error>>) -> CancellableTask {
        let request = HTTPRequest(api: backendConfiguration.api,
                                  identifier: Resource.cars.path)

        return httpCaller.call(request: request, decodingType: [Car].self) { result in
            switch result {
            case let .success(response): onResult(.success(response.value))
            case let .failure(error): onResult(.failure(error))
            }
        }
    }
}

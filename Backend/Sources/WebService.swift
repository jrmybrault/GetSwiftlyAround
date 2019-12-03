//
//  WebService.swift
//  Backend
//
//  Created by JBR on 25/11/2019.
//  Copyright © 2019 Jérémy Brault. All rights reserved.
//

import FoundationUtils

open class WebService {

    // MARK: - Properties

    public let httpCaller: HTTPCaller
    public let backendConfiguration: BackendConfiguration

    // MARK: - Init

    init(httpCaller: HTTPCaller = HTTPCallerFactory.create(), backendConfiguration: BackendConfiguration = BackendConfiguration.current) {
        self.httpCaller = httpCaller
        self.backendConfiguration = backendConfiguration
    }
}

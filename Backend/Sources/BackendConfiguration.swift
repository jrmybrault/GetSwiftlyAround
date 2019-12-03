//
//  BackendConfiguration.swift
//  Backend
//
//  Created by JBR on 21/01/2019.
//  Copyright © 2019 open. All rights reserved.
//

import FoundationUtils

public enum BackendConfiguration: String {

    case development = "DEVELOPMENT"

    // MARK: - Constants

    public static var current: BackendConfiguration = .development

    // MARK: - Funcs

    public var description: String {
        return "Backend configuration :" +
            "\n   ---------------------------" +
            "\n    Config name      \(rawValue)" +
            "\n   ---------------------------"
    }

    private var privateAPIHost: String {
        let privateAPIHost: String

        switch self {
        case .development: privateAPIHost = "raw.githubusercontent.com"
        }

        return privateAPIHost
    }

    public var api: HTTPAPI {
        return HTTPAPI(scheme: .https, host: privateAPIHost, path: "/drivy/jobs/master/android/api")
    }
}

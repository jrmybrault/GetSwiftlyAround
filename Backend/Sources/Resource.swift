//
//  Endpoint.swift
//  Backend
//
//  Created by JBR on 25/11/2019.
//  Copyright © 2019 Jérémy Brault. All rights reserved.
//

import Foundation

enum Resource {

    case cars

    // MARK: - Funcs

    var path: String {
        let path: String

        switch self {
        case .cars: path = "cars.json"
        }

        return path
    }
}

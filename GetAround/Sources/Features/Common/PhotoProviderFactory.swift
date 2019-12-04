//
//  PhotoProviderFactory.swift
//  GetAround
//
//  Created by JBR on 02/12/2019.
//  Copyright © 2019 Jérémy Brault. All rights reserved.
//

import Backend
import Domain
import Foundation

enum PhotoProviderFactory {

    static func create() -> PhotoProvider {
        return PhotoProvider(remoteProvider: GetPhotoWebService())
    }
}

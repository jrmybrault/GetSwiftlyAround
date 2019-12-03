//
//  CarPhotoRemoteProvider.swift
//  Domain
//
//  Created by JBR on 02/12/2019.
//  Copyright © 2019 Jérémy Brault. All rights reserved.
//

import FoundationUtils

public protocol CarPhotoRemoteProvider {

    func fetch(photoAt url: URL, _ onResult: @escaping Consumer<Result<UIImage, Error>>) -> CancellableTask
}

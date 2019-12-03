//
//  CarsRemoteProvider.swift
//  Domain
//
//  Created by JBR on 02/12/2019.
//  Copyright © 2019 Jérémy Brault. All rights reserved.
//

import FoundationUtils

public protocol CarsRemoteProvider {

    func fetch(_ onResult: @escaping Consumer<Result<[Car], Error>>) -> CancellableTask
}

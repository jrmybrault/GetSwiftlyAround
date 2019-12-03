//
//  Coordinator.swift
//  GetAround
//
//  Created by JBR on 02/12/2019.
//  Copyright © 2019 Jérémy Brault. All rights reserved.
//

import Foundation
import UIKitUtils

public protocol Coordinator {

    var rootViewController: UIViewController { get }

    func start()
    func stop()
}

extension Coordinator {

    public func stop() { }
}

//
//  HTTPResultInterceptor.swift
//  FoundationUtils
//
//  Created by JBR on 21/01/2019.
//  Copyright © 2019 open. All rights reserved.
//

import Foundation

public protocol HTTPResultInterceptor: AnyObject {

    var priority: UInt { get }

    func shouldIntercept(_ request: HTTPRequest) -> Bool
    func intercept(_ result: HTTPCallResult, for request: HTTPRequest)
}

extension HTTPResultInterceptor {

    public func shouldIntercept(_ request: HTTPRequest) -> Bool {
        return true
    }
}

extension HTTPResultInterceptor {

    public var priority: UInt {
        return UInt.max
    }
}

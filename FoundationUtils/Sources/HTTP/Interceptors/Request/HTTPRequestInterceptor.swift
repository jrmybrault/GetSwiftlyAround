//
//  Interceptor.swift
//  FoundationUtils
//
//  Created by JBR on 20/01/2019.
//  Copyright © 2019 open. All rights reserved.
//

import Foundation

public protocol HTTPRequestInterceptor: AnyObject {

    func priority() -> UInt

    func intercept(_ request: HTTPRequest) -> HTTPRequest
}

extension HTTPRequestInterceptor {

    public func priority() -> UInt {
        return UInt.max
    }
}

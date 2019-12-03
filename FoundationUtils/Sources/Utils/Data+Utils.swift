//
//  Data+Utils.swift
//  FoundationUtils
//
//  Created by JBR on 18/01/2019.
//  Copyright © 2019 open. All rights reserved.
//

import Foundation

extension Data {

    public init?(base64URLEncoded string: String) {
        let base64String = string.replacingOccurrences(of: "_", with: "/")
                                 .replacingOccurrences(of: "-", with: "+")

        let base64StringLength = base64String.count
        let padLength = base64StringLength + (4 - (base64StringLength % 4)) % 4
        let paddedString = base64String.padding(toLength: padLength, withPad: "=", startingAt: 0)

        if let data = Data(base64Encoded: paddedString) {
            self = data
        } else {
            return nil
        }
    }

    public func hexEncodedString() -> String {
        return map { String(format: "%02hhx", $0) }.joined()
    }

    public mutating func append(_ string: String, encoding: String.Encoding = .utf8) {
        if let data = string.data(using: encoding) {
            append(data)
        }
    }
}

//
//  Array+Utils.swift
//  FoundationUtils
//
//  Created by JBR on 23/01/2019.
//  Copyright © 2019 open. All rights reserved.
//

import Foundation

extension Array {

    public subscript(index: UInt) -> Iterator.Element {
        return self[Int(index)]
    }
}

extension Array where Element: Equatable {

    public func unsignedFirstIndex(of element: Element) -> UInt? {
        return firstIndex(of: element).map({ UInt($0) })
    }

    public mutating func remove(element: Element) {
        removeAll(where: { $0 == element })
    }
}

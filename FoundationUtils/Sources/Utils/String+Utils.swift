//
//  String+Utils.swift
//  FoundationUtils
//
//  Created by JBR on 03/01/2019.
//  Copyright © 2019 open. All rights reserved.
//

import Foundation

extension String {

    public var isNotEmpty: Bool {
        return !isEmpty
    }

    public func trim() -> String {
        return trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

extension Optional where Wrapped == String {

    public var isEmptyOrNil: Bool {
        return self?.isEmpty ?? true
    }

    public var isNotEmptyOrNil: Bool {
        return self?.isNotEmpty ?? true
    }
}

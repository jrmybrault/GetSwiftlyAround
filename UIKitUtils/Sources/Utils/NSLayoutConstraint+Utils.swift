//
//  NSLayoutConstraint+Utils.swift
//  UIKitUtils
//
//  Created by JBR on 29/11/2019.
//  Copyright © 2019 Jérémy Brault. All rights reserved.
//

import Foundation

extension NSLayoutConstraint {

    @discardableResult
    public func activate() -> NSLayoutConstraint {
        isActive = true
        return self
    }
}

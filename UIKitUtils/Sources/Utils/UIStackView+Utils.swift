//
//  UIStackView+Utils.swift
//  UIKitUtils
//
//  Created by JBR on 29/11/2019.
//  Copyright © 2019 Jérémy Brault. All rights reserved.
//

import Foundation

extension UIStackView {

    public func addArrangedSubviews(_ subviews: [UIView]) {
        subviews.forEach({ addArrangedSubview($0) })
    }
}

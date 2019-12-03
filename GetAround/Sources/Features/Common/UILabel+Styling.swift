//
//  UILabel+Styling.swift
//  CommonUIKit
//
//  Created by JBR on 29/11/2019.
//  Copyright © 2019 Jérémy Brault. All rights reserved.
//

import Foundation
import UIKitUtils

public enum TextStyle {

    case normalText
    case importantText
    case detailsText

    // MARK: - Properties

    var font: UIFont {
        let font: UIFont

        switch self {
        case .normalText: font = .normalTextFont
        case .importantText: font = .importantTextFont
        case .detailsText: font = .detailsTextFont
        }

        return font
    }

    var color: UIColor {
        let color: UIColor

        switch self {
        case .normalText: color = .darkGray
        case .importantText: color = .black
        case .detailsText: color = .lightGray
        }

        return color
    }
}

extension UILabel {

    public func applyStyle(_ style: TextStyle) -> UILabel {
        font = style.font
        textColor = style.color

        return self
    }
}

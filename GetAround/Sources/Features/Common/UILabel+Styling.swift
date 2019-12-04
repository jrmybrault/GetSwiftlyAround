//
//  UILabel+Styling.swift
//  CommonUIKit
//
//  Created by JBR on 29/11/2019.
//  Copyright © 2019 Jérémy Brault. All rights reserved.
//

import Foundation
import UIKitUtils

extension UILabel {

    public func applyStyle(_ style: TextStyle) -> UILabel {
        font = style.font
        textColor = style.color

        return self
    }
}

public enum TextStyle {

    case normal
    case important
    case veryImportant
    case details

    // MARK: - Properties

    var font: UIFont {
        let font: UIFont

        switch self {
        case .normal: font = .preferredFont(forTextStyle: .body)
        case .important: font = .preferredFont(forTextStyle: .headline)
        case .veryImportant: font = .preferredFont(forTextStyle: .title1)
        case .details: font = .preferredFont(forTextStyle: .footnote)
        }

        return font
    }

    var color: UIColor {
        let color: UIColor

        switch self {
        case .normal: color = .darkGray
        case .important: color = .black
        case .veryImportant: color = .black
        case .details: color = .lightGray
        }

        return color
    }
}

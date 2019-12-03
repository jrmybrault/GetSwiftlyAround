//
//  UIFont+Styling.swift
//  CommonFoundation
//
//  Created by JBR on 29/11/2019.
//  Copyright © 2019 Jérémy Brault. All rights reserved.
//

import Foundation
import UIKitUtils

extension UIFont {

    static var normalTextFont: UIFont {
        return preferredFont(forTextStyle: .body)
    }

    static var importantTextFont: UIFont {
        return preferredFont(forTextStyle: .headline)
    }

    static var detailsTextFont: UIFont {
        return preferredFont(forTextStyle: .footnote)
    }
}

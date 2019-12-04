//
//  UIView+Frame.swift
//  UIKitUtils
//
//  Created by JBR on 03/12/2019.
//  Copyright © 2019 Jérémy Brault. All rights reserved.
//

import Foundation

extension UIView {

    public var position: CGPoint {
        return frame.origin
    }

    public var x: CGFloat {
        return frame.origin.x
    }

    public var y: CGFloat {
        return frame.origin.y
    }

    public var size: CGSize {
        return frame.size
    }

    public var width: CGFloat {
        return frame.size.width
    }

    public var height: CGFloat {
        return frame.size.height
    }
}

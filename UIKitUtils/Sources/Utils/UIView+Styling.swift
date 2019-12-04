//
//  UIView+Styling.swift
//  UIKitUtils
//
//  Created by JBR on 03/12/2019.
//  Copyright © 2019 Jérémy Brault. All rights reserved.
//

import Foundation
import UIKit

extension UIView {

    public struct LayerStyle {

        // MARK: - Properties

        let border: LayerBorder?
        let corner: LayerCorner?
        let shadow: LayerShadow?

        // MARK: - Init

        public init(border: LayerBorder? = nil, corner: LayerCorner? = nil, shadow: LayerShadow? = nil) {
            self.border = border
            self.corner = corner
            self.shadow = shadow
        }
    }

    public struct LayerBorder {

        // MARK: - Properties

        let width: CGFloat
        let color: CGColor?

        // MARK: - Init

        public init(width: CGFloat = 0, color: CGColor? = nil) {
            self.width = width
            self.color = color
        }
    }

    public enum LayerCorner {

        case rounded(CGFloat)
        case circle
    }

    public struct LayerShadow {

        // MARK: - Properties

        let size: CGSize
        let color: CGColor?
        let radius: CGFloat
        let opacity: Float

        // MARK: - Init

        public init(size: CGSize = .zero, color: CGColor? = nil, radius: CGFloat = 0, opacity: Float = 1) {
            self.size = size
            self.color = color
            self.radius = radius
            self.opacity = opacity
        }
    }

    // MARK: - Funcs

    @discardableResult
    public func apply(layerStyle: LayerStyle) -> Self {
        apply(border: layerStyle.border)
        apply(corner: layerStyle.corner)
        apply(shadow: layerStyle.shadow)

        return self
    }

    @discardableResult
    public func apply(border: LayerBorder?) -> Self {
        layer.borderWidth = border?.width ?? 0
        layer.borderColor = border?.color

        return self
    }

    @discardableResult
    public func apply(corner: LayerCorner?) -> Self {
        guard let corner = corner else {
            layer.cornerRadius = 0
            return self
        }

        let cornerRadius: CGFloat

        switch corner {
        case let .rounded(radius): cornerRadius = radius
        case .circle: cornerRadius = height / 2
        }

        layer.cornerRadius = cornerRadius
        layer.masksToBounds = true

        layer.setNeedsLayout()
        layer.setNeedsDisplay()

        return self
    }

    @discardableResult
    public func apply(shadow: LayerShadow?) -> Self {
        layer.shadowOffset = shadow?.size ?? .zero
        layer.shadowColor = shadow?.color
        layer.masksToBounds = shadow == nil
        layer.shadowRadius = shadow?.radius ?? 0
        layer.shadowOpacity = shadow?.opacity ?? 0

        return self
    }
}

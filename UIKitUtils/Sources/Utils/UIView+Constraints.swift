//
//  UIView+Constraints.swift
//  UIKitUtils
//
//  Created by JBR on 21/11/2019.
//  Copyright © 2019 Jérémy Brault. All rights reserved.
//

import Foundation
import UIKit

// MARK: - Pinning

public enum ViewPinningType: CaseIterable {

    case leading
    case top
    case trailing
    case bottom

    case leadingTop
    case trailingTop
    case trailingBottom
    case leadingBottom

    case horizontal
    case vertical

    case fullLeading
    case fullTop
    case fullTrailing
    case fullBottom

    case full

    // MARK: - Funcs

    var relatedToLeading: Bool {
        return [.leading, .leadingTop, .leadingBottom, .horizontal, .fullLeading, .fullTop, .fullBottom, .full].contains(self)
    }

    var relatedToTop: Bool {
        return [.top, .leadingTop, .trailingTop, .fullLeading, .vertical, .fullTop, .fullTrailing, .full].contains(self)
    }

    var relatedToTrailing: Bool {
        return [.trailing, .trailingTop, .trailingBottom, .horizontal, .fullTrailing, .fullTop, .fullBottom, .full].contains(self)
    }

    var relatedToBottom: Bool {
        return [.bottom, .leadingBottom, .trailingBottom, .vertical, .fullLeading, .fullBottom, .fullTrailing, .full].contains(self)
    }
}

public enum ViewEdgeMargin {

    case leading(CGFloat?)
    case top(CGFloat?)
    case trailing(CGFloat?)
    case bottom(CGFloat?)

    // MARK: - Funcs

    public var edge: ViewPinningType {
        switch self {
        case .leading: return .leading
        case .top: return .top
        case .trailing: return .trailing
        case .bottom: return .bottom
        }
    }

    public var margin: CGFloat {
        switch self {
        case let .leading(value): return value ?? 0
        case let .top(value): return value ?? 0
        case let .trailing(value): return value ?? 0
        case let .bottom(value): return value ?? 0
        }
    }

    public static func all(margin: CGFloat? = nil) -> [ViewEdgeMargin] {
        return [.leading(margin), .top(margin), .trailing(margin), .bottom(margin)]
    }
}

extension UIView {

    public func pin(in view: UIView) {
        view.addSubview(self)

        pinInSuperview(toEdges: ViewEdgeMargin.all())
    }

    public func pin(in view: UIView, margin: CGFloat) {
        view.addSubview(self)

        pinInSuperview(toEdges: ViewEdgeMargin.all(margin: margin))
    }

    public func pin(in view: UIView, toEdges edges: [ViewEdgeMargin]) {
        view.addSubview(self)

        pinInSuperview(toEdges: edges)
    }

    public func pinInSuperview(toEdges edges: [ViewEdgeMargin]) {
        guard let superview = superview else {
            fatalError("Could not pin edges, the view has no superview.")
        }

        translatesAutoresizingMaskIntoConstraints = false

        edges.forEach({ edgeMargin in
            switch edgeMargin {
            case .leading:
                leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: edgeMargin.margin).isActive = true
            case .top:
                topAnchor.constraint(equalTo: superview.topAnchor, constant: edgeMargin.margin).isActive = true
            case .trailing:
                superview.trailingAnchor.constraint(equalTo: trailingAnchor, constant: edgeMargin.margin).isActive = true
            case .bottom:
                superview.bottomAnchor.constraint(equalTo: bottomAnchor, constant: edgeMargin.margin).isActive = true
            }
        })
    }

    public func pin(in view: UIView, _ type: ViewPinningType) {
        view.addSubview(self)

        pinInSuperview(type)
    }

    public func pinInSuperview(_ type: ViewPinningType = .full) {
        guard let superview = superview else {
            fatalError("Could not pin edges, the view has no superview.")
        }

        translatesAutoresizingMaskIntoConstraints = false

        if type.relatedToLeading {
            leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: 0).isActive = true
        }
        if type.relatedToTop {
            topAnchor.constraint(equalTo: superview.topAnchor, constant: 0).isActive = true
        }
        if type.relatedToTrailing {
            superview.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0).isActive = true
        }
        if type.relatedToBottom {
            superview.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0).isActive = true
        }
    }

    public func pin(in scrollView: UIScrollView) {
        guard let superview = scrollView.superview else {
            fatalError("Could not pin edges, the scroolView has no superview.")
        }

        pin(in: scrollView as UIView)

        widthAnchor.constraint(equalTo: superview.widthAnchor, multiplier: 1).activate()
        let contentViewHeightConstraint = heightAnchor.constraint(equalTo: superview.heightAnchor, multiplier: 1)
        contentViewHeightConstraint.priority = .defaultLow
        contentViewHeightConstraint.isActive = true
    }
}

// MARK: - Relative placement

extension UIView {

    @discardableResult
    public func putOnTop(of view: UIView, margin: CGFloat = 0, alignHorizontalEdges: Bool = false) -> NSLayoutConstraint {
        if alignHorizontalEdges {
            self.alignHorizontalEdges(with: view, margin: margin)
        }

        return bottomAnchor.constraint(equalTo: view.topAnchor, constant: margin).activate()
    }

    @discardableResult
    public func putOnBottom(of view: UIView, margin: CGFloat = 0, alignHorizontalEdges: Bool = false) -> NSLayoutConstraint {
        if alignHorizontalEdges {
            self.alignHorizontalEdges(with: view, margin: margin)
        }

        return topAnchor.constraint(equalTo: view.bottomAnchor, constant: margin).activate()
    }

    @discardableResult
    public func putOnLeading(of view: UIView, margin: CGFloat = 0, alignVerticalEdges: Bool = false) -> NSLayoutConstraint {
        if alignVerticalEdges {
            self.alignVerticalEdges(with: view, margin: margin)
        }

        return trailingAnchor.constraint(equalTo: view.leadingAnchor, constant: margin).activate()
    }

    @discardableResult
    public func putOnTrailing(of view: UIView, margin: CGFloat = 0, alignVerticalEdges: Bool = false) -> NSLayoutConstraint {
        if alignVerticalEdges {
            self.alignVerticalEdges(with: view, margin: margin)
        }

        return leadingAnchor.constraint(equalTo: view.trailingAnchor, constant: margin).activate()
    }
}

// MARK: - Size

extension UIView {

    @discardableResult
    public func constraintWidth(to width: CGFloat) -> NSLayoutConstraint {
        return widthAnchor.constraint(equalToConstant: width).activate()
    }

    @discardableResult
    public func constraintHeight(to height: CGFloat) -> NSLayoutConstraint {
        return heightAnchor.constraint(equalToConstant: height).activate()
    }

    public func constraintSize(to size: CGFloat) {
        constraintWidth(to: size)
        heightAnchor.constraint(equalTo: widthAnchor, multiplier: 1).activate()
    }
}

// MARK: - Alignment

extension UIView {

    @discardableResult
    public func alignWithTop(of view: UIView, margin: CGFloat = 0) -> NSLayoutConstraint {
        return topAnchor.constraint(equalTo: view.topAnchor, constant: margin).activate()
    }

    @discardableResult
    public func alignWithBottom(of view: UIView, margin: CGFloat = 0) -> NSLayoutConstraint {
        return bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: margin).activate()
    }

    public func alignVerticalEdges(with view: UIView, margin: CGFloat = 0) {
        alignWithTop(of: view, margin: margin)
        alignWithBottom(of: view, margin: margin)
    }

    @discardableResult
    public func alignWithLeading(of view: UIView, margin: CGFloat = 0) -> NSLayoutConstraint {
        return leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: margin).activate()
    }

    @discardableResult
    public func alignWithTrailing(of view: UIView, margin: CGFloat = 0) -> NSLayoutConstraint {
        return trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: margin).activate()
    }

    public func alignHorizontalEdges(with view: UIView, margin: CGFloat = 0) {
        alignWithLeading(of: view, margin: margin)
        alignWithTrailing(of: view, margin: margin)
    }

    @discardableResult
    public func alignHorizontally(with view: UIView, margin: CGFloat = 0) -> NSLayoutConstraint {
        return centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: margin).activate()
    }

    @discardableResult
    public func alignVertically(with view: UIView, margin: CGFloat = 0) -> NSLayoutConstraint {
        return centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: margin).activate()
    }
}

// MARK: - Centering

extension UIView {

    public func centerInSuperview() {
        guard let superview = superview else {
            fatalError("Could not center, the view has no superview.")
        }

        translatesAutoresizingMaskIntoConstraints = false
        
        centerXAnchor.constraint(equalTo: superview.centerXAnchor).activate()
        centerYAnchor.constraint(equalTo: superview.centerYAnchor).activate()
    }

    public func center(in view: UIView) {
        translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(self)

        centerInSuperview()
    }

    @discardableResult
    public func centerHorizontally(in view: UIView) -> NSLayoutConstraint {
        translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(self)

        return alignHorizontally(with: view)
    }

    @discardableResult
    public func centerVertically(in view: UIView) -> NSLayoutConstraint {
        translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(self)

        return alignVertically(with: view)
    }
}

//
//  UIViewController+Containment.swift
//  UIKitUtils
//
//  Created by JBR on 25/11/2019.
//  Copyright © 2019 Jérémy Brault. All rights reserved.
//

import Foundation

extension UIViewController {

    public func removeFromContainer() {
        willMove(toParent: nil)
        view.removeFromSuperview()
        removeFromParent()
    }

    public func embed(in container: UIViewController, replace: Bool = false) {
        embed(in: container, within: container.view, replace: replace)
    }

    public func embed(in container: UIViewController, within view: UIView, toEdges edges: [ViewEdgeMargin] = ViewEdgeMargin.all(), replace: Bool = false) {
        if replace {
            container.children.forEach { $0.removeFromContainer() }
        }

        container.addChild(self)
        self.view.pin(in: view, toEdges: edges)
        didMove(toParent: container)
    }
}

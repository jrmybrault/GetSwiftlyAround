//
//  ObservingToken.swift
//  FoundationUtils
//
//  Created by JBR on 23/11/2019.
//  Copyright © 2019 Jérémy Brault. All rights reserved.
//

import Foundation

public class ObservingToken: Equatable, Hashable {

    // MARK: - Properties

    private let key = UUID().uuidString

    private weak var disposable: DisposableObservable?

    // MARK: - Init

    public init(disposable: DisposableObservable) {
        self.disposable = disposable
    }

    deinit {
        disposable?.unsubscribe(token: self)
    }

    // MARK: - Funcs

    public static func == (lhs: ObservingToken, rhs: ObservingToken) -> Bool {
        return lhs.key == rhs.key
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(key)
    }
}

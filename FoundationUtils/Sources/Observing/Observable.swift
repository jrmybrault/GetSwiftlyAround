//
//  Observable.swift
//  FoundationUtils
//
//  Created by JBR on 23/11/2019.
//  Copyright © 2019 Jérémy Brault. All rights reserved.
//

import Foundation

public final class Observable<T>: DisposableObservable {

    // MARK: - Properties

    public var value: T {
        didSet { notify() }
    }

    private var subscribers = [ObservingToken: Consumer<T>]()

    public var dispatchQueue: DispatchQueue?

    // MARK: - Init

    public init(_ value: T) {
        self.value = value
    }

    // MARK: - Funcs

    public func subscribe(_ subscriber: @escaping Consumer<T>) -> ObservingToken {
        subscriber(value)

        let observingToken = ObservingToken(disposable: self)
        subscribers[observingToken] = subscriber

        return observingToken
    }

    public func unsubscribe(token: ObservingToken) {
        subscribers[token] = nil
    }

    private func notify() {
        if let dispatchQueue = dispatchQueue {
            dispatchQueue.sync {
                self.subscribers.values.forEach({ $0(value) })
            }
        } else {
            DispatchQueue.executeSyncOnMain {
                self.subscribers.values.forEach({ $0(value) })
            }
        }
    }
}

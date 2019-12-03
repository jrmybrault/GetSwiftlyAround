//
//  DispatchQueue+Utils.swift
//  FoundationUtils
//
//  Created by JBR on 22/11/2019.
//  Copyright © 2019 Jérémy Brault. All rights reserved.
//

import Foundation

extension DispatchQueue {

    public static func executeSyncOnMain(_ runnable: Runnable) {
        Thread.isMainThread ? runnable() :  DispatchQueue.main.sync(execute: runnable)
    }

    public static func executeSyncOnMain<T>(_ producer: Producer<T>) -> T {
        return Thread.isMainThread ? producer() : DispatchQueue.main.sync(execute: producer)
    }
}

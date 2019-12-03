//
//  DisposableObservable.swift
//  FoundationUtils
//
//  Created by JBR on 23/11/2019.
//  Copyright © 2019 Jérémy Brault. All rights reserved.
//

import Foundation

public protocol DisposableObservable: AnyObject {

    func unsubscribe(token: ObservingToken)
}

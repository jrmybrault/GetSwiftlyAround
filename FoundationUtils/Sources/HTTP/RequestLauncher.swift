//
//  RequestLauncher.swift
//  FoundationUtils
//
//  Created by JBR on 28/08/2019.
//  Copyright © 2019 Jérémy Brault. All rights reserved.
//

import Foundation

public protocol RequestLauncher {

    @discardableResult
    func launch(url: URL, onResult: @escaping Consumer<HTTPCallResult>) -> CancellableTask

    @discardableResult
    func launch(request: HTTPRequest, onResult: @escaping Consumer<HTTPCallResult>) -> CancellableTask

    @discardableResult
    func upload(request: HTTPRequest, onResult: @escaping Consumer<HTTPCallResult>) -> CancellableTask
}

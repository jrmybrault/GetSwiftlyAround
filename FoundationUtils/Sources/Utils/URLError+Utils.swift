//
//  URLError+Utils.swift
//  FoundationUtils
//
//  Created by JBR on 23/10/2019.
//  Copyright © 2019 Jérémy Brault. All rights reserved.
//

import Foundation

extension URLError {
    
    public var isCancellation: Bool {
        return code.rawValue == NSURLErrorCancelled
    }
}

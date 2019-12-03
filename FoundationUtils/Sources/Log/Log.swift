//
//  Log.swift
//  FoundationUtils
//
//  Created by JBR on 28/08/2019.
//  Copyright © 2019 Jérémy Brault. All rights reserved.
//

import Foundation

func printDebug(_ items: Any ..., type: DebugPrintType = .default, separator: String = " ", terminator: String = "\n") {
    #if DEBUG
    print("\(type.prefix) \(items) \(type.appendix)", separator: separator, terminator: terminator)
    #endif
}

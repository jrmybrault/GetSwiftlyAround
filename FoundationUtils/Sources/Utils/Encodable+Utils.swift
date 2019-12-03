//
//  Encodable+Utils.swift
//  FoundationUtils
//
//  Created by JBR on 28/08/2019.
//  Copyright © 2019 Jérémy Brault. All rights reserved.
//

import Foundation

extension Encodable {

    func jsonData(using encoder: JSONEncoder = JSONEncoder()) -> Data? {
        do {
            return try encoder.encode(self)
        } catch {
            printDebug("Failed to encode to JSON: \(self).", type: .error(error))

            return nil
        }
    }
}

//
//  URLResponse+Utils.swift
//  FoundationUtils
//
//  Created by JBR on 21/01/2019.
//  Copyright © 2019 open. All rights reserved.
//

import Foundation

extension URLResponse {

    public func mimeType() -> MimeType? {
        guard let mimeType = mimeType else { return nil }

        let splittedMimeType = mimeType.split(separator: ";", maxSplits: 2, omittingEmptySubsequences: false)

        guard let category = MimeType.Category(rawValue: String(splittedMimeType[0])) else { return nil }

        let parameter: (key: String, value: String)?

        if splittedMimeType.count > 1 {
            let splittedParameter = splittedMimeType[1].split(separator: ":", maxSplits: 2, omittingEmptySubsequences: false)

            parameter = (key: String(splittedParameter[0]), value: String(splittedParameter[1]))
        } else {
            parameter = nil
        }

        return MimeType(category, parameter: parameter)
    }
}

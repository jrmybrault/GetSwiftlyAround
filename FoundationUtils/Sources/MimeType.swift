//
//  MimeType.swift
//  FoundationUtils
//
//  Created by JBR on 20/01/2019.
//  Copyright © 2019 open. All rights reserved.
//

import Foundation

public struct MimeType {

    public enum Category: String {

        case textHtml = "text/html"
        case json = "application/json"
        case bytes = "application/octet-stream"
        case pngImage = "image/png"
        case jpegImage = "image/jpeg"
        case multipartFormData = "multipart/form-data"
    }

    // MARK: - Properties

    let category: Category
    let parameter: (key: String, value: String)?

    // MARK: - Init

    public init(_ category: MimeType.Category, parameter: (key: String, value: String)? = nil) {
        self.category = category
        self.parameter = parameter
    }

    public var value: String {
        if let parameter = parameter {
            return "\(category.rawValue); \(parameter.key)=\(parameter.value)"
        } else {
            return category.rawValue
        }
    }
}

extension MimeType: Equatable {

    public static func == (lhs: MimeType, rhs: MimeType) -> Bool {
        return lhs.value == rhs.value
    }
}

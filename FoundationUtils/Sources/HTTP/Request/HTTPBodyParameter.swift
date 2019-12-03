//
//  HTTPBodyParameter.swift
//  FoundationUtils
//
//  Created by JBR on 28/08/2019.
//  Copyright © 2019 Jérémy Brault. All rights reserved.
//

import Foundation

public protocol HTTPBodyParameter {

    var data: Data? { get }
    var mimeType: MimeType { get }
}

public final class HTTPJSONBodyParameter: HTTPBodyParameter {

    // MARK: - Properties

    let encodable: Encodable
    let encoder: JSONEncoder

    public var data: Data? {
        return encodable.jsonData(using: encoder)
    }

    public let mimeType = MimeType(.json)

    // MARK: - Init

    public init(encodable: Encodable, encoder: JSONEncoder = JSONEncoder()) {
        self.encodable = encodable
        self.encoder = encoder
    }
}

public final class HTTPRawBodyParameter: HTTPBodyParameter {

    // MARK: - Properties

    public let data: Data?
    public let mimeType = MimeType(.bytes)

    // MARK: - Init

    public init(data: Data) {
        self.data = data
    }
}

public final class HTTPMultipartBodyParameter: HTTPBodyParameter {

    // MARK: - Properties

    let media: UploadableMedia?
    let parameters: [String: String]?
    let boundary: String

    public var data: Data? {
        return createData()
    }
    public var mimeType: MimeType {
        return MimeType(.multipartFormData, parameter: ("boundary", boundary))
    }

    // MARK: - Init

    public init(media: UploadableMedia?, parameters: [String: String]?, boundary: String = UUID().uuidString) {
        self.media = media
        self.parameters = parameters
        self.boundary = boundary
    }

    // MARK: - Funcs

    private func createData() -> Data {
        let boundarySeparator = "--\(boundary)"
        let lineBreak = "\r\n"

        var body = Data()
        let contentDispositionPrefix = "Content-Disposition: form-data;"

        if let parameters = parameters {
            parameters.forEach({ key, value in
                body.append(boundarySeparator)
                body.append(lineBreak)
                body.append("\(contentDispositionPrefix) name=\"\(key)\"")
                body.append(lineBreak)
                body.append(HTTPHeader.contentLength(value.unsignedCount).fullValue)
                body.append(lineBreak)
                body.append(lineBreak)
                body.append(value)
                body.append(lineBreak)
            })
        }

        if let media = media {
            body.append(boundarySeparator)
            body.append(lineBreak)
            body.append("\(contentDispositionPrefix) name=\"\(media.key)\"; filename=\"\(media.fileName)\"")
            body.append(lineBreak)
            body.append(HTTPHeader.contentType(media.mimeType).fullValue)
            body.append(lineBreak)
            body.append(HTTPHeader.contentLength(media.data.unsignedCount).fullValue)
            body.append(lineBreak)
            body.append(lineBreak)
            body.append(media.data)
            body.append(lineBreak)
        }

        body.append(lineBreak)
        body.append("\(boundarySeparator)--")
        body.append(lineBreak)

        return body
    }
}

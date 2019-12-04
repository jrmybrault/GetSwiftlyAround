//
//  Car.swift
//  Domain
//
//  Created by JBR on 02/12/2019.
//  Copyright © 2019 Jérémy Brault. All rights reserved.
//

import Foundation

public struct Car: Equatable, Decodable {

    public struct Owner: Equatable, Decodable {

        public let name: String
        public let pictureUrl: String
        public let rating: Rating
    }

    // MARK: - Properties

    public let brand: String
    public let model: String

    public let pictureUrl: String

    public let pricePerDay: UInt

    public let rating: Rating

    public let owner: Owner

    public var ownerPictureUrl: String {
        return owner.pictureUrl
    }

    public var ownerRating: Rating {
        return owner.rating
    }
}

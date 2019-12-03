//
//  Car.swift
//  Domain
//
//  Created by JBR on 02/12/2019.
//  Copyright © 2019 Jérémy Brault. All rights reserved.
//

import Foundation

public struct Car: Equatable, Decodable {

    public struct Rating: Equatable, Decodable {

        public let average: Float
        public let count: UInt
    }

    // MARK: - Properties

    public let brand: String
    public let model: String

    public let pictureUrl: String

    public let pricePerDay: UInt

    public let rating: Rating
}
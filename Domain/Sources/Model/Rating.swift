//
//  Rating.swift
//  Domain
//
//  Created by JBR on 04/12/2019.
//  Copyright © 2019 Jérémy Brault. All rights reserved.
//

import Foundation

public struct Rating: Equatable, Decodable {

    // MARK: - Properties

    public static let maxValue = 5

    public let average: Float
    public let count: UInt
}

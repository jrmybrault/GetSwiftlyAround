//
//  DisplayableCarItem.swift
//  GetAround
//
//  Created by JBR on 02/12/2019.
//  Copyright © 2019 Jérémy Brault. All rights reserved.
//

import Domain
import Foundation

struct DisplayableCarItem {

    // MARK: - Properties

    let pictureURL: URL?

    let displayName: String

    let pricingText: String?

    let ratingPercentage: Float?
    var shouldShowRatingImage: Bool {
        return ratingPercentage != nil
    }
    let ratingText: NSAttributedString

    // MARK: - Init

    init(car: Car) {
        self.pictureURL = URL(string: car.pictureUrl)

        self.displayName = car.displayName

        self.pricingText = car.pricingText

        self.ratingPercentage = nil
        self.ratingText = car.ratingText
    }
}

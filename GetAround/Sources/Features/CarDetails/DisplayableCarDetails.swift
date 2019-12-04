//
//  DisplayableCarDetails.swift
//  GetAround
//
//  Created by JBR on 03/12/2019.
//  Copyright © 2019 Jérémy Brault. All rights reserved.
//

import Domain
import Foundation

struct DisplayableCarDetails {

    // MARK: - Properties

    let carPictureURL: URL?
    let carDisplayName: String
    let carRatingText: NSAttributedString

    let ownerPictureURL: URL?
    let ownerDisplayName: String
    let ownerRatingText: NSAttributedString

    let pricingText: String?

    // MARK: - Init

    init(car: Car) {
        self.pricingText = Translation.Car.Details.Pricing.format(car.formattedPrice)

        self.carPictureURL = URL(string: car.pictureUrl)
        self.carDisplayName = car.displayName
        self.carRatingText = DisplayableCarDetails.carRatingText(for: car)

        self.ownerPictureURL = URL(string: car.ownerPictureUrl)
        self.ownerDisplayName = car.ownerDisplayName
        self.ownerRatingText = car.ownerRating.formattedText
    }
}

fileprivate extension DisplayableCarDetails {

    static func carRatingText(for car: Car) -> NSAttributedString {
        let attributedRatingPart1 = NSAttributedString(string: Translation.Car.Details.Car.Rating.Format.part1(car.rating.formattedValue),
                                                       attributes: [NSAttributedString.Key.foregroundColor: Asset.Colors.rating.color,
                                                                    NSAttributedString.Key.font: TextStyle.veryImportant.font])
        let attributedRatingPart2 = NSAttributedString(string: Translation.Car.Details.Car.Rating.Format.part2(Rating.maxValue),
                                                       attributes: [NSAttributedString.Key.font: TextStyle.normal.font])
        let attributedRatingPart3 = NSAttributedString(string: Translation.Car.Details.Car.Rating.Format.part3(Int(car.rating.count)))

        let ratingText = NSMutableAttributedString()
        ratingText.append(attributedRatingPart1)
        ratingText.append(attributedRatingPart2)
        ratingText.append(attributedRatingPart3)

        return ratingText
    }
}

//
//  Car+UI.swift
//  GetAround
//
//  Created by JBR on 02/12/2019.
//  Copyright © 2019 Jérémy Brault. All rights reserved.
//

import Domain
import Foundation

extension Car {

    // MARK: - Constants

    private enum Constants {

        static let priceFormatter: NumberFormatter = {
            let formatter = NumberFormatter()
            formatter.numberStyle = .currency
            return formatter
        }()

        static let ratingFormatter: NumberFormatter = {
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            formatter.minimumSignificantDigits = 2
            formatter.maximumSignificantDigits = 2
            return formatter
        }()

        static let maxRating = 5

        static let ratingStarTexts: [String] = {
            let ratings = (0...maxRating).map({ rating -> String in
                let fullRatingText = String(repeating: "★ ", count: rating)
                let emptyRatingText = String(repeating: "☆ ", count: maxRating - rating)
                let ratingText = "\(fullRatingText)\(emptyRatingText)"
                return ratingText
            })
            return ratings
        }()
    }

    // MARK: - Properties

    var displayName: String {
        return "\(brand) \(model)"
    }

    var hasRating: Bool {
        // swiftlint:disable empty_count
        return rating.count > 0
        // swiftlint:enable empty_count
    }

    var pricingText: String {
        guard let formattedPrice = Constants.priceFormatter.string(from: NSNumber(value: pricePerDay)) else {
            return Translation.Car.Pricing.unknown
        }

        return Translation.Car.Pricing.format(formattedPrice)
    }
    
    var ratingText: NSAttributedString {
        guard hasRating,
            let formattedRatingNumber = Constants.ratingFormatter.string(from: NSNumber(value: rating.average)) else {
                return NSAttributedString(string: Translation.Car.Rating.none)
        }

        let formattedRatingStarText = Constants.ratingStarTexts[Int(rating.average.rounded())]

        let attributedRatingPart1 = NSAttributedString(string: formattedRatingStarText,
                                                       attributes: [NSAttributedString.Key.foregroundColor: Asset.Colors.rating.color,
                                                                    NSAttributedString.Key.font: UIFont.normalTextFont])
        let attributedRatingPart2 = NSAttributedString(string: Translation.Car.Rating.format(formattedRatingNumber, Int(rating.count)))

        let ratingText = NSMutableAttributedString()
        ratingText.append(attributedRatingPart1)
        ratingText.append(attributedRatingPart2)

        return ratingText
    }
}

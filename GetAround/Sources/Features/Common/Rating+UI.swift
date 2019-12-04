//
//  Rating+UI.swift
//  GetAround
//
//  Created by JBR on 03/12/2019.
//  Copyright © 2019 Jérémy Brault. All rights reserved.
//

import Domain
import Foundation

extension Rating {

    // MARK: - Constants

    private enum Constants {

        static let ratingFormatter: NumberFormatter = {
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            formatter.minimumSignificantDigits = 2
            formatter.maximumSignificantDigits = 2
            return formatter
        }()

        static let ratingStarTexts: [String] = {
            let ratings = (0...Rating.maxValue).map({ rating -> String in
                let fullRatingText = String(repeating: "★", count: rating)
                let emptyRatingText = String(repeating: "☆", count: Rating.maxValue - rating)
                let ratingText = "\(fullRatingText)\(emptyRatingText)"
                return ratingText
            })
            return ratings
        }()
    }

    // MARK: - Properties

    var hasValue: Bool {
        // swiftlint:disable empty_count
        return count > 0
        // swiftlint:enable empty_count
    }

    var formattedValue: String {
        guard hasValue,
            let formattedRating = Constants.ratingFormatter.string(from: NSNumber(value: average)) else {
                return Translation.Car.Rating.none
        }

        return formattedRating
    }

    var formattedValueStarText: String {
        return Constants.ratingStarTexts[Int(average.rounded())]
    }

    var formattedText: NSAttributedString {
        let attributedRatingPart1 = NSAttributedString(string: formattedValueStarText,
                                                       attributes: [NSAttributedString.Key.foregroundColor: Asset.Colors.rating.color,
                                                                    NSAttributedString.Key.font: TextStyle.normal.font])
        let attributedRatingPart2 = NSAttributedString(string: Translation.Car.Default.Rating.format(formattedValue, Int(count)))

        let ratingText = NSMutableAttributedString()
        ratingText.append(attributedRatingPart1)
        ratingText.append(attributedRatingPart2)

        return ratingText
    }
}

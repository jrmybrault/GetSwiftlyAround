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
            formatter.minimumFractionDigits = 0
            return formatter
        }()
    }

    // MARK: - Properties

    var displayName: String {
        return "\(brand) \(model)"
    }

    var formattedPrice: String {
        guard let formattedPrice = Constants.priceFormatter.string(from: NSNumber(value: pricePerDay)) else {
            return Translation.Car.Pricing.unknown
        }

        return formattedPrice
    }

    var ownerDisplayName: String {
        return owner.name
    }
}

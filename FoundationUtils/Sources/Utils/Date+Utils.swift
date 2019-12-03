//
//  Date+Utils.swift
//  FoundationUtils
//
//  Created by JBR on 28/11/2019.
//  Copyright © 2019 Jérémy Brault. All rights reserved.
//

import Foundation

extension Date {

    // MARK: - Properties

    public static var now: Date {
        return Date()
    }

    // MARK: - Funcs

    public static func numberOfYearsSince(date: Date) -> UInt {
        let calendar = Calendar.current

        let ageComponents = calendar.dateComponents([.year], from: date, to: now)

        //swiftlint:disable force_unwrapping
        return ageComponents.year!.unsigned
        //swiftlint:enable force_unwrapping
    }
}

//
//  IndexPath+Utils.swift
//  FoundationUtils
//
//  Created by JBR on 28/11/2019.
//  Copyright © 2019 Jérémy Brault. All rights reserved.
//

import Foundation

extension IndexPath {

    // MARK: - Properties

    public var unsignedSection: UInt {
        return section.unsigned
    }

    public var unsignedRow: UInt {
        return row.unsigned
    }

    // MARK: - Init

    public init(row: UInt, section: UInt) {
        self.init(row: Int(row), section: Int(section))
    }
}

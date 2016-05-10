//
//  File.swift
//  Project3
//
//  Created by Jon Lauer on 5/9/16.
//  Copyright © 2016 Jon Lauer. All rights reserved.
//

import Foundation

// MARK: - Extending Double to format doubles as a string without the decimals
extension Double {
    var asStringWithoutDecimals: String {
        get {
            return String(format: "%.0f", self)
        }
    }
}

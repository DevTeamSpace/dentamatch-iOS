//
//  Character+Addition.swift
//  DentaMatch
//
//  Created by Rajan Maheshwari on 29/11/16.
//  Copyright © 2016 Appster. All rights reserved.
//

import Foundation

public extension Character {
    /**
     If the character represents an integer that fits into an Int, returns
     the corresponding integer.
     */
    public func toInt() -> Int? {
        return Int(String(self))
    }
}

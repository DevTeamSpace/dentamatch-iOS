//
//  Array+Additions.swift
//  DentaMatch
//
//  Created by Rajan Maheshwari on 12/10/16.
//  Copyright © 2016 Appster. All rights reserved.
//

import Foundation

extension Array where Element : Equatable {
    
    // Remove first collection element that is equal to the given 'object':
    mutating func removeObject(object : Element) {
        if let index = self.index(of: object) {
            self.remove(at: index)
        }
    }
    
    func containsObject (_ items:[NSNumber], valueToCheck:NSNumber) -> Bool {
        for (_,value) in items.enumerated() {
            if value as Int == valueToCheck as Int {
                return true
            }
        }
        return false
    }

}

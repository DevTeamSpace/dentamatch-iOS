//
//  PreferredLocation.swift
//  DentaMatch
//
//  Created by Rajan Maheshwari on 03/11/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import Foundation
import SwiftyJSON

class PreferredLocation: NSObject {
    var id = "0"
    var preferredLocationName = ""
    var isActive = false
    var isSelected = false

    override init() {
        /* For Default object of class */
    }

    init(preferredLocation: JSON) {
        id = preferredLocation[Constants.ServerKey.id].stringValue
        preferredLocationName = preferredLocation[Constants.ServerKey.preferredLocationName].stringValue
        isActive = preferredLocation[Constants.ServerKey.isActive].boolValue
    }
}

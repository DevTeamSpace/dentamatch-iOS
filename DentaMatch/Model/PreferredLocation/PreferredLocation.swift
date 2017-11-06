//
//  PreferredLocation.swift
//  DentaMatch
//
//  Created by Rajan Maheshwari on 03/11/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import Foundation
import SwiftyJSON

class PreferredLocation : NSObject {
    var id = "0"
    var preferredLocationName = ""
    var isActive = false
 
    override init() {
        /* For Default object of class */
    }
    
    init(preferredLocation:JSON) {
        self.id = preferredLocation[Constants.ServerKey.id].stringValue
        self.preferredLocationName = preferredLocation[Constants.ServerKey.preferredLocationName].stringValue
        self.isActive = preferredLocation[Constants.ServerKey.isActive].boolValue

    }
}

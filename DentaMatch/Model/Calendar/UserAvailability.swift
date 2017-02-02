//
//  UserAvailability.swift
//  DentaMatch
//
//  Created by Sanjay Kumar Yadav on 02/02/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit
import SwiftyJSON

class UserAvailability: NSObject {

    var isFulltime = false
    var isParttime = false
    var isParttimeMonday = false
    var isParttimeTuesday = false
    var isParttimeWednesday = false
    var isParttimeThursday = false
    var isParttimeFriday = false
    var isParttimeSaturday = false
    var isParttimeSunday = false
   
    override init() {
        // for empty
    }
    
    init(dict:JSON) {
        self.isFulltime = dict[""].boolValue
        self.isParttimeMonday = dict[""].boolValue
        self.isParttimeTuesday = dict[""].boolValue
        self.isParttimeWednesday = dict[""].boolValue
        self.isParttimeThursday = dict[""].boolValue
        self.isParttimeFriday = dict[""].boolValue
        self.isParttimeSaturday = dict[""].boolValue
        self.isParttimeSunday = dict[""].boolValue

    }
}

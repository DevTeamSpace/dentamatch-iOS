//
//  Affiliation.swift
//  DentaMatch
//
//  Created by Rajan Maheshwari on 13/01/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit
import SwiftyJSON

class Affiliation: NSObject {
    var affiliationId = ""
    var affiliationName = ""
    var otherAffiliation:String?
    var isSelected = false
    var isOther = false
    
    override init() {
    }
    
    init(affiliation:JSON) {
        self.affiliationId = affiliation["affiliationId"].stringValue
        self.affiliationName = affiliation["affiliationName"].stringValue
        self.otherAffiliation = affiliation["otherAffiliation"].stringValue
        self.isSelected = affiliation["jobSeekerAffiliationStatus"].boolValue
        if affiliation["affiliationName"].stringValue == "OTHER" {
            self.isOther = true
        }
    }
}

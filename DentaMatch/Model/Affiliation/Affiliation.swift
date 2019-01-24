//
//  Affiliation.swift
//  DentaMatch
//
//  Created by Rajan Maheshwari on 13/01/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import SwiftyJSON
import UIKit

class Affiliation: NSObject {
    var affiliationId = ""
    var affiliationName = ""
    var otherAffiliation: String? = ""
    var isSelected = false
    var isOther = false

    init(affiliation: JSON) {
        affiliationId = affiliation["affiliationId"].stringValue
        affiliationName = affiliation["affiliationName"].stringValue
        otherAffiliation = affiliation["otherAffiliation"].stringValue
        isSelected = affiliation["jobSeekerAffiliationStatus"].boolValue
        if affiliation["affiliationName"].stringValue == "OTHER" {
            isOther = true
        }
    }
}

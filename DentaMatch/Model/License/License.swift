//
//  License.swift
//  DentaMatch
//
//  Created by Rajan Maheshwari on 18/01/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import SwiftyJSON
import UIKit

class License: NSObject {
    var state = ""
    var number = ""

    override init() {
        /* For Default object of class */
    }

    init(license: JSON) {
        number = license[Constants.ServerKey.licenseNumber].stringValue
        state = license[Constants.ServerKey.state].stringValue
    }
}

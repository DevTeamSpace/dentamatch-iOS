//
//  Certification.swift
//  DentaMatch
//
//  Created by Rajan Maheshwari on 13/01/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit
import SwiftyJSON

class Certification: NSObject {
    var certificationId = ""
    var certificationName = ""
    
    init(certification:JSON) {
        self.certificationId = certification[Constants.ServerKey.id].stringValue
        self.certificationName = certification[Constants.ServerKey.certificateName].stringValue
    }
}

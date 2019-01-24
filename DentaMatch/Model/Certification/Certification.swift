//
//  Certification.swift
//  DentaMatch
//
//  Created by Rajan Maheshwari on 13/01/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import SwiftyJSON
import UIKit

class Certification: NSObject {
    var certificationId = ""
    var certificationName = ""
    var validityDate = ""
    var certificateImage: UIImage?
    var certificateImageURL: String? = ""
    var certificateImageForProfileScreen: String? = ""

    override init() {
        // for empty object
    }

    init(certification: JSON) {
        certificationId = certification[Constants.ServerKey.id].stringValue
        certificationName = certification[Constants.ServerKey.certificateName].stringValue
        validityDate = certification[Constants.ServerKey.validityDate].stringValue
        certificateImageURL = certification[Constants.ServerKey.imageURL].stringValue
    }
}

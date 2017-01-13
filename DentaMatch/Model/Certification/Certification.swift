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
    var validityDate = ""
    var certificateImage:UIImage?
    var certificateImageURL:String?
    
    override init () {
    }
    
    init(certification:JSON) {
        self.certificationId = certification[Constants.ServerKey.id].stringValue
        self.certificationName = certification[Constants.ServerKey.certificateName].stringValue
        self.validityDate = certification[Constants.ServerKey.validityDate].stringValue
        self.certificateImageURL = certification[Constants.ServerKey.image].stringValue
    }
}

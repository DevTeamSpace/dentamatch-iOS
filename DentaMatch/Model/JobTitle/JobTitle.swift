//
//  JobTitle.swift
//  DentaMatch
//
//  Created by Rajan Maheshwari on 09/01/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit
import SwiftyJSON

class JobTitle: NSObject {

    var jobTitle = ""
    var jobId = 0
    var jobSelected = false
    
    init(job:JSON) {
        self.jobTitle = job["jobtitle_name"].stringValue
        self.jobId = job["id"].intValue
    }
}



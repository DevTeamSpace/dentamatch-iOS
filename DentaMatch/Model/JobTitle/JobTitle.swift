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
    var isLicenseRequired = false
    
    override init() {
        /* For Default object of class */
    }
    
    //Used as a copy constructor
    init(jobTitle:JobTitle) {
        self.jobTitle = jobTitle.jobTitle
        self.jobId = jobTitle.jobId
        self.isLicenseRequired = jobTitle.isLicenseRequired

    }
    
    init(job:JSON) {
        self.jobTitle = job["jobtitle_name"].stringValue
        if job["jobtitle_name"].stringValue.isEmpty {
            self.jobTitle = job["jobtitleName"].stringValue
        }
        self.jobId = job["id"].intValue
        self.isLicenseRequired = job["isLicenseRequired"].boolValue
    }
}

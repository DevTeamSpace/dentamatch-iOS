//
//  JobTitle.swift
//  DentaMatch
//
//  Created by Rajan Maheshwari on 09/01/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import SwiftyJSON
import UIKit

class JobTitle: NSObject {
    var jobTitle = ""
    var jobId = 0
    var jobSelected = false
    var isLicenseRequired = false

    override init() {
        /* For Default object of class */
    }

    // Used as a copy constructor
    init(jobTitle: JobTitle) {
        self.jobTitle = jobTitle.jobTitle
        jobId = jobTitle.jobId
        isLicenseRequired = jobTitle.isLicenseRequired
    }

    init(job: JSON) {
        jobTitle = job["jobtitle_name"].stringValue
        if job["jobtitle_name"].stringValue.isEmpty {
            jobTitle = job["jobtitleName"].stringValue
        }
        jobId = job["id"].intValue
        isLicenseRequired = job["isLicenseRequired"].boolValue
    }
}

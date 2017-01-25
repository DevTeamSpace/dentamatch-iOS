//
//  JobDetails.swift
//  DentaMatch
//
//  Created by Shailesh Tyagi on 13/01/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit
import SwiftyJSON

class JobDetails: NSObject {
    
    var jobId = 0
    var jobTitle = ""
    var jobType = ""
    var jobDays = ""
    var docName = ""
    var isFavourite = ""
    var distance = ""
    var postTime = ""
    var latitude = ""
    var longitude = ""
    
    init(JobDetails:JSON) {
        
    }
}


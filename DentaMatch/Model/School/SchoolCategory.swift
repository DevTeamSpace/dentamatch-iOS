//
//  School.swift
//  DentaMatch
//
//  Created by Rajan Maheshwari on 16/01/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit
import SwiftyJSON

class SchoolCategory: NSObject {
    
    var schoolCategoryId = ""
    var schoolCategoryName = "schoolName"
    var isOpen = false
    var universities = [University]()
    
    override init() {
    
    }
    
    init(school:JSON,universities:[University]) {
        self.schoolCategoryId = school[Constants.ServerKey.schoolingId].stringValue
        self.schoolCategoryName = school[Constants.ServerKey.schoolName].stringValue
        self.universities = universities
    }
}

//Same as school category from server
class University {
    var universityName = ""
    var universityId = ""
    var yearOfGraduation = ""
    
    
    init(university:JSON) {
        self.universityName = university[Constants.ServerKey.schoolChildName].stringValue
        self.universityId = university[Constants.ServerKey.schoolingId].stringValue
        self.yearOfGraduation = university[Constants.ServerKey.yearOfGraduation].stringValue
    }
}

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
    
    //This may or may not come. Only comes if user has entered a school which is not present in the list
    var othersArray:[JSON]?
    
    override init() {
        //for empty object
    
    }
    
    init(school:JSON,universities:[University]) {
        self.schoolCategoryId = school[Constants.ServerKey.schoolingId].stringValue
        self.schoolCategoryName = school[Constants.ServerKey.schoolName].stringValue
        self.othersArray = school[Constants.ServerKey.other].array
        self.universities = universities
    }
}

//Same as school category from server
class University : NSObject {
    var universityName = ""
    var universityId = ""
    var isSelected = false
    var yearOfGraduation = ""
    
    init(university:JSON) {
        self.universityName = university[Constants.ServerKey.schoolChildName].stringValue
        self.universityId = university[Constants.ServerKey.schoolingChildId].stringValue
        self.yearOfGraduation = university[Constants.ServerKey.yearOfGraduation].stringValue
        self.isSelected = university[Constants.ServerKey.jobSeekerStatus].boolValue
    }
}

class SelectedSchool : NSObject {
    var schoolCategoryId = ""
    var schoolCategoryName = ""
    var universityId = ""
    var universityName = ""
    var isOther = false
    var otherSchooling = ""
    var yearOfGraduation = ""
    
    override init() {
        //for empty object
    }
    init(school:JSON) {
        self.schoolCategoryId = school[Constants.ServerKey.parentId].stringValue
        self.schoolCategoryName = school[Constants.ServerKey.schoolName].stringValue
        self.universityId = school[Constants.ServerKey.childId].stringValue
        self.universityName = school[Constants.ServerKey.schoolChildName].stringValue
        self.yearOfGraduation = school[Constants.ServerKey.yearOfGraduation].stringValue
        if !school[Constants.ServerKey.otherSchooling].stringValue.isEmpty {
            self.otherSchooling = school[Constants.ServerKey.otherSchooling].stringValue
            self.isOther = true
        }
    }
}

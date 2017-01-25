//
//  ExperienceModel.swift
//  DentaMatch
//
//  Created by Sanjay Kumar Yadav on 05/01/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit
import SwiftyJSON


class ExperienceModel: NSObject {

    var experienceID = 0
    var jobTitleID = 0
    var experienceInMonth = 0
    var jobTitle:String? = ""
    var yearOfExperience:String? = ""
    var officeName:String? = ""
    var officeAddress:String? = ""
    var cityName:String? = ""
    var isFirstExperience = true
    var isEditMode = false
    
    var references = [EmployeeReferenceModel]()
    
    init(empty:String) {
        //this for empty object
        
    }
    init(json:JSON) {
        super.init()
        self.experienceID = json[Constants.ServerKey.experienceId].intValue
        self.jobTitleID = json[Constants.ServerKey.jobTitleId].intValue
        self.jobTitle = json[Constants.ServerKey.jobtitleName].stringValue
        self.experienceInMonth = json[Constants.ServerKey.monthsOfExperience].intValue
        self.officeName = json[Constants.ServerKey.officeName].stringValue
        self.officeAddress = json[Constants.ServerKey.officeAddressExp].stringValue
        self.cityName = json[Constants.ServerKey.cityName].stringValue
        
        self.yearOfExperience = getyearExperience(totalMonths: experienceInMonth)

        let reference1Name = json[Constants.ServerKey.reference1Name].stringValue
        let reference1Mobile = json[Constants.ServerKey.reference1Mobile].stringValue
        let reference1Email = json[Constants.ServerKey.reference1Email].stringValue
        let reference2Name = json[Constants.ServerKey.reference2Name].stringValue
        let reference2Mobile = json[Constants.ServerKey.reference2Mobile].stringValue
        let reference2Email = json[Constants.ServerKey.reference2Email].stringValue
        if reference1Name.trim().characters.count > 0 || reference1Mobile.trim().characters.count > 0 || reference1Email.trim().characters.count > 0{
            let ref  = EmployeeReferenceModel(referenceName: reference1Name, mobileNumber: reference1Mobile, email: reference1Email)

            self.references.append(ref)
        }else
        {
            let ref  = EmployeeReferenceModel(empty: "")
            
            self.references.append(ref)

        }
        if reference2Name.trim().characters.count > 0 || reference2Mobile.trim().characters.count > 0 || reference2Email.trim().characters.count > 0{
            let ref1 = EmployeeReferenceModel(referenceName: reference2Name, mobileNumber: reference2Mobile, email: reference2Email)
            self.references.append(ref1)
        }
        
    }
    
    func getyearExperience(totalMonths:Int) -> String {
        let year  = totalMonths/12
        let month = totalMonths%12
        
        var text:String = ""
        
        if year <= 1 {
            if year != 0 {
                text.append("\(year) year")
            }
        }else{
            text.append("\(year) years")
        }
        
        if month <= 1 {
            if month != 0 {
                text.append(" \(month) month")
            }
        }else {
            text.append(" \(month) months")
        }

        return text
    }
}

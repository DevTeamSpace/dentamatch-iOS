//
//  ExperienceModel.swift
//  DentaMatch
//
//  Created by Sanjay Kumar Yadav on 05/01/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import SwiftyJSON
import UIKit

class ExperienceModel: NSObject {
    var experienceID = 0
    var jobTitleID = 0
    var experienceInMonth = 0
    var jobTitle: String? = ""
    var yearOfExperience: String? = ""
    var officeName: String? = ""
    var officeAddress: String? = ""
    var cityName: String? = ""
    var isFirstExperience = true
    var isEditMode = false

    var references = [EmployeeReferenceModel]()

    init(empty _: String) {
        //this for empty object
    }

    init(json: JSON) {
        super.init()
        experienceID = json[Constants.ServerKey.experienceId].intValue
        jobTitleID = json[Constants.ServerKey.jobTitleId].intValue
        jobTitle = json[Constants.ServerKey.jobtitleName].stringValue
        experienceInMonth = json[Constants.ServerKey.monthsOfExperience].intValue
        officeName = json[Constants.ServerKey.officeName].stringValue
        officeAddress = json[Constants.ServerKey.officeAddressExp].stringValue
        cityName = json[Constants.ServerKey.cityName].stringValue

        yearOfExperience = getyearExperience(totalMonths: experienceInMonth)

        let reference1Name = json[Constants.ServerKey.reference1Name].stringValue
        let reference1Mobile = json[Constants.ServerKey.reference1Mobile].stringValue
        let reference1Email = json[Constants.ServerKey.reference1Email].stringValue
        let reference2Name = json[Constants.ServerKey.reference2Name].stringValue
        let reference2Mobile = json[Constants.ServerKey.reference2Mobile].stringValue
        let reference2Email = json[Constants.ServerKey.reference2Email].stringValue
        if reference1Name.trim().count > 0 || reference1Mobile.trim().count > 0 || reference1Email.trim().count > 0 {
            let ref = EmployeeReferenceModel(referenceName: reference1Name, mobileNumber: reference1Mobile, email: reference1Email)

            references.append(ref)
        } else {
            let ref = EmployeeReferenceModel(empty: "")

            references.append(ref)
        }
        if reference2Name.trim().count > 0 || reference2Mobile.trim().count > 0 || reference2Email.trim().count > 0 {
            let ref1 = EmployeeReferenceModel(referenceName: reference2Name, mobileNumber: reference2Mobile, email: reference2Email)
            references.append(ref1)
        }
    }

    func getyearExperience(totalMonths: Int) -> String {
        let year = totalMonths / 12
        let month = totalMonths % 12

        var text: String = ""

        if year <= 1 {
            if year != 0 {
                text.append("\(year) year")
            }
        } else {
            text.append("\(year) years")
        }

        if month <= 1 {
            if month != 0 {
                text.append(" \(month) month")
            }
        } else {
            text.append(" \(month) months")
        }

        return text
    }
}

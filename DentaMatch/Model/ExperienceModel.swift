//
//  ExperienceModel.swift
//  DentaMatch
//
//  Created by Sanjay Kumar Yadav on 05/01/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

class ExperienceModel: NSObject {

    var jobTitle:String? = ""
    var yearOfExperience:String? = ""
    var officeName:String? = ""
    var officeAddress:String? = ""
    var cityName:String? = ""
    var isFirstExperience = true
    var isEditMode = false
    var references = [EmployeeReferenceModel]()

}

//
//  EmployeeReferenceModel.swift
//  DentaMatch
//
//  Created by Sanjay Kumar Yadav on 05/01/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

class EmployeeReferenceModel: NSObject {
    
    var referenceName:String? = ""
    var mobileNumber:String? = ""
    var email:String? = ""
    init(empty:String) {
        self.referenceName = ""
        self.mobileNumber = ""
        self.email = ""
    }
    init(referenceName:String?,mobileNumber:String?,email:String?) {
        self.referenceName = referenceName
        self.mobileNumber = mobileNumber
        self.email = email
    }
    
}



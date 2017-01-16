//
//  DMStudy+Services.swift
//  DentaMatch
//
//  Created by Rajan Maheshwari on 14/01/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import Foundation
import SwiftyJSON

extension DMStudyVC {
    
    func getSchoolListAPI() {
        self.showLoader()
        APIManager.apiGet(serviceName: Constants.API.getSchoolListAPI, parameters: [:]) { (response:JSON?, error:NSError?) in
            self.hideLoader()
            if error != nil {
                self.makeToast(toastString: (error?.localizedDescription)!)
                return
            }
            
            if response == nil {
                self.makeToast(toastString: Constants.AlertMessage.somethingWentWrong)
                return
            }
            print(response!)
            self.handleSchoolListAPIResponse(response: response)
        }
    }
    
    func handleSchoolListAPIResponse(response:JSON?) {
        if let response = response {
            if response[Constants.ServerKey.status].boolValue {
                let schoolCategoryList = response[Constants.ServerKey.result][Constants.ServerKey.list].arrayValue
                self.prepareSchoolCategoryListData(schoolCategoryList: schoolCategoryList)
                self.studyTableView.reloadData()
            } else {
                //handle fail case
            }
            self.makeToast(toastString: response[Constants.ServerKey.message].stringValue)

        }
    }
    
    func prepareSchoolCategoryListData(schoolCategoryList:[JSON]) {
        for schoolCategoryObj in schoolCategoryList {
            
            var universities = [University]()
            let universitiesArray = schoolCategoryObj[Constants.ServerKey.schoolCategory].arrayValue
            
            for universityObj in universitiesArray {
                let university = University(university: universityObj)
                universities.append(university)
            }
            
            let schoolCategory = SchoolCategory(school: schoolCategoryObj, universities: universities)
            schoolCategories.append(schoolCategory)
        }
        
    }
}

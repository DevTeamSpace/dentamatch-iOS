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
                self.makeToast(toastString: response[Constants.ServerKey.message].stringValue)
            } else {
                self.makeToast(toastString: response[Constants.ServerKey.message].stringValue)
            }
        }
    }
}

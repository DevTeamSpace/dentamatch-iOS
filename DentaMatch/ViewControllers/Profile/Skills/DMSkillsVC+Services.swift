//
//  DMSkills+Services.swift
//  DentaMatch
//
//  Created by Rajan Maheshwari on 12/01/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import Foundation
import SwiftyJSON

extension DMSkillsVC {
    
    func getSkillListAPI() {
        APIManager.apiGet(serviceName: Constants.API.getSkillList, parameters: [:]) { (response:JSON?, error:NSError?) in
            
            if error != nil {
                self.makeToast(toastString: (error?.localizedDescription)!)
                return
            }
            
            if response == nil {
                self.makeToast(toastString: Constants.AlertMessage.somethingWentWrong)
                return
            }
            print(response!)
            self.handleSkillListResponse(response: response)
        }
    }
    
    func handleSkillListResponse(response:JSON?) {
        if let response = response {
            if response[Constants.ServerKey.status].boolValue {
                
            } else {
                self.makeToast(toastString: response[Constants.ServerKey.message].stringValue)
            }
        }
    }
}

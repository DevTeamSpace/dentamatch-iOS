//
//  DMExecutiveSummaryVC+Services.swift
//  DentaMatch
//
//  Created by Rajan Maheshwari on 13/01/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import Foundation
import SwiftyJSON

extension DMExecutiveSummaryVC {

    func updateAboutMeAPI() {
        
        if self.aboutMe.isEmptyField {
            self.makeToast(toastString: "Please add introduction")
            return
        }
        self.showLoader()
        APIManager.apiPost(serviceName: Constants.API.saveAboutMe, parameters: [Constants.ServerKey.aboutMe:aboutMe]) { (response:JSON?, error:NSError?) in
            self.hideLoader()
            if error != nil {
                self.makeToast(toastString: (error?.localizedDescription)!)
                return
            }
            if response == nil {
                self.makeToast(toastString: Constants.AlertMessage.somethingWentWrong)
                return
            }
            self.handleAboutMeResponse(response: response)
        }
    }
    
    func handleAboutMeResponse(response:JSON?) {
        if let response = response {
            if response[Constants.ServerKey.status].boolValue {
                //sucess
            } else {
                //error
            }
            self.makeToast(toastString: response[Constants.ServerKey.message].stringValue)

        }
    }
}

//
//  DMChangePasswordVC+Services.swift
//  DentaMatch
//
//  Created by Sanjay Kumar Yadav on 21/01/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import Foundation
import SwiftyJSON
extension DMChangePasswordVC {
    func changePasswordAPI() {
        let dict = [Constants.ServerKey.oldPass: self.passwordArray[0], Constants.ServerKey.newPass: self.passwordArray[1], Constants.ServerKey.confirmPass: self.passwordArray[2]]
        showLoader()
        APIManager.apiPost(serviceName: Constants.API.changePassword, parameters: dict) { (response: JSON?, error: NSError?) in
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

    func handleAboutMeResponse(response: JSON?) {
        if let response = response {
            if response[Constants.ServerKey.status].boolValue {
                DispatchQueue.main.async {
                    self.gobackToSetting()
                }
            } else {
            }
            makeToast(toastString: response[Constants.ServerKey.message].stringValue)
        }
    }
}

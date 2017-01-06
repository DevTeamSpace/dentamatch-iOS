//
//  DMForgotPasswordVC+Services.swift
//  DentaMatch
//
//  Created by Rajan Maheshwari on 06/01/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import Foundation
import SwiftyJSON

extension DMForgotPasswordVC {
    
    func forgotPasswordAPI(params:[String:String]) {
        self.showLoader()
        APIManager.apiPut(serviceName: Constants.API.forgotPasswordAPI, parameters: params) { (response:JSON?, error:NSError?) in
            self.hideLoader()
            if error != nil {
                self.makeToast(toastString: (error?.localizedDescription)!)
                return
            }
            guard let _ = response else {
                self.makeToast(toastString: Constants.AlertMessages.somethingWentWrong)
                return
            }
            debugPrint(response!)
            if response![Constants.ServerKeys.status].boolValue {
                _ = self.navigationController?.popViewController(animated: true)
                self.makeToast(toastString: response![Constants.ServerKeys.message].stringValue)
            } else {
                self.makeToast(toastString: response![Constants.ServerKeys.message].stringValue)
            }
        }
    }
}

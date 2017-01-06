//
//  DMLoginVC+Services.swift
//  DentaMatch
//
//  Created by Rajan Maheshwari on 05/01/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import Foundation
import SwiftyJSON

extension DMLoginVC {
    
    func loginAPI(params:[String:String]) {
        print("Login Parameters\n\(params.description))")
        self.showLoader()
        APIManager.apiPost(serviceName: Constants.API.loginAPI, parameters: params) { (response:JSON?, error:NSError?) in
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
                self.openJobTitleSelection()
                self.makeToast(toastString: response![Constants.ServerKeys.message].stringValue)
            } else {
                self.makeToast(toastString: response![Constants.ServerKeys.message].stringValue)
            }

        }
    }
}

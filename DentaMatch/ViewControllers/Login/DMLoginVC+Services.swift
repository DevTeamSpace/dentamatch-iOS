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
        APIManager.apiPost(serviceName: Constants.API.login, parameters: params) { (response:JSON?, error:NSError?) in
            self.hideLoader()
            if error != nil {
                self.makeToast(toastString: (error?.localizedDescription)!)
                return
            }
            guard let _ = response else {
                self.makeToast(toastString: Constants.AlertMessage.somethingWentWrong)
                return
            }
            debugPrint(response!)
            self.handleLoginResponse(response: response)
        }
    }
    
    func handleLoginResponse(response:JSON?) {
        UserManager.shared().loginResponseHandler(response: response) { (success:Bool, message:String) in
            self.makeToast(toastString: response![Constants.ServerKey.message].stringValue)
            if success {
                self.openJobTitleSelection()
            }
        }
    }
}

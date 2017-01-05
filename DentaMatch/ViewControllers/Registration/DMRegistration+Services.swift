//
//  DMRegistration+Services.swift
//  DentaMatch
//
//  Created by Rajan Maheshwari on 04/01/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import Foundation
import SwiftyJSON

extension DMRegistrationVC {
    
    func registrationAPI(params:[String:String]) {
        debugPrint("Registration Parameters\n\(params.description))")
        self.showLoader()
        APIManager.apiPost(serviceName: Constants.API.registrationAPI, parameters: params) { (response:JSON?, error:NSError?) in
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
        }
    }
}

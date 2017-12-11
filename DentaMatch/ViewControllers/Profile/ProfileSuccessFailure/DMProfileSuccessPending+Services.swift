//
//  DMProfileSuccessPending+Services.swift
//  DentaMatch
//
//  Created by Rajan Maheshwari on 11/12/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import Foundation
import SwiftyJSON

extension DMProfileSuccessPending {
    
    func verifyEmail(completionHandler:@escaping (Bool, NSError?) -> ()) {
        self.showLoader()
        APIManager.apiGet(serviceName: Constants.API.emailVerify, parameters: nil) { (response:JSON?, error:NSError?) in
            self.hideLoader()
            if error != nil {
                self.makeToast(toastString: (error?.localizedDescription)!)
                return
            }
            if response == nil {
                self.makeToast(toastString: Constants.AlertMessage.somethingWentWrong)
                return
            }
            if response![Constants.ServerKey.status].boolValue {
                completionHandler(response![Constants.ServerKey.result]["isVerified"].boolValue, error)
            }
        }
    }
}

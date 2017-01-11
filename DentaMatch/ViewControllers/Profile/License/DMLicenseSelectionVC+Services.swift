//
//  DMLicenseSelectionVC+Services.swift
//  DentaMatch
//
//  Created by Sanjay Kumar Yadav on 11/01/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import Foundation
import SwiftyJSON
extension DMLicenseSelectionVC {
    
    func updateLicenseAndStateAPI(params:[String:String]) {
        print("LicenseNumberAndState Parameters\n\(params.description))")
        self.showLoader()
        APIManager.apiPost(serviceName: Constants.API.LicenseNumberAndState, parameters: params) { (response:JSON?, error:NSError?) in
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
            
            if response![Constants.ServerKey.status].boolValue {
                self.makeToast(toastString: response![Constants.ServerKey.message].stringValue)
                //do next
            } else {
                self.makeToast(toastString: response![Constants.ServerKey.message].stringValue)
            }
        }
    }
    
}

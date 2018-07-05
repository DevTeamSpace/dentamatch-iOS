//
//  DMSettingVC+Services.swift
//  DentaMatch
//
//  Created by Sanjay Kumar Yadav on 22/01/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import Foundation
import SwiftyJSON

extension DMSettingVC {
    func signOut(completionHandler: @escaping (Bool?, NSError?) -> Void) {
        let params = [String: AnyObject]()

        showLoader()
        APIManager.apiDelete(serviceName: Constants.API.signOut, parameters: params) { (response: JSON?, error: NSError?) in
            self.hideLoader()
            if error != nil {
                self.makeToast(toastString: (error?.localizedDescription)!)
                return
            }
            guard let _ = response else {
                self.makeToast(toastString: Constants.AlertMessage.somethingWentWrong)
                return
            }
            //            debugPrint(response!)

            if response![Constants.ServerKey.status].boolValue {
                self.makeToast(toastString: response![Constants.ServerKey.message].stringValue)
                completionHandler(true, error)
                // do next
            } else {
                self.makeToast(toastString: response![Constants.ServerKey.message].stringValue)
                completionHandler(false, error)
            }
        }
    }
}

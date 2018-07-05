//
//  DMEditLicenseVC+Services.swift
//  DentaMatch
//
//  Created by Rajan Maheshwari on 19/01/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import Foundation
import SwiftyJSON

extension DMEditLicenseVC {
    func updateLicenseDetailsAPI(params: [String: String]) {
        showLoader()
        APIManager.apiPut(serviceName: Constants.API.licenseNumberAndState, parameters: params) { (response: JSON?, error: NSError?) in
            self.hideLoader()
            if error != nil {
                self.makeToast(toastString: (error?.localizedDescription)!)
                return
            }
            guard let _ = response else {
                self.makeToast(toastString: Constants.AlertMessage.somethingWentWrong)
                return
            }
            // debugPrint(response!)
            self.handleUpdateLicenseResponse(response: response)
        }
    }

    func handleUpdateLicenseResponse(response: JSON?) {
        if let response = response {
            if response[Constants.ServerKey.status].boolValue {
                if license == nil { license = License() }
                license?.number = licenseNumberTextField.text!
                license?.state = stateTextField.text!
                NotificationCenter.default.post(name: .updateProfileScreen, object: nil, userInfo: ["license": license!])
                _ = navigationController?.popViewController(animated: true)
            }
            makeToast(toastString: response[Constants.ServerKey.message].stringValue)
        }
    }
}

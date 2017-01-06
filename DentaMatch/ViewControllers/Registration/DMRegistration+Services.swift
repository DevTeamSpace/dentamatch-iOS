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
        print("Registration Parameters\n\(params.description))")
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
            
            if response![Constants.ServerKeys.status].boolValue {
                self.clearData()
                self.makeToast(toastString: response![Constants.ServerKeys.message].stringValue)
                self.goToLogin()
            } else {
                self.makeToast(toastString: response![Constants.ServerKeys.message].stringValue)
            }
        }
    }
    
    func goToLogin() {
        if let viewControllers = kAppDelegate.window?.rootViewController?.childViewControllers {
            for viewController in viewControllers {
                if viewController is DMRegistrationContainer {
                    (viewController as! DMRegistrationContainer).goToLoginAfterRegistration()
                }
            }
        }
    }
    
    func clearData() {
        if let cell = self.registrationTableView.cellForRow(at: IndexPath(row: 0, section: 0)) as?
            RegistrationTableViewCell {
            cell.emailTextField.text = ""
            cell.nameTextField.text = ""
            cell.preferredLocationTextField.text = ""
            cell.newPasswordTextField.text = ""
            self.termsAndConditionsAccepted = false
            self.registrationTableView.reloadData()
        }
        registrationParams = [
            Constants.ServerKeys.deviceId:"",
            Constants.ServerKeys.deviceToken:"",
            Constants.ServerKeys.deviceType:"",
            Constants.ServerKeys.email:"",
            Constants.ServerKeys.firstName:"",
            Constants.ServerKeys.lastName:"",
            Constants.ServerKeys.password:"",
            Constants.ServerKeys.preferredLocation:"",
            Constants.ServerKeys.zipCode:"",
            Constants.ServerKeys.latitude:"",
            Constants.ServerKeys.longitude:""
        ]
    }
}

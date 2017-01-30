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
        APIManager.apiPost(serviceName: Constants.API.registration, parameters: params) { (response:JSON?, error:NSError?) in
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
                self.clearData()
                self.makeToast(toastString: response![Constants.ServerKey.message].stringValue)
                self.goToLogin()
            } else {
                self.makeToast(toastString: response![Constants.ServerKey.message].stringValue)
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
    
    //Clearing Data when registration is completed and user is navigated to login screen of same container.
    func clearData() {
        if let cell = self.registrationTableView.cellForRow(at: IndexPath(row: 0, section: 0)) as?
            RegistrationTableViewCell {
            cell.emailTextField.text = ""
            cell.firstNameTextField.text = ""
            cell.lastNameTextField.text = ""
            cell.preferredLocationTextField.text = ""
            cell.newPasswordTextField.text = ""
            self.termsAndConditionsAccepted = false
            self.registrationTableView.reloadData()
        }
        registrationParams = [
            Constants.ServerKey.deviceId:"",
            Constants.ServerKey.deviceToken:"",
            Constants.ServerKey.deviceType:"",
            Constants.ServerKey.email:"",
            Constants.ServerKey.firstName:"",
            Constants.ServerKey.lastName:"",
            Constants.ServerKey.password:"",
            Constants.ServerKey.preferredLocation:"",
            Constants.ServerKey.zipCode:"",
            Constants.ServerKey.latitude:"",
            Constants.ServerKey.longitude:""
        ]
    }
}

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
    func registrationAPI(params: [String: String]) {
        LogManager.logDebug("Registration Parameters: \n\(params.description)")
        showLoader()
        APIManager.apiPost(serviceName: Constants.API.registration, parameters: params) { (response: JSON?, error: NSError?) in
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
            if response![Constants.ServerKey.status].boolValue {
                MixpanelOperations.trackMixpanelEventWithProperties(eventName: "SignUp", dict: params)
                self.clearData()
                self.handleUserResponse(response: response)
                self.alertMessage(title: "Success", message: response![Constants.ServerKey.message].stringValue, buttonText: "Ok", completionHandler: {
                    self.openJobTitleSelection()
                })
            } else {
                self.makeToast(toastString: response![Constants.ServerKey.message].stringValue)
            }
        }
    }

    func handleUserResponse(response: JSON?) {
        UserManager.shared().loginResponseHandler(response: response) { (success: Bool, _: String) in
            if success {
                MixpanelOperations.manageMixpanelUserIdentity()
                MixpanelOperations.registerMixpanelUser()
                MixpanelOperations.trackMixpanelEvent(eventName: "Login")
                // debugPrint("Login Success......")
                // debugPrint("Socket Operation done......")
            }
        }
    }

    func openJobTitleSelection() {
        let jobTitleSectionVC = UIStoryboard.profileStoryBoard().instantiateViewController(withIdentifier: Constants.StoryBoard.Identifer.profileNav)
        UIView.transition(with: view.window!, duration: 0.5, options: .transitionFlipFromRight, animations: {
            kAppDelegate?.window?.rootViewController = jobTitleSectionVC
            SocketManager.sharedInstance.establishConnection()
        }) { (_: Bool) in
        }
    }

    func getPreferredLocations(shouldShowKeyboard: Bool = false) {
        view.endEditing(true)
        if shouldShowKeyboard { showLoader() }
        APIManager.apiGet(serviceName: Constants.API.getPreferredJobLocations, parameters: nil) { (response: JSON?, error: NSError?) in
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
            if response![Constants.ServerKey.status].boolValue {
                let preferredJobLocationArray = response!["result"]["preferredJobLocations"].arrayValue

                for location in preferredJobLocationArray {
                    self.preferredLocations.append(PreferredLocation(preferredLocation: location))
                }
                self.preferredLocationPickerView.setup(preferredLocations: self.preferredLocations)
                self.preferredLocationPickerView.pickerView.reloadAllComponents()
                self.preferredLocationPickerView.backgroundColor = UIColor.white
                if shouldShowKeyboard {
                    if let cell = self.registrationTableView.cellForRow(at: IndexPath(row: 0, section: 0)) as?
                        RegistrationTableViewCell {
                        cell.preferredLocationTextField.becomeFirstResponder()
                    }
                }
            } else {
                self.makeToast(toastString: response![Constants.ServerKey.message].stringValue)
            }
        }
    }

    func goToLogin() {
        if let viewControllers = kAppDelegate?.window?.rootViewController?.children {
            for viewController in viewControllers {
                if viewController is DMRegistrationContainer {
                    (viewController as? DMRegistrationContainer)?.goToLoginAfterRegistration()
                }
            }
        }
    }

    // Clearing Data when registration is completed and user is navigated to login screen of same container.
    func clearData() {
        if let cell = self.registrationTableView.cellForRow(at: IndexPath(row: 0, section: 0)) as?
            RegistrationTableViewCell {
            cell.emailTextField.text = ""
            cell.firstNameTextField.text = ""
            cell.lastNameTextField.text = ""
            cell.preferredLocationTextField.text = ""
            cell.newPasswordTextField.text = ""
            termsAndConditionsAccepted = false
            registrationTableView.reloadData()
        }
        registrationParams = [
            Constants.ServerKey.deviceId: "",
            Constants.ServerKey.deviceToken: "",
            Constants.ServerKey.deviceType: "",
            Constants.ServerKey.email: "",
            Constants.ServerKey.firstName: "",
            Constants.ServerKey.lastName: "",
            Constants.ServerKey.password: "",
            Constants.ServerKey.preferredLocation: "",
            Constants.ServerKey.zipCode: "",
            Constants.ServerKey.latitude: "",
            Constants.ServerKey.longitude: "",
        ]
    }
}

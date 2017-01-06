//
//  DMRegistrationVC.swift
//  DentaMatch
//
//  Created by Rajan Maheshwari on 25/10/16.
//  Copyright © 2016 Appster. All rights reserved.
//

import UIKit
import CoreLocation

class DMRegistrationVC: DMBaseVC {

    @IBOutlet weak var registrationTableView: UITableView!
    var coordinateSelected:CLLocationCoordinate2D?
    var termsAndConditionsAccepted = false
    var registrationParams = [
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
    
    //MARK:- View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.registrationTableView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    //MARK:- Keyboard Show Hide Observers
    func keyboardWillShow(note: NSNotification) {
        if let keyboardSize = (note.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            registrationTableView.contentInset =  UIEdgeInsetsMake(0, 0, keyboardSize.height+1, 0)
        }
    }
    
    func keyboardWillHide(note: NSNotification) {
        registrationTableView.contentInset =  UIEdgeInsetsMake(0, 0, 0, 0)
    }
    
    //MARK:- Private Methods
    func setup() {
        self.registrationTableView.register(UINib(nibName: "RegistrationTableViewCell", bundle: nil), forCellReuseIdentifier: "RegistrationTableViewCell")
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.registrationTableView.addGestureRecognizer(tap)
    }
    
    func validateFields() -> Bool{
        if !registrationParams[Constants.ServerKeys.firstName]!.isEmpty {
            if registrationParams[Constants.ServerKeys.email]!.isValidEmail {
                if registrationParams[Constants.ServerKeys.password]!.characters.count >= Constants.Limits.passwordLimit {
                    if coordinateSelected != nil {
                        if self.termsAndConditionsAccepted {
                            return true
                        } else {
                            self.makeToast(toastString: "Please accept terms and conditions")
                            return false
                        }
                    } else {
                        self.makeToast(toastString: "Preferred Location error")
                        return false
                    }
                } else {
                    self.makeToast(toastString: "Password limit error")
                    return false
                }
            } else {
                self.makeToast(toastString: Constants.AlertMessages.invalidEmail)
                return false
            }
        } else {
            self.makeToast(toastString: "Name empty error")
            return false
        }
    }
    
    func openTermsAndConditions(isPrivacyPolicy:Bool) {
        let termsVC = UIStoryboard.registrationStoryBoard().instantiateViewController(type: DMTermsAndConditionsVC.self)!
        termsVC.isPrivacyPolicy = isPrivacyPolicy
        self.navigationController?.pushViewController(termsVC, animated: true)
    }
    
    func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    //MARK:- IBActions
    func registerButtonPressed(sender:UIButton) {
        dismissKeyboard()
        registrationParams[Constants.ServerKeys.deviceId] = "test"
        registrationParams[Constants.ServerKeys.deviceType] = "iOS"
        registrationParams[Constants.ServerKeys.deviceToken] = UserDefaultsManager.sharedInstance.deviceToken
        if validateFields() {
            self.registrationAPI(params:self.registrationParams)
        }
    }
    
    func acceptTermsButtonPressed(sender:UIButton) {
        self.termsAndConditionsAccepted = self.termsAndConditionsAccepted ? false:true
        self.registrationTableView.reloadData()
    }
    
}

//MARK:- Extensions
extension DMRegistrationVC:UITextViewDelegate {
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange) -> Bool {
        if URL.absoluteString == "openTermsAndConditions" {
            self.openTermsAndConditions(isPrivacyPolicy: false)
        } else if URL.absoluteString == "openPrivacyPolicy" {
            self.openTermsAndConditions(isPrivacyPolicy: true)
        }
        return false
    }
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        if !NSEqualRanges(textView.selectedRange, NSRange(location: 0, length: 0)) {
            textView.selectedRange = NSRange(location: 0, length: 0)
        }
    }
}

//MARK:- LocationAddress Delegate
extension DMRegistrationVC:LocationAddressDelegate {
    func locationAddress(location: Location) {
        coordinateSelected = location.coordinateSelected
        if let address = location.address {
            if let cell = self.registrationTableView.cellForRow(at: IndexPath(row: 0, section: 0)) as?
                RegistrationTableViewCell {
                cell.preferredLocationTextField.text = address
                
                registrationParams[Constants.ServerKeys.zipCode] = location.postalCode
                registrationParams[Constants.ServerKeys.preferredLocation] = address
                registrationParams[Constants.ServerKeys.latitude] = "\((coordinateSelected?.latitude)!)"
                registrationParams[Constants.ServerKeys.longitude] = "\((coordinateSelected?.longitude)!)"
            }
            debugPrint(address)
        } else {
            debugPrint("Address is empty")
        }
    }
}

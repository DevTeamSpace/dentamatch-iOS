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
        Constants.ServerKey.deviceId:"",
        Constants.ServerKey.deviceToken:"",
        Constants.ServerKey.deviceType:"",
        Constants.ServerKey.email:"",
        Constants.ServerKey.firstName:"",
        Constants.ServerKey.lastName:"",
        Constants.ServerKey.password:"",
        Constants.ServerKey.preferredLocation:"",
        Constants.ServerKey.zipCode:"",
        Constants.JobDetailKey.city:"",
        Constants.JobDetailKey.state:"",
        Constants.JobDetailKey.country:"",

        Constants.ServerKey.latitude:"",
        Constants.ServerKey.longitude:""
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
    @objc func keyboardWillShow(note: NSNotification) {
        if let keyboardSize = (note.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            registrationTableView.contentInset =  UIEdgeInsetsMake(0, 0, keyboardSize.height+1, 0)
        }
    }
    
    @objc func keyboardWillHide(note: NSNotification) {
        registrationTableView.contentInset =  UIEdgeInsetsMake(0, 0, 0, 0)
    }
    
    //MARK:- Private Methods
    func setup() {
        UserDefaultsManager.sharedInstance.isOnBoardingDone = true
        self.registrationTableView.register(UINib(nibName: "RegistrationTableViewCell", bundle: nil), forCellReuseIdentifier: "RegistrationTableViewCell")
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.registrationTableView.addGestureRecognizer(tap)
    }
    
    func validateFields() -> Bool{
        if registrationParams[Constants.ServerKey.firstName]!.isEmpty {
            self.makeToast(toastString: Constants.AlertMessage.emptyFirstName)
            return false
        }
        
        if registrationParams[Constants.ServerKey.lastName]!.isEmpty {
            self.makeToast(toastString: Constants.AlertMessage.emptyLastName)
            return false
        }
        
        if !registrationParams[Constants.ServerKey.email]!.isValidEmail {
            self.makeToast(toastString: Constants.AlertMessage.invalidEmail)
            return false
        }
        if registrationParams[Constants.ServerKey.password]!.characters.count < Constants.Limit.passwordLimit {
            if registrationParams[Constants.ServerKey.password]!.characters.count == 0 {
                self.makeToast(toastString: Constants.AlertMessage.emptyPassword)
            } else {
                self.makeToast(toastString: Constants.AlertMessage.passwordRange)
            }
            return false
        }
        if coordinateSelected == nil {
            self.makeToast(toastString: Constants.AlertMessage.emptyPreferredJobLocation)
            return false
        }
        
        if registrationParams[Constants.ServerKey.zipCode]!.isEmpty {
            self.makeToast(toastString: Constants.AlertMessage.emptyPinCode)
            return false
        }
        
        if !self.termsAndConditionsAccepted {
            self.makeToast(toastString: Constants.AlertMessage.termsAndConditions)
            return false
        }
        
        
        return true
    }
    
    func openTermsAndConditions(isPrivacyPolicy:Bool) {
        self.view.endEditing(true)
        let termsVC = UIStoryboard.registrationStoryBoard().instantiateViewController(type: DMTermsAndConditionsVC.self)!
        termsVC.isPrivacyPolicy = isPrivacyPolicy
        self.navigationController?.pushViewController(termsVC, animated: true)
    }
    
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    //MARK:- IBActions
    
    @IBAction func registerButtonPressed(_ sender: Any) {
        dismissKeyboard()
        registrationParams[Constants.ServerKey.deviceId] = Utilities.deviceId()
        registrationParams[Constants.ServerKey.deviceType] = "iOS"
        registrationParams[Constants.ServerKey.deviceToken] = UserDefaultsManager.sharedInstance.deviceToken
        if validateFields() {
            self.registrationAPI(params:self.registrationParams)
        }
    }

    @objc func acceptTermsButtonPressed(sender:UIButton) {
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
                
                registrationParams[Constants.ServerKey.zipCode] = location.postalCode
                registrationParams[Constants.JobDetailKey.state] = location.state
                registrationParams[Constants.JobDetailKey.country] = location.country
                registrationParams[Constants.JobDetailKey.city] = location.city

                registrationParams[Constants.ServerKey.preferredLocation] = address
                if let _ = coordinateSelected {
                    registrationParams[Constants.ServerKey.latitude] = "\((coordinateSelected?.latitude)!)"
                    registrationParams[Constants.ServerKey.longitude] = "\((coordinateSelected?.longitude)!)"
                }
               
            }
            debugPrint(address)
        } else {
            debugPrint("Address is empty")
        }
    }
}

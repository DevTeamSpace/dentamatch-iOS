//
//  DMRegistrationVC+TextViewExtension.swift
//  DentaMatch
//
//  Created by Rajan Maheshwari on 05/01/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import Foundation

extension DMRegistrationVC:UITextFieldDelegate {
    
    //MARK:- TextField Delegates
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        switch textField.tag {
        case 1:
            if let cell = self.registrationTableView.cellForRow(at: IndexPath(row: 0, section: 0)) as?
                RegistrationTableViewCell {
                cell.emailTextField.becomeFirstResponder()
            }
        case 2:
            if let cell = self.registrationTableView.cellForRow(at: IndexPath(row: 0, section: 0)) as?
                RegistrationTableViewCell {
                cell.newPasswordTextField.becomeFirstResponder()
            }
        case 3:
            textField.resignFirstResponder()
        default:
            break
        }
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if let cell = self.registrationTableView.cellForRow(at: IndexPath(row: 0, section: 0)) as?
            RegistrationTableViewCell {
            if textField == cell.preferredLocationTextField {
                let mapVC = UIStoryboard.registrationStoryBoard().instantiateViewController(type: DMRegisterMapsVC.self)!
                mapVC.delegate = self
                self.navigationController?.pushViewController(mapVC, animated: true)
                self.view.endEditing(true)
                return false
            }
        }
        if let textField = textField as? AnimatedLeftViewPHTextField {
            textField.layer.borderColor = kTextFieldColorSelected.cgColor
            textField.leftViewLabel?.textColor = kTextFieldColorSelected
        }
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if let textField = textField as? AnimatedLeftViewPHTextField {
            textField.layer.borderColor = kTextFieldBorderColor.cgColor
            textField.leftViewLabel?.textColor = kTextFieldLeftViewModeColor
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField.tag {
        case 1:
            //FirstName
            registrationParams[Constants.ServerKeys.firstName] = textField.text!
            registrationParams[Constants.ServerKeys.lastName] = textField.text!
        case 2:
            registrationParams[Constants.ServerKeys.email] = textField.text!
        case 3:
            registrationParams[Constants.ServerKeys.password] = textField.text!
        default:
            break
        }
    }
}

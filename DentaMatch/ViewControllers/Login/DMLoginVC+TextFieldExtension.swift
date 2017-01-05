//
//  DMLoginVC+TextFieldExtension.swift
//  DentaMatch
//
//  Created by Rajan Maheshwari on 05/01/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import Foundation

extension DMLoginVC:UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.tag == 1 {
            //Email TextField
            if let cell = self.loginTableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? LoginTableViewCell {
                cell.passwordTextField.becomeFirstResponder()
            }
        } else {
            //Password TextField
            textField.resignFirstResponder()
        }
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
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
        if textField.tag == 1 {
            loginParams[Constants.ServerKeys.email] = textField.text!
        } else {
            loginParams[Constants.ServerKeys.password] = textField.text!
        }
    }
}

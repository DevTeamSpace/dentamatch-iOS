//
//  DMLoginVC+TextFieldExtension.swift
//  DentaMatch
//
//  Created by Rajan Maheshwari on 05/01/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import Foundation

extension DMLoginVC: UITextFieldDelegate {

    // MARK: - TextField Delegates

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.tag == 1 {
            // Email TextField
            if let cell = self.loginTableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? LoginTableViewCell {
                cell.passwordTextField.becomeFirstResponder()
            }
        } else {
            // Password TextField
            textField.resignFirstResponder()
        }
        return true
    }

    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if let textField = textField as? AnimatedLeftViewPHTextField {
            textField.layer.borderColor = Constants.Color.textFieldColorSelected.cgColor
            textField.leftViewLabel?.textColor = Constants.Color.textFieldColorSelected
        }
        return true
    }

    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if let textField = textField as? AnimatedLeftViewPHTextField {
            textField.text = textField.text!.trim()
            textField.layer.borderColor = Constants.Color.textFieldBorderColor.cgColor
            textField.leftViewLabel?.textColor = Constants.Color.textFieldLeftViewModeColor
        }
        return true
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.tag == 1 {
            loginParams[Constants.ServerKey.email] = textField.text!
        } else {
            loginParams[Constants.ServerKey.password] = textField.text!
        }
    }
}

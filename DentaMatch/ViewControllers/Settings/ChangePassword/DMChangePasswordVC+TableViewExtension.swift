//
//  DMChangePasswordVC+TableViewExtension.swift
//  DentaMatch
//
//  Created by Sanjay Kumar Yadav on 21/01/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import Foundation

extension DMChangePasswordVC:UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChangePasswordTableCell") as! ChangePasswordTableCell
        cell.selectionStyle = .none
        cell.passwordTextField.delegate = self
        cell.passwordTextField.tag = indexPath.row
        cell.passwordTextField.text = passwordArray[indexPath.row]
        switch indexPath.row {
        case 0:
            cell.passwordTextField.placeholder = "Old Password"
        case 1:
            cell.passwordTextField.placeholder = "New Password"
        case 2:
            cell.passwordTextField.placeholder = "Confirm Password"
            
        default: break
            
        }
        return cell
    }
    
}

extension DMChangePasswordVC : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
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
        textField.resignFirstResponder()
        if let textField = textField as? AnimatedLeftViewPHTextField {
            textField.text = textField.text!.trim()
            textField.layer.borderColor = Constants.Color.textFieldBorderColor.cgColor
            textField.leftViewLabel?.textColor = Constants.Color.textFieldLeftViewModeColor
        }
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        passwordArray[textField.tag] = textField.text!
        
    }
    
}

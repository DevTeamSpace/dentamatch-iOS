//
//  DMJobTitleSelectionVC+TextFieldExtension.swift
//  DentaMatch
//
//  Created by Rajan Maheshwari on 06/11/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import Foundation

extension DMJobTitleSelectionVC : UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if let textField = textField as? AnimatedPHTextField {
            textField.layer.borderColor = Constants.Color.textFieldColorSelected.cgColor
        }
        return true
        
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if let textField = textField as? AnimatedPHTextField {
            textField.layer.borderColor = Constants.Color.textFieldBorderColor.cgColor
        }
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard string.count > 0 else {
            return true
        }
        
        if textField.tag == 2 {
            //For License
            let characterset = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLKMNOPQRSTUVWXYZ0123456789-")
            if string == "-" && textField.text?.count == 0 {
//                self.dismissKeyboard()
                self.makeToast(toastString: Constants.AlertMessage.lienseNoStartError)
                return false
                
            }
            if string.rangeOfCharacter(from: characterset.inverted) != nil {
                debugPrint("string contains special characters")
                return false
                
            }
            if (textField.text?.count)! >= Constants.Limit.licenseNumber {                return false
                
            }
            
        }else if textField.tag == 3 {
            //State check
            let characterset = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLKMNOPQRSTUVWXYZ- ")
            if string == "-" && textField.text?.count == 0 {
                //self.dismissKeyboard()
                self.makeToast(toastString: Constants.AlertMessage.stateStartError)
                return false
                
            }
            if string.rangeOfCharacter(from: characterset.inverted) != nil {
                debugPrint("string contains special characters")
                return false
                
            }
            if (textField.text?.count)! >= Constants.Limit.commonMaxLimit {                return false
                
            }
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.text = textField.text?.trim()
        if textField.tag == 2 {
            licenseNumber = textField.text!
        }else if textField.tag == 3 {
            state = textField.text!
        }
        self.changeUIOFCreateProfileButton(self.isCreateProfileButtonEnable())
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}

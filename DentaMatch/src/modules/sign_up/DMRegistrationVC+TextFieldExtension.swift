import Foundation

extension DMRegistrationVC: UITextFieldDelegate {
    enum TextField: Int {
        case firstName = 1
        case lastName
        case email
        case password
        case preferredLocation
    }

    // MARK: - TextField Delegates

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let fieldSelected = TextField(rawValue: textField.tag)!

        switch fieldSelected {
        case .firstName:
            if let cell = self.registrationTableView.cellForRow(at: IndexPath(row: 0, section: 0)) as?
                RegistrationTableViewCell {
                cell.lastNameTextField.becomeFirstResponder()
            }

        case .lastName:
            if let cell = self.registrationTableView.cellForRow(at: IndexPath(row: 0, section: 0)) as?
                RegistrationTableViewCell {
                cell.emailTextField.becomeFirstResponder()
            }

        case .email:
            if let cell = self.registrationTableView.cellForRow(at: IndexPath(row: 0, section: 0)) as?
                RegistrationTableViewCell {
                cell.newPasswordTextField.becomeFirstResponder()
            }
        case .password:
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
                cell.preferredLocationTextField.inputView = viewOutput?.preferredLocations.count == 0 ? nil : preferredLocationPickerView
            }
        }
        
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
        let fieldSelected = TextField(rawValue: textField.tag)!

        switch fieldSelected {
        case .firstName:
            registrationParams[Constants.ServerKey.firstName] = textField.text!
        case .lastName:
            registrationParams[Constants.ServerKey.lastName] = textField.text!
        case .email:
            registrationParams[Constants.ServerKey.email] = textField.text!
        case .password:
            registrationParams[Constants.ServerKey.password] = textField.text!
        default:
            break
        }
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn _: NSRange, replacementString string: String) -> Bool {
        let fieldSelected = TextField(rawValue: textField.tag)!

        guard string.count > 0 else {
            return true
        }
        let characterset = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLKMNOPQRSTUVWXYZ")

        switch fieldSelected {
        case .firstName:
            if string.rangeOfCharacter(from: characterset.inverted) != nil {
                // debugPrint("string contains special characters")
                return false
            }
            if textField.text!.count >= Constants.Limit.commonMaxLimit {
                return false
            }

        case .lastName:
            if string.rangeOfCharacter(from: characterset.inverted) != nil {
                // debugPrint("string contains special characters")
                return false
            }
            if textField.text!.count >= Constants.Limit.commonMaxLimit {
                return false
            }

        case .password:
            if textField.text!.count >= Constants.Limit.maxPasswordLimit {
                return false
            }
        default:
            return true
        }
        return true
    }
}

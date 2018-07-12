//
//  DMEditLicenseVC.swift
//  DentaMatch
//
//  Created by Rajan Maheshwari on 19/01/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

class DMEditLicenseVC: DMBaseVC {
    @IBOutlet var stateTextField: AnimatedPHTextField!
    @IBOutlet var licenseNumberTextField: AnimatedPHTextField!

    var isEditMode = false
    var license: License?
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        licenseNumberTextField.text = license?.number
        stateTextField.text = license?.state
    }

    func setup() {
        title = "EDIT PROFILE"
        stateTextField.autocapitalizationType = .words
        changeNavBarAppearanceForDefault()
        navigationItem.leftBarButtonItem = backBarButton()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }

    override func touchesBegan(_: Set<UITouch>, with _: UIEvent?) {
        view.endEditing(true)
    }

    func validateFields() -> Bool {
        licenseNumberTextField.text = licenseNumberTextField.text?.trim()
        stateTextField.text = stateTextField.text?.trim()

        if (licenseNumberTextField.text?.isEmptyField)! {
            makeToast(toastString: Constants.AlertMessage.emptyLicenseNumber)
            return false
        } else {
            let newChar = licenseNumberTextField.text?.first
            if newChar == "-" {
                makeToast(toastString: Constants.AlertMessage.lienseNoStartError)
                return false
            }
        }

        if (stateTextField.text?.isEmptyField)! {
            makeToast(toastString: Constants.AlertMessage.emptyState)
            return false
        } else {
            let newChar = stateTextField.text?.first
            if newChar == "-" {
                makeToast(toastString: Constants.AlertMessage.stateStartError)
                return false
            }
        }
        return true
    }

    @IBAction func saveButtonPressed(_: Any) {
        view.endEditing(true)
        if validateFields() {
            let params = [
                "license": licenseNumberTextField.text!,
                "state": stateTextField.text!,
                "jobTitleId": "",
            ]
            updateLicenseDetailsAPI(params: params)
        }
    }
}

extension DMEditLicenseVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.tag == 0 {
            stateTextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return true
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn _: NSRange, replacementString string: String) -> Bool {
        guard string.count > 0 else {
            return true
        }

        if textField.tag == 0 {
            let characterset = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLKMNOPQRSTUVWXYZ0123456789-")
            if string == "-" && textField.text?.count == 0 {
                view.endEditing(true)
                makeToast(toastString: Constants.AlertMessage.lienseNoStartError)
                return false
            }
            if string.rangeOfCharacter(from: characterset.inverted) != nil {
                // debugPrint("string contains special characters")
                return false
            }

            if (textField.text?.count)! >= Constants.Limit.licenseNumber {
                return false
            }

        } else {
            let characterset = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLKMNOPQRSTUVWXYZ- ")
            if string == "-" && textField.text?.count == 0 {
                view.endEditing(true)
                makeToast(toastString: Constants.AlertMessage.stateStartError)
                return false
            }
            if string.rangeOfCharacter(from: characterset.inverted) != nil {
                // debugPrint("string contains special characters")
                return false
            }

            if (textField.text?.count)! >= Constants.Limit.commonMaxLimit {
                return false
            }
        }
        return true
    }

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

    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.text = textField.text?.trim()
    }
}

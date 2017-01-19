//
//  DMEditLicenseVC.swift
//  DentaMatch
//
//  Created by Rajan Maheshwari on 19/01/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

class DMEditLicenseVC: DMBaseVC {
    
    enum TextFieldOptions:Int {
        case licenseNumber = 1
        case state
    }
    
    @IBOutlet weak var stateTextField: AnimatedPHTextField!
    @IBOutlet weak var licenseNumberTextField: AnimatedPHTextField!
    
    var license:License?
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        licenseNumberTextField.text = license?.number
        stateTextField.text = license?.state
    }
    
    func setup() {
        self.changeNavBarAppearanceForDefault()
        self.navigationItem.leftBarButtonItem = self.backBarButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func validateFields() -> Bool {
        licenseNumberTextField.text = licenseNumberTextField.text?.trim()
        stateTextField.text = stateTextField.text?.trim()
        if (licenseNumberTextField.text?.isEmpty)! {
            self.makeToast(toastString: Constants.AlertMessage.emptyLicenseNumber)
            return false
        }
        
        if (stateTextField.text?.isEmpty)! {
            self.makeToast(toastString: Constants.AlertMessage.emptyState)
            return false
        }
        return true
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func saveButtonPressed(_ sender: Any) {
        if validateFields() {
            let params = [
                "license":licenseNumberTextField.text!,
                "state":stateTextField.text!
            ]
            self.updateLicenseDetailsAPI(params: params)
        }
    }
}

extension DMEditLicenseVC : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let textFieldOptions = TextFieldOptions(rawValue: textField.tag)!

        guard string.characters.count > 0 else {
            return true
        }
        
        switch textFieldOptions {
        case .licenseNumber:
            let characterset = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLKMNOPQRSTUVWXYZ0123456789-")
            if string == "-" && textField.text?.characters.count == 0 {
                self.view.endEditing(true)
                self.makeToast(toastString: "License No can't start with hyphen (-)")
                return false
            }
            if string.rangeOfCharacter(from: characterset.inverted) != nil {
                print("string contains special characters")
                return false
            }
            
            if (textField.text?.characters.count)! >= Constants.Limit.licenseNumber {
                return false
            }
        case .state:
            if (textField.text?.characters.count)! >= Constants.Limit.commonMaxLimit {
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
        let textFieldOptions = TextFieldOptions(rawValue: textField.tag)!
        textField.text = textField.text?.trim()
        switch textFieldOptions {
        case .licenseNumber:
            if textField.text?.characters.last == "-" {
                print("Ending with hyphen")
            }
        case .state:
            break
        }
    }
}

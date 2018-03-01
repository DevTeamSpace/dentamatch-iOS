//
//  DMForgotPasswordVC.swift
//  DentaMatch
//
//  Created by Rajan Maheshwari on 12/12/16.
//  Copyright © 2016 Appster. All rights reserved.
//

import UIKit

class DMForgotPasswordVC: DMBaseVC {

    @IBOutlet weak var emailTextField: AnimatedLeftViewPHTextField!
    
    var forgotPasswordParams = [
        Constants.ServerKey.email:""
    ]
    //MARK:- View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
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
    
    //MARK:- Private Methods
    func setup() {
        emailTextField.leftViewLabel?.text = "f"
        self.title = Constants.ScreenTitleNames.forgotPassword
        self.navigationItem.leftBarButtonItem = self.backBarButton()
    }
    
    //MARK:- IBActions
    @IBAction func sendButtonPressed(_ sender: Any) {
        self.view.endEditing(true)
        
        if let emailtext = emailTextField.text, emailtext.isEmpty {
            self.makeToast(toastString: Constants.AlertMessage.emptyEmail)
            return
        }
        if emailTextField.text!.isValidEmail {
            forgotPasswordParams[Constants.ServerKey.email] = self.emailTextField.text!
            self.forgotPasswordAPI(params: forgotPasswordParams)
        } else {
            self.makeToast(toastString: Constants.AlertMessage.invalidEmail)
        }
    }
}

extension DMForgotPasswordVC: UITextFieldDelegate {
    
    //MARK:- TextField Delegates
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if let textField = textField as? AnimatedLeftViewPHTextField {
            textField.layer.borderColor = Constants.Color.textFieldColorSelected.cgColor
            textField.leftViewLabel?.textColor = Constants.Color.textFieldColorSelected
        }
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if let textField = textField as? AnimatedLeftViewPHTextField {
            textField.layer.borderColor = Constants.Color.textFieldBorderColor.cgColor
            textField.leftViewLabel?.textColor = Constants.Color.textFieldLeftViewModeColor
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

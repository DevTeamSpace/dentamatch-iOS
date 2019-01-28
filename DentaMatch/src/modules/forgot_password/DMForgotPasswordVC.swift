//
//  DMForgotPasswordVC.swift
//  DentaMatch
//
//  Created by Rajan Maheshwari on 12/12/16.
//  Copyright © 2016 Appster. All rights reserved.
//

import UIKit

class DMForgotPasswordVC: DMBaseVC {
    @IBOutlet var emailTextField: AnimatedLeftViewPHTextField!

    var forgotPasswordParams = [
        Constants.ServerKey.email: "",
    ]
    
    weak var moduleOutput: DMForgotPasswordModuleOutput?

    // MARK: - View LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
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

    // MARK: - Private Methods

    func setup() {
        emailTextField.leftViewLabel?.text = "f"
        title = Constants.ScreenTitleNames.forgotPassword
        navigationItem.leftBarButtonItem = backBarButton()
    }

    // MARK: - IBActions

    @IBAction func sendButtonPressed(_: Any) {
        view.endEditing(true)

        if let emailtext = emailTextField.text, emailtext.isEmpty {
            makeToast(toastString: Constants.AlertMessage.emptyEmail)
            return
        }
        if emailTextField.text!.isValidEmail {
            forgotPasswordParams[Constants.ServerKey.email] = emailTextField.text!
            forgotPasswordAPI(params: forgotPasswordParams)
        } else {
            makeToast(toastString: Constants.AlertMessage.invalidEmail)
        }
    }
}

extension DMForgotPasswordVC: UITextFieldDelegate {

    // MARK: - TextField Delegates

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

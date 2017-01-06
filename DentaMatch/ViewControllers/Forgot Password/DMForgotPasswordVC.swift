//
//  DMForgotPasswordVC.swift
//  DentaMatch
//
//  Created by Rajan Maheshwari on 12/12/16.
//  Copyright © 2016 Appster. All rights reserved.
//

import UIKit

class DMForgotPasswordVC: DMBaseVC,UITextFieldDelegate {

    @IBOutlet weak var emailTextField: AnimatedLeftViewPHTextField!
    
    var forgotPasswordParams = [
        Constants.ServerKeys.email:""
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
    
    func setup() {
        emailTextField.leftViewLabel?.text = "f"
        self.title = "FORGOT PASSWORD"
        self.navigationItem.leftBarButtonItem = self.backBarButton()
    }
    @IBAction func sendButtonPressed(_ sender: Any) {
        self.view.endEditing(true)
        if emailTextField.text!.isValidEmail {
            forgotPasswordParams[Constants.ServerKeys.email] = self.emailTextField.text!
            self.forgotPasswordAPI(params: forgotPasswordParams)
        } else {
            self.makeToast(toastString: Constants.AlertMessages.invalidEmail)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
}

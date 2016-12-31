//
//  DMForgotPasswordVC.swift
//  DentaMatch
//
//  Created by Rajan Maheshwari on 12/12/16.
//  Copyright © 2016 Appster. All rights reserved.
//

import UIKit

class DMForgotPasswordVC: DMBaseVC,UITextFieldDelegate {

    @IBOutlet weak var emailTextField: AnimatedPHTextField!
    
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
    
    func setup() {
        emailTextField.leftViewLabel?.text = "f"
        self.title = "FORGOT PASSWORD"
        self.navigationItem.leftBarButtonItem = self.backBarButton()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
}

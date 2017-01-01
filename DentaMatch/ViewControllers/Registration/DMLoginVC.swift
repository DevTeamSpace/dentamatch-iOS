//
//  DMLoginVC.swift
//  DentaMatch
//
//  Created by Rajan Maheshwari on 26/10/16.
//  Copyright © 2016 Appster. All rights reserved.
//

import UIKit

class DMLoginVC: DMBaseVC {

    @IBOutlet weak var loginTableView: UITableView!
        
    //MARK:- View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.loginTableView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }

    //MARK:- Keyboard Show Hide Observers
    func keyboardWillShow(note: NSNotification) {
        if let keyboardSize = (note.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            loginTableView.contentInset =  UIEdgeInsetsMake(0, 0, keyboardSize.height+10, 0)
        }
    }
    
    func keyboardWillHide(note: NSNotification) {
        loginTableView.contentInset =  UIEdgeInsetsMake(0, 0, 0, 0)
    }

    //MARK:- Private Methods
    func setup() {
        self.loginTableView.register(UINib(nibName: "LoginTableViewCell", bundle: nil), forCellReuseIdentifier: "LoginTableViewCell")
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.loginTableView.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    func forgotPasswordButtonPressed() {
        self.view.endEditing(true)
        let forgotPasswordVC = UIStoryboard.registrationStoryBoard().instantiateViewController(type: DMForgotPasswordVC.self)!
        self.navigationController?.pushViewController(forgotPasswordVC, animated: true)
    }
    
    func loginButtonPressed() {
        self.view.endEditing(true)
        print("Login API")
    }
}

extension DMLoginVC:UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.tag == 1 {
            //Email TextField
            if let cell = self.loginTableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? LoginTableViewCell {
                cell.passwordTextField.becomeFirstResponder()
            }
        } else {
            //Password TextField
            textField.resignFirstResponder()
        }
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if let textField = textField as? AnimatedLeftViewPHTextField {
            textField.layer.borderColor = kTextFieldColorSelected.cgColor
            textField.leftViewLabel?.textColor = kTextFieldColorSelected
        }
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if let textField = textField as? AnimatedLeftViewPHTextField {
            textField.layer.borderColor = kTextFieldBorderColor.cgColor
            textField.leftViewLabel?.textColor = kTextFieldLeftViewModeColor
        }
        return true
    }
}

extension DMLoginVC:UITableViewDataSource,UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LoginTableViewCell") as! LoginTableViewCell
        cell.emailTextField.delegate = self
        cell.passwordTextField.delegate = self
        cell.loginButton.addTarget(self, action: #selector(loginButtonPressed), for: .touchUpInside)
        cell.forgotPasswordButton.addTarget(self, action: #selector(forgotPasswordButtonPressed), for: .touchUpInside)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.loginTableView.frame.size.height
    }

}

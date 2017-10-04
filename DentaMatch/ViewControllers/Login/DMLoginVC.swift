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
    
    var loginParams = [
        Constants.ServerKey.deviceId:"",
        Constants.ServerKey.deviceToken:"",
        Constants.ServerKey.deviceType:"",
        Constants.ServerKey.email:"",
        Constants.ServerKey.password:"",
    ]
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
    @objc func keyboardWillShow(note: NSNotification) {
        if let keyboardSize = (note.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            loginTableView.contentInset =  UIEdgeInsetsMake(0, 0, keyboardSize.height+1, 0)
        }
    }
    
    @objc func keyboardWillHide(note: NSNotification) {
        loginTableView.contentInset =  UIEdgeInsetsMake(0, 0, 0, 0)
    }

    //MARK:- Private Methods
    func setup() {
        self.loginTableView.register(UINib(nibName: "LoginTableViewCell", bundle: nil), forCellReuseIdentifier: "LoginTableViewCell")
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.loginTableView.addGestureRecognizer(tap)
    }
    
    func clearData() {
        if let cell = self.loginTableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? LoginTableViewCell {
            cell.emailTextField.text = ""
            cell.passwordTextField.text = ""
        }
    }
    
    func validateFields() -> Bool {
        if loginParams[Constants.ServerKey.email]!.isValidEmail {
            if !loginParams[Constants.ServerKey.password]!.isEmpty {
                return true
            } else {
                self.makeToast(toastString: Constants.AlertMessage.emptyPassword)
                return false
            }
        } else {
            self.makeToast(toastString: Constants.AlertMessage.invalidEmail)
            return false
        }
    }
    
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    func openTabbar() {
        let dashboardVC = UIStoryboard.dashBoardStoryBoard().instantiateViewController(type: TabBarVC.self)!
        kAppDelegate.window?.rootViewController = dashboardVC
        UserDefaultsManager.sharedInstance.isProfileSkipped = true
        SocketManager.sharedInstance.establishConnection()

    }
    func openJobTitleSelection() {
        let jobTitleSectionVC = UIStoryboard.profileStoryBoard().instantiateViewController(withIdentifier: Constants.StoryBoard.Identifer.profileNav)
        UIView.transition(with: self.view.window!, duration: 0.5, options: .transitionFlipFromRight, animations: {
            kAppDelegate.window?.rootViewController = jobTitleSectionVC
            SocketManager.sharedInstance.establishConnection()
        }) { (bool:Bool) in
            
        }
    }
    
    //MARK:- IBActions
    @objc func forgotPasswordButtonPressed() {
        self.view.endEditing(true)
        let forgotPasswordVC = UIStoryboard.registrationStoryBoard().instantiateViewController(type: DMForgotPasswordVC.self)!
        self.navigationController?.pushViewController(forgotPasswordVC, animated: true)
    }
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        self.view.endEditing(true)
        loginParams[Constants.ServerKey.deviceId] = Utilities.deviceId()
        loginParams[Constants.ServerKey.deviceType] = "iOS"
        loginParams[Constants.ServerKey.deviceToken] = UserDefaultsManager.sharedInstance.deviceToken
        if validateFields() {
            self.loginAPI(params: loginParams)
        }
    }
}

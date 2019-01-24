//
//  DMLoginVC.swift
//  DentaMatch
//
//  Created by Rajan Maheshwari on 26/10/16.
//  Copyright © 2016 Appster. All rights reserved.
//

import UIKit

class DMLoginVC: DMBaseVC {
    @IBOutlet var loginTableView: UITableView!

    var loginParams = [
        Constants.ServerKey.deviceId: "",
        Constants.ServerKey.deviceToken: "",
        Constants.ServerKey.deviceType: "",
        Constants.ServerKey.email: "",
        Constants.ServerKey.password: "",
    ]

    // MARK: - View LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loginTableView.reloadData()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: - Keyboard Show Hide Observers

    @objc func keyboardWillShow(note: NSNotification) {
        if let keyboardSize = (note.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            loginTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height + 1, right: 0)
        }
    }

    @objc func keyboardWillHide(note _: NSNotification) {
        loginTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }

    // MARK: - Private Methods

    func setup() {
        loginTableView.register(UINib(nibName: "LoginTableViewCell", bundle: nil), forCellReuseIdentifier: "LoginTableViewCell")
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        loginTableView.addGestureRecognizer(tap)
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
                makeToast(toastString: Constants.AlertMessage.emptyPassword)
                return false
            }
        } else {
            makeToast(toastString: Constants.AlertMessage.invalidEmail)
            return false
        }
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

    func openJobTitleSelection() {
        let jobTitleSectionVC = UIStoryboard.profileStoryBoard().instantiateViewController(withIdentifier: Constants.StoryBoard.Identifer.profileNav)
        UIView.transition(with: view.window!, duration: 0.5, options: .transitionFlipFromRight, animations: {
            kAppDelegate?.window?.rootViewController = jobTitleSectionVC
            SocketManager.sharedInstance.establishConnection()
        }) { (_: Bool) in
        }
    }

    // MARK: - IBActions

    @objc func forgotPasswordButtonPressed() {
        view.endEditing(true)
        let forgotPasswordVC = UIStoryboard.registrationStoryBoard().instantiateViewController(type: DMForgotPasswordVC.self)!
        navigationController?.pushViewController(forgotPasswordVC, animated: true)
    }

    @IBAction func loginButtonPressed(_: Any) {
        view.endEditing(true)
        loginParams[Constants.ServerKey.deviceId] = Utilities.deviceId()
        loginParams[Constants.ServerKey.deviceType] = "iOS"
        loginParams[Constants.ServerKey.deviceToken] = UserDefaultsManager.sharedInstance.deviceToken
        if validateFields() {
            loginAPI(params: loginParams)
        }
    }
}

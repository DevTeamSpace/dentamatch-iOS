//
//  DMRegistrationVC.swift
//  DentaMatch
//
//  Created by Rajan Maheshwari on 25/10/16.
//  Copyright © 2016 Appster. All rights reserved.
//

import UIKit

class DMRegistrationVC: DMBaseVC,UITextFieldDelegate {

    @IBOutlet weak var registrationTableView: UITableView!
    
    //MARK:- View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    //MARK:- Keyboard Show Hide Observers
    func keyboardWillShow(note: NSNotification) {
        if let keyboardSize = (note.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            registrationTableView.contentInset =  UIEdgeInsetsMake(0, 0, keyboardSize.height+1, 0)
        }
    }
    
    func keyboardWillHide(note: NSNotification) {
        registrationTableView.contentInset =  UIEdgeInsetsMake(0, 0, 0, 0)
    }
    
    //MARK:- Private Methods
    func setup() {
        self.registrationTableView.register(UINib(nibName: "RegistrationTableViewCell", bundle: nil), forCellReuseIdentifier: "RegistrationTableViewCell")
    }
    
    func registerButtonPressed(sender:UIButton) {
        let termsVC = UIStoryboard.registrationStoryBoard().instantiateViewController(type: DMTermsAndConditionsVC.self)!
        self.navigationController?.pushViewController(termsVC, animated: true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

//MARK:- Extensions
extension DMRegistrationVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RegistrationTableViewCell") as! RegistrationTableViewCell
        cell.emailTextField.delegate = self
        cell.newPasswordTextField.delegate = self
        cell.nameTextField.delegate = self
        cell.delegate = self
        cell.registerButton.addTarget(self, action: #selector(registerButtonPressed), for: .touchUpInside)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 475
    }
}

extension DMRegistrationVC:LocationViewTappedDelegate,LocationAddressDelegate {
    
    func locationViewDidTap() {
        let mapVC = UIStoryboard.registrationStoryBoard().instantiateViewController(type: DMRegisterMapsVC.self)!
        mapVC.delegate = self
        self.navigationController?.pushViewController(mapVC, animated: true)
    }
    
    func locationAddress(address: String) {
        if address.isEmpty {
            debugPrint("Address is empty")
        } else {
            debugPrint(address)
        }
    }
}

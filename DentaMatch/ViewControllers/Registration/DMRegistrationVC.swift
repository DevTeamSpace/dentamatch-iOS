//
//  DMRegistrationVC.swift
//  DentaMatch
//
//  Created by Rajan Maheshwari on 25/10/16.
//  Copyright © 2016 Appster. All rights reserved.
//

import UIKit
import CoreLocation

class DMRegistrationVC: DMBaseVC {

    @IBOutlet weak var registrationTableView: UITableView!
    var coordinateSelected:CLLocationCoordinate2D?
    
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.registrationTableView.reloadData()
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
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.registrationTableView.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    func registerButtonPressed(sender:UIButton) {
        let termsVC = UIStoryboard.registrationStoryBoard().instantiateViewController(type: DMTermsAndConditionsVC.self)!
        self.navigationController?.pushViewController(termsVC, animated: true)
    }
}

//MARK:- Extensions
extension DMRegistrationVC:UITextFieldDelegate {
    //MARK:- TextField Delegates
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        switch textField.tag {
        case 1:
            if let cell = self.registrationTableView.cellForRow(at: IndexPath(row: 0, section: 0)) as?
                RegistrationTableViewCell {
                cell.emailTextField.becomeFirstResponder()
            }
        case 2:
            if let cell = self.registrationTableView.cellForRow(at: IndexPath(row: 0, section: 0)) as?
                RegistrationTableViewCell {
                cell.newPasswordTextField.becomeFirstResponder()
            }
        case 3:
            textField.resignFirstResponder()
        default:
            break
        }
        return true
    }

    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if let cell = self.registrationTableView.cellForRow(at: IndexPath(row: 0, section: 0)) as?
            RegistrationTableViewCell {
            if textField == cell.preferredLocationTextField {
                let mapVC = UIStoryboard.registrationStoryBoard().instantiateViewController(type: DMRegisterMapsVC.self)!
                mapVC.delegate = self
                self.navigationController?.pushViewController(mapVC, animated: true)
                self.view.endEditing(true)
                return false
            }
        }
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

extension DMRegistrationVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RegistrationTableViewCell") as! RegistrationTableViewCell
        cell.emailTextField.delegate = self
        cell.newPasswordTextField.delegate = self
        cell.nameTextField.delegate = self
        cell.preferredLocationTextField.delegate = self
        cell.registerButton.addTarget(self, action: #selector(registerButtonPressed), for: .touchUpInside)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.registrationTableView.frame.size.height
    }
}

extension DMRegistrationVC:LocationAddressDelegate {
    
    func locationAddress(address: String?, coordinate: CLLocationCoordinate2D?) {
        coordinateSelected = coordinate
        if let address = address {
            if let cell = self.registrationTableView.cellForRow(at: IndexPath(row: 0, section: 0)) as?
                RegistrationTableViewCell {
                cell.preferredLocationTextField.text = address
            }
            debugPrint(address)
        } else {
            debugPrint("Address is empty")
        }
    }
}

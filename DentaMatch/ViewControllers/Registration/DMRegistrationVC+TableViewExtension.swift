//
//  DMRegistrationVC+TableViewExtension.swift
//  DentaMatch
//
//  Created by Rajan Maheshwari on 05/01/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import Foundation

//MARK:- TableView Datasource/Delegates
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
        cell.termsAndConditionsTextView.delegate = self
        
        if self.termsAndConditionsAccepted {
            cell.acceptTermsButton.setTitle(Constants.DesignFont.acceptTermsSelected, for: .normal)
            cell.acceptTermsButton.setTitleColor(kTextFieldColorSelected, for: .normal)
        } else {
            cell.acceptTermsButton.setTitle(Constants.DesignFont.acceptTermsDeSelected, for: .normal)
            cell.acceptTermsButton.setTitleColor(UIColor.color(withHexCode: "979797"), for: .normal)

        }
        
        cell.registerButton.addTarget(self, action: #selector(registerButtonPressed), for: .touchUpInside)
        cell.acceptTermsButton.addTarget(self, action: #selector(acceptTermsButtonPressed), for: .touchUpInside)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.registrationTableView.frame.size.height
    }
}

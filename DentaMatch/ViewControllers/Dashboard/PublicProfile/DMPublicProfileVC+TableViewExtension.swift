//
//  DMPublicProfileVC+TableViewExtension.swift
//  DentaMatch
//
//  Created by Rajan Maheshwari on 19/01/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import Foundation

extension DMPublicProfileVC : UITableViewDataSource,UITableViewDelegate,UITextViewDelegate,UITextFieldDelegate {
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 645
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EditPublicProfileTableCell") as! EditPublicProfileTableCell
        cell.firstNameTextField.delegate = self
        cell.lastNameTextField.delegate = self
        cell.jobTitleTextField.delegate = self
        cell.locationTextField.delegate = self

        return cell
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if let textField = textField as? AnimatedPHTextField {
            textField.layer.borderColor = Constants.Color.textFieldColorSelected.cgColor
        }
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if let textField = textField as? AnimatedPHTextField {
            textField.layer.borderColor = Constants.Color.textFieldBorderColor.cgColor
        }
        return true
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        
        self.publicProfileTableView.contentInset =  UIEdgeInsetsMake(0, 0, 200, 0)
        DispatchQueue.main.async {
            self.publicProfileTableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .bottom, animated: true)
        }
        return true
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        self.publicProfileTableView.contentInset =  UIEdgeInsetsMake(0, 0, 0, 0)
        
        return true
    }
    
    func textViewDidChange(_ textView: UITextView) {
    
    }
}

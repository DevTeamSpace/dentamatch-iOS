//
//  DMPublicProfileVC+TableViewExtension.swift
//  DentaMatch
//
//  Created by Rajan Maheshwari on 19/01/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import Foundation

extension DMPublicProfileVC : UITableViewDataSource,UITableViewDelegate,UITextViewDelegate {
    
    
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
        
        cell.firstNameTextField.text = UserManager.shared().activeUser.firstName
        cell.lastNameTextField.text = UserManager.shared().activeUser.lastName
        cell.jobTitleTextField.text = UserManager.shared().activeUser.jobTitle
        cell.jobTitleTextField.type = 1
        cell.jobTitleTextField.tintColor = UIColor.clear
        cell.jobTitleTextField.inputView = jobSelectionPickerView

        cell.locationTextField.type = 2
        cell.locationTextField.text = UserManager.shared().activeUser.preferredJobLocation
        cell.addEditProfileButton.addTarget(self, action: #selector(addPhoto), for: .touchUpInside)
        if profileImage == nil {
            if let imageUrl = URL(string: UserManager.shared().activeUser.profileImageURL!) {
                cell.profileButton.sd_setImage(with: imageUrl, for: .normal, placeholderImage: kPlaceHolderImage)
            }
        } else {
            cell.profileButton.setImage(self.profileImage, for: .normal)
        }
        return cell
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

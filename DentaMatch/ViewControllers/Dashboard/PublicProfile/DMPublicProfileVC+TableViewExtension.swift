//
//  DMPublicProfileVC+TableViewExtension.swift
//  DentaMatch
//
//  Created by Rajan Maheshwari on 19/01/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import Foundation

extension DMPublicProfileVC: UITableViewDataSource, UITableViewDelegate, UITextViewDelegate {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt _: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EditPublicProfileTableCell") as! EditPublicProfileTableCell
        cell.firstNameTextField.delegate = self
        cell.lastNameTextField.delegate = self
        cell.jobTitleTextField.delegate = self
        cell.licenseNumberTextField.delegate = self


        cell.preferredJobLocationTextField.delegate = self
        cell.aboutMeTextView.delegate = self
        cell.aboutMeTextView.text = editProfileParams[Constants.ServerKey.aboutMe]
        cell.placeHolderLabel.isHidden = editProfileParams[Constants.ServerKey.aboutMe]!.isEmpty ? false : true
        cell.firstNameTextField.text = editProfileParams[Constants.ServerKey.firstName]
        cell.lastNameTextField.text = editProfileParams[Constants.ServerKey.lastName]
        cell.jobTitleTextField.text = UserManager.shared().activeUser.jobTitle
        cell.licenseNumberTextField.text = licenseString // UserManager.shared().activeUser.licenseNumber
        cell.preferredJobLocationTextField.text = UserManager.shared().activeUser.preferredJobLocation
        cell.stateTextField.text = stateString // UserManager.shared().activeUser.state
        cell.stateFieldAction { [weak self](text) in
            self?.goToStates(text)
        }
        cell.jobTitleTextField.type = 1
        cell.jobTitleTextField.tintColor = UIColor.clear
        cell.jobTitleTextField.inputView = jobSelectionPickerView
        cell.preferredJobLocationTextField.inputView = preferredJobLocationPickerView
        cell.addEditProfileButton.addTarget(self, action: #selector(addPhoto), for: .touchUpInside)
        if profileImage == nil {
            if let imageUrl = URL(string: UserManager.shared().activeUser.profileImageURL!) {
                cell.profileButton.sd_setImage(with: imageUrl, for: .normal, placeholderImage: kPlaceHolderImage)
            }
        } else {
            cell.profileButton.setImage(profileImage, for: .normal)
        }
        
        return cell
    }

    func textViewShouldBeginEditing(_: UITextView) -> Bool {
        publicProfileTableView.contentInset = UIEdgeInsetsMake(0, 0, 200, 0)
        DispatchQueue.main.async {
            self.publicProfileTableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .bottom, animated: true)
        }
        return true
    }

    func textViewDidBeginEditing(_ textView: UITextView) {
        if let cell = self.publicProfileTableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? EditPublicProfileTableCell {
            if !textView.text.isEmpty {
                cell.placeHolderLabel.isHidden = true
            } else {
                cell.placeHolderLabel.isHidden = false
            }
        }
    }

    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        publicProfileTableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
        editProfileParams[Constants.ServerKey.aboutMe] = textView.text
        return true
    }

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        guard text.count > 0 else {
            return true
        }
        if textView.text.count >= Constants.Limit.aboutMeLimit && range.length == 0 {
            return false
        }
        if textView.text.count + text.count > Constants.Limit.aboutMeLimit && range.length == 0 {
            let remainingTextCount = Constants.Limit.aboutMeLimit - textView.text.count
            textView.text = textView.text + text.stringFrom(0, to: remainingTextCount)
            return false
        }

        return true
    }

    func textViewDidChange(_ textView: UITextView) {
        editProfileParams[Constants.ServerKey.aboutMe] = textView.text
        if let cell = self.publicProfileTableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? EditPublicProfileTableCell {
            if !textView.text.isEmpty {
                cell.placeHolderLabel.isHidden = true
            } else {
                cell.placeHolderLabel.isHidden = false
            }
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if let cell = self.publicProfileTableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? EditPublicProfileTableCell {
            if !textView.text.isEmpty {
                cell.placeHolderLabel.isHidden = true
            } else {
                cell.placeHolderLabel.isHidden = false
            }
        }
    }
}

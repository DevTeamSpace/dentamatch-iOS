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
            cell.profileButton.sd_setImage(with: URL(string: UserManager.shared().activeUser.profileImageURL!)!, for: .normal, placeholderImage: kPlaceHolderImage)
        } else {
            cell.profileButton.setImage(self.profileImage, for: .normal)
        }
        return cell
    }
    
    func cellConfigureForJobSelection(cell:AnimatedPHTableCell, indexPath:IndexPath) {
        
       /* cell.commonTextField.placeholder = FieldType.CurrentJobTitle.description
        let pickerView = JobSelectionPickerView.loadJobSelectionView(withJobTitles: jobTitles!)
        cell.commonTextField.type = 1
        cell.commonTextField.tintColor = UIColor.clear
        cell.commonTextField.inputView = pickerView
        pickerView.delegate = self
        cell.commonTextField.tag = 0
        pickerView.pickerView.reloadAllComponents()
        pickerView.backgroundColor = UIColor.white*/
        
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if let cell = self.publicProfileTableView.cellForRow(at: IndexPath(row: 0, section: 0)) as?
            EditPublicProfileTableCell {
            if textField == cell.locationTextField {
                let mapVC = UIStoryboard.registrationStoryBoard().instantiateViewController(type: DMRegisterMapsVC.self)!
                mapVC.delegate = self
                self.navigationController?.pushViewController(mapVC, animated: true)
                self.view.endEditing(true)
                return false
            }
        }
        
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

//MARK:- LocationAddress Delegate
extension DMPublicProfileVC:LocationAddressDelegate {
    func locationAddress(location: Location) {
        //coordinateSelected = location.coordinateSelected
        if let address = location.address {
            if let cell = self.publicProfileTableView.cellForRow(at: IndexPath(row: 0, section: 0)) as?
                EditPublicProfileTableCell {
                cell.locationTextField.text = address
                
                /*registrationParams[Constants.ServerKey.zipCode] = location.postalCode
                registrationParams[Constants.ServerKey.preferredLocation] = address
                registrationParams[Constants.ServerKey.latitude] = "\((coordinateSelected?.latitude)!)"
                registrationParams[Constants.ServerKey.longitude] = "\((coordinateSelected?.longitude)!)"*/
            }
            debugPrint(address)
        } else {
            debugPrint("Address is empty")
        }
    }
}

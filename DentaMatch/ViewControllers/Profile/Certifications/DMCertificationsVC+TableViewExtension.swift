//
//  DMCertificationsVC+TableViewExtension.swift
//  DentaMatch
//
//  Created by Rajan Maheshwari on 10/01/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import Foundation

extension DMCertificationsVC : UITableViewDataSource,UITableViewDelegate , UITextFieldDelegate{
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let certificationOption = Certifications(rawValue: section)!
        
        switch certificationOption {
        case .profileHeader:
            return 1
        case .certifications:
            return certicates.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let certificationOption = Certifications(rawValue: indexPath.section)!
        
        switch certificationOption {
        case .profileHeader:
            return 213
        case .certifications:
            return 350
        }

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let certificationOption = Certifications(rawValue: indexPath.section)!

        switch certificationOption {
        case .profileHeader:
            let cell = tableView.dequeueReusableCell(withIdentifier: "PhotoNameCell") as! PhotoNameCell
            cell.nameLabel.text = "Update Certifications "
            cell.jobTitleLabel.text = "Lorem Ipsum is simply dummy text for the typing and printing industry"
            if let imageURL = URL(string: UserDefaultsManager.sharedInstance.profileImageURL) {
                cell.photoButton.sd_setImage(with: imageURL, for: .normal, placeholderImage: kPlaceHolderImage)
            }
            cell.photoButton.progressBar.setProgress(profileProgress, animated: true)
            return cell
            
        case .certifications:
            let cell = tableView.dequeueReusableCell(withIdentifier: "CertificationsCell") as! CertificationsCell
            let certificate = certicates[indexPath.row]
            cell.validityDateTextField.tag = indexPath.row
            cell.validityDateTextField.inputView = dateView
            cell.validityDateTextField.delegate = self
            cell.validityDateTextField.text = certificate.validityDate
            cell.headingLabel.text = certificate.certificationName
            cell.photoButton.tag = indexPath.row
            cell.photoButton.addTarget(self, action: #selector(DMCertificationsVC.certificationImageButtonPressed(_:)), for: .touchUpInside)


            if let imageURL = URL(string: certificate.certificateImageURL!) {
                if imageURL.absoluteString.isEmpty {
//                    cell.photoButton.setImage(certificate.certificateImage, for: .normal)
                } else {
                cell.photoButton.sd_setImage(with: imageURL, for: .normal, placeholderImage: UIImage(named: ""))
                }
            }else{
                
                if certificate.certificateImage != nil {
                    cell.photoButton.setImage(certificate.certificateImage, for: .normal)
                }else{
                    cell.photoButton.setImage(UIImage(named: ""), for: .normal)
                }
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
  
    }

    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        self.dateView?.getPreSelectedValues(dateString: textField.text!, curTag: textField.tag)
        debugPrint("set Tag =\(textField.tag)")
        if let textField = textField as? PickerAnimatedTextField {
            textField.layer.borderColor = Constants.Color.textFieldColorSelected.cgColor
        }
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if let textField = textField as? PickerAnimatedTextField {
            textField.layer.borderColor = Constants.Color.textFieldBorderColor.cgColor
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

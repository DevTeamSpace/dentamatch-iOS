//
//  DMLicenseSelectionVC+TableViewExtension.swift
//  DentaMatch
//
//  Created by Rajan Maheshwari on 11/01/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import Foundation
import SDWebImage

extension DMLicenseSelectionVC : UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    /*
     func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
     {
     let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 45))
     let headerLabel = UILabel(frame: headerView.frame)
     headerLabel.frame.origin.x = 20
     headerLabel.backgroundColor = UIColor.clear
     headerLabel.font = UIFont.fontMedium(fontSize: 14)
     headerView.addSubview(headerLabel)
     headerView.backgroundColor = UIColor(red: 248.0/255.0, green: 248.0/255.0, blue: 248.0/255.0, alpha: 1.0)
     if section == 1
     {
     headerLabel.text = "ADD DENTAL STATE BOARD"
     }else{
     headerLabel.text = "LICENSE"
     }
     
     return headerView
     }
     */
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch indexPath.row {
        case 0:
            return 213
        case 1,3:
            return 45
        case 2:
            return 203
        case 4,5:
            return 109
        default:
            debugPrint("Text")
        }
        return 109
        
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "PhotoNameCell") as! PhotoNameCell
            cell.nameLabel.text = "Jennifer"
            cell.jobTitleLabel.text = selectedJobTitle.jobTitle
            if let imageURL = URL(string: UserDefaultsManager.sharedInstance.profileImageURL) {
                cell.photoButton.sd_setImage(with: imageURL, for: .normal, placeholderImage: UIImage(named: "profileButton"))
            }
            cell.photoButton.progressBar.setProgress(profileProgress, animated: true)
            cell.selectionStyle = .none
            
            return cell
            
        case 1,3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SectionHeadingTableCell") as! SectionHeadingTableCell
            cell.selectionStyle = .none
            let text  = indexPath.row == 1 ? "ADD DENTAL STATE BOARD":"LICENSE"
            cell.headingLabel.text = text
            return cell
            
        //SectionHeadingTableCell
        case 2:
            debugPrint("row 1")
            let cell = tableView.dequeueReusableCell(withIdentifier: "PhotoCell") as! PhotoCell
            
            cell.stateBoardPhotoButton.addTarget(self, action: #selector(DMLicenseSelectionVC.stateBoardButtonPressed(_:)), for: .touchUpInside)
            if self.stateBoardImage == nil{
                cell.stateBoardPhotoButton .setTitle("h", for: .normal)
            }else{
                cell.stateBoardPhotoButton .setTitle("", for: .normal)
                cell.stateBoardPhotoButton.alpha = 1.0
                cell.stateBoardPhotoButton.backgroundColor = UIColor.clear
                cell.stateBoardPhotoButton.setImage(self.stateBoardImage!, for: .normal)
            }
            
            cell.selectionStyle = .none
            return cell
            
        case 4,5:
            
            debugPrint("row 2")
            let cell = tableView.dequeueReusableCell(withIdentifier: "AnimatedPHTableCell") as! AnimatedPHTableCell
            
            cell.commonTextField.delegate = self
            cell.commonTextField.autocapitalizationType = .sentences
            if indexPath.row == 4
            {
                cell.commonTextField.tag = 0
                cell.cellTopSpace.constant = 43.5
                cell.cellBottomSpace.constant = 10.5
                cell.commonTextField.placeholder = "License Number"
                cell.layoutIfNeeded()
            }else if indexPath.row == 5
            {
                cell.commonTextField.tag = 1
                cell.commonTextField.placeholder = "State"
                cell.cellTopSpace.constant = 10.5
                cell.cellBottomSpace.constant = 41.5
                cell.layoutIfNeeded()
            }
            return cell
            
        default:
            debugPrint("Default")
            
        }
        
        return UITableViewCell()
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
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
    
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard string.characters.count > 0 else {
            return true
        }
        
        if textField.tag == 0 {
            let characterset = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLKMNOPQRSTUVWXYZ0123456789-")
            if string.rangeOfCharacter(from: characterset.inverted) != nil {
                print("string contains special characters")
                return false
            }
            
            if (textField.text?.characters.count)! >= Constants.Limit.licenseNumber {
                return false
            }
            
        }else{
            if (textField.text?.characters.count)! >= Constants.Limit.commonMaxLimit {
                return false
            }
            
        }
        
        return true
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.text = textField.text?.trim()
        if textField.tag == 0
        {
            self.licenseArray?.replaceObject(at: 0, with: textField.text!)
        }else{
            self.licenseArray?.replaceObject(at: 1, with: textField.text!)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
}

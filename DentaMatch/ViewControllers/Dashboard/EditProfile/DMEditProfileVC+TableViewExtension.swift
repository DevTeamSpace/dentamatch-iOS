//
//  DMEditProfileVC+TableViewExtension.swift
//  DentaMatch
//
//  Created by Rajan Maheshwari on 17/01/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import Foundation

extension DMEditProfileVC : UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let profileOptions = EditProfileOptions(rawValue: indexPath.section)!
        switch profileOptions {
        case .profileHeader:
            return 426
            
        case .dentalStateboard:
            if indexPath.row == 0 {
                return 45
            } else {
                return 72
            }
            
        case .experience:
            if indexPath.row == 0 {
                return 45
            } else {
                return 72
            }
            
        case .schooling:
            if indexPath.row == 0 {
                return 45
            } else {
                return 72
            }
            
        case .keySkills:
            if indexPath.row == 0 {
                return 45
            } else {
                return 72
            }
            
        case .affiliations:
            if indexPath.row == 0 {
                return 45
            } else {
                return 72
            }
            
        case .licenseNumber:
            if indexPath.row == 0 {
                return 45
            } else {
                if let _ = license {
                    return 87
                }
                return 72
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let profileOptions = EditProfileOptions(rawValue: section)!
        
        switch profileOptions {
        case .profileHeader:
            return 1
        default : return 2
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let profileOptions = EditProfileOptions(rawValue: indexPath.section)!
        
        switch profileOptions {
        case .profileHeader:
            let cell = tableView.dequeueReusableCell(withIdentifier: "EditProfileHeaderTableCell") as! EditProfileHeaderTableCell
            cell.nameLabel.text = UserManager.shared().activeUser.fullName()
            if let imageUrl = URL(string: UserManager.shared().activeUser.profileImageURL!) {
                cell.profileButton.sd_setImage(with: imageUrl, for: .normal, placeholderImage: kPlaceHolderImage)
            }
            return cell
        
        case .dentalStateboard:
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "SectionHeadingTableCell") as! SectionHeadingTableCell
                cell.headingLabel.text = "DENTAL STATE BOARD"
                cell.editButton.isHidden = true
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "AddProfileOptionTableCell") as! AddProfileOptionTableCell
                cell.profileOptionLabel.text = "Add dental state board"
                return cell
            }
            
        case .experience:
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "SectionHeadingTableCell") as! SectionHeadingTableCell
                cell.headingLabel.text = "EXPERIENCE"
                cell.editButton.isHidden = true
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "AddProfileOptionTableCell") as! AddProfileOptionTableCell
                cell.profileOptionLabel.text = "Add more experience"
                return cell
            }
            
        case .schooling:
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "SectionHeadingTableCell") as! SectionHeadingTableCell
                cell.headingLabel.text = "SCHOOLING AND CERTIFICATION"
                cell.editButton.isHidden = true
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "AddProfileOptionTableCell") as! AddProfileOptionTableCell
                cell.profileOptionLabel.text = "Add schooling and certification"
                return cell
            }
            
        case .keySkills:
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "SectionHeadingTableCell") as! SectionHeadingTableCell
                cell.headingLabel.text = "KEY SKILLS"
                cell.editButton.isHidden = true
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "AddProfileOptionTableCell") as! AddProfileOptionTableCell
                cell.profileOptionLabel.text = "Add skills category"
                return cell
            }
            
        case .affiliations:
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "SectionHeadingTableCell") as! SectionHeadingTableCell
                cell.editButton.isHidden = true
                cell.headingLabel.text = "PROFESSIONAL AFFILIATIONS"
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "AddProfileOptionTableCell") as! AddProfileOptionTableCell
                cell.profileOptionLabel.text = "Add professional affiliations"
                return cell
            }
            
        case .licenseNumber:
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "SectionHeadingTableCell") as! SectionHeadingTableCell
                cell.headingLabel.text = "LICENSE NUMBER"
                cell.editButton.isHidden = true
                cell.editButton.addTarget(self, action: #selector(openEditLicenseScreen), for: .touchUpInside)
                if let _ = license {
                    cell.editButton.isHidden = false
                }
                return cell
            } else {
                if let _ = license {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "EditLicenseTableCell") as! EditLicenseTableCell
                    cell.stateLabel.text = license?.state
                    cell.licenceNumberLabel.text = license?.number
                    return cell
                } else {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "AddProfileOptionTableCell") as! AddProfileOptionTableCell
                    cell.profileOptionLabel.text = "Add license details"
                    return cell
                }
            }
            
        }
    }
}

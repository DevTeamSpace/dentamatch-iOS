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
            return 298
            
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
            return cell
        
        case .dentalStateboard:
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "SectionHeadingTableCell") as! SectionHeadingTableCell
                cell.headingLabel.text = "DENTAL STATE BOARD"
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
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "AddProfileOptionTableCell") as! AddProfileOptionTableCell
                cell.profileOptionLabel.text = "Add skills category"
                return cell
            }
            
        case .affiliations:
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "SectionHeadingTableCell") as! SectionHeadingTableCell
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
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "AddProfileOptionTableCell") as! AddProfileOptionTableCell
                cell.profileOptionLabel.text = "Add license details"
                return cell
            }
            
        }
    }
}

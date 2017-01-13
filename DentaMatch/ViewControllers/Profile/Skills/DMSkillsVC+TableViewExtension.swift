//
//  DMSkillsVC+TableViewExtension.swift
//  DentaMatch
//
//  Created by Rajan Maheshwari on 12/01/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import Foundation

extension DMSkillsVC : UITableViewDataSource, UITableViewDelegate {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let skillsOption = Skills(rawValue: section)!
        
        switch skillsOption {
        case .profileHeader:
            return 2
  
        case .skills:
            return skills.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let skillOption = Skills(rawValue: indexPath.section)!
        
        switch skillOption {
        case .profileHeader:
            switch indexPath.row {
            case 0:
                //Profile Header
                return 233
            case 1:
                //Heading
                return 44
            default:
                return 0
            }
        case .skills:
           return 56
        }
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let skillsOption = Skills(rawValue: indexPath.section)!
        
        switch skillsOption {
        case .profileHeader:
            switch indexPath.row {
            case 0:
                //Profile Header
                let cell = tableView.dequeueReusableCell(withIdentifier: "PhotoNameCell") as! PhotoNameCell
                cell.nameLabel.text = "Skills & Experience"
                cell.jobTitleLabel.text = "Lorem Ipsum is simply dummy text for the typing and printing industry"
                if let imageURL = URL(string: UserDefaultsManager.sharedInstance.profileImageURL) {
                    cell.photoButton.sd_setImage(with: imageURL, for: .normal, placeholderImage: kPlaceHolderImage)
                }
                cell.photoButton.progressBar.setProgress(profileProgress, animated: true)
                return cell
                
            case 1:
                //Heading
                let cell = tableView.dequeueReusableCell(withIdentifier: "SectionHeadingTableCell") as! SectionHeadingTableCell
                return cell
                
            default:
                return UITableViewCell()
            }
        case .skills:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SkillsTableCell") as! SkillsTableCell
            let skill = skills[indexPath.row]
            cell.skillLabel.text = skill.skillName
            return cell
            
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
       self.presentRightMenuViewController()

    }
    
}

//
//  DMStudy+TableViewExtension.swift
//  DentaMatch
//
//  Created by Rajan Maheshwari on 10/01/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import Foundation

extension DMStudyVC : UITableViewDataSource,UITableViewDelegate {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        let studyOption = Study(rawValue: section)!

        switch studyOption {
        case .profileHeader:
            return 2
        case .school:
            return school.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let studyOption = Study(rawValue: indexPath.section)!

        switch studyOption {
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
        case .school:
            let dict = school[indexPath.row]
            if !(dict["isOpen"] as? Bool)! {
                return 60
            } else {
                return 202
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let studyOption = Study(rawValue: indexPath.section)!

        switch studyOption {
            
        case .profileHeader:
            switch indexPath.row {
            case 0:
                //Profile Header
                let cell = tableView.dequeueReusableCell(withIdentifier: "PhotoNameCell") as! PhotoNameCell
                cell.nameLabel.text = "Where did you Study?"
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

        case .school:
            let cell = tableView.dequeueReusableCell(withIdentifier: "StudyCell") as! StudyCell
            let dict = school[indexPath.row]
            cell.headingButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
            cell.headingButton.tag = indexPath.row
            cell.headingButton.setTitle(dict["name"] as? String, for: .normal)
            return cell
        }
    }
    
    func buttonTapped(sender:UIButton) {
        var dict = school[sender.tag]
        if (dict["isOpen"] as? Bool)! {
            dict["isOpen"] = false as AnyObject?
        } else {
            dict["isOpen"] = true as AnyObject?
        }
        school[sender.tag] = dict
        
        self.studyTableView.reloadRows(at: [IndexPath(row: sender.tag, section: 1)], with: .automatic)
        DispatchQueue.main.async {
            self.studyTableView.scrollToRow(at: IndexPath(row: sender.tag, section: 1), at: .bottom, animated: true)
            
        }
    }
}

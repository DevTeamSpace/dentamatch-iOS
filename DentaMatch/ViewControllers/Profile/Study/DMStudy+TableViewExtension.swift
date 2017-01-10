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
        if section == 0 {
            return 2
        } else {
            return school.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            //Profile + Heading
            switch indexPath.row {
            case 0:
                return 233
            case 1:
                return 44
            default:
                return 0
            }
        } else {
            //Schooling
            let dict = school[indexPath.row]
            if !(dict["isOpen"] as? Bool)! {
                return 60
            } else {
                return 202
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //Profile + Heading
        if indexPath.section == 0 {
            
            switch indexPath.row {
                
            case 0:
                let cell = tableView.dequeueReusableCell(withIdentifier: "PhotoNameCell") as! PhotoNameCell
                cell.nameLabel.text = "Where did you Study?"
                cell.jobTitleLabel.text = "Lorem Ipsum is simply dummy text for the typing and printing industry"
                cell.photoButton.progressBar.setProgress(profileProgress, animated: true)
                return cell
            
            case 1:
                let cell = tableView.dequeueReusableCell(withIdentifier: "SectionHeadingTableCell") as! SectionHeadingTableCell
                return cell
                
            default:
                return UITableViewCell()
            }
        } else {
            //Schooling
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

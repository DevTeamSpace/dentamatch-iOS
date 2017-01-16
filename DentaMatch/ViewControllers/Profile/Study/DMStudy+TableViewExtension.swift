//
//  DMStudy+TableViewExtension.swift
//  DentaMatch
//
//  Created by Rajan Maheshwari on 10/01/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import Foundation

extension DMStudyVC : UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        let studyOption = Study(rawValue: section)!

        switch studyOption {
        case .profileHeader:
            return 2
        case .school:
            return schoolCategories.count
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
            let schoolCategory = schoolCategories[indexPath.row]
            if !schoolCategory.isOpen {
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
            let school = schoolCategories[indexPath.row]
            cell.headingButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
            cell.schoolNameTextField.delegate = self
            cell.schoolNameTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
            cell.headingButton.tag = indexPath.row
            cell.headingButton.setTitle(school.schoolCategoryName, for: .normal)
            return cell
        }
    }
    
    func buttonTapped(sender:UIButton) {
        let school = schoolCategories[sender.tag]
        if school.isOpen {
            school.isOpen = false
        } else {
            school.isOpen = true
        }
        //school[sender.tag] = dict
        
        self.studyTableView.reloadRows(at: [IndexPath(row: sender.tag, section: 1)], with: .automatic)
        DispatchQueue.main.async {
            self.studyTableView.scrollToRow(at: IndexPath(row: sender.tag, section: 1), at: .bottom, animated: true)
            
        }
    }
    
    func textFieldDidChange(textfield:UITextField) {
        if (textfield.text?.isEmpty)! {
            chooseArticleDropDown.hide()

        } else {
            var temp = [String]()
            for i in schoolCategories[0].universities {
                temp.append(i.universityName)
            }
            chooseArticleDropDown.dataSource = temp
            chooseArticleDropDown.show()
            
        }

    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        chooseArticleDropDown.direction = .bottom
        chooseArticleDropDown.bottomOffset = CGPoint(x: 20, y: textField.bounds.height)
        chooseArticleDropDown.anchorView = textField

        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
    }
    
}

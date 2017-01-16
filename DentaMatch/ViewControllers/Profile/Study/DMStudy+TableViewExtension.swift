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
            cell.schoolNameTextField.tag = Int(school.schoolCategoryId)!
            
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
    
    func textFieldDidChange(textField:UITextField) {
        if textField.text!.isEmpty {
            hideAutoCompleteView()
        } else {
            let schoolId = "\(textField.tag)"
            
            var universities = self.schoolCategories.filter({$0.schoolCategoryId == schoolId}).first?.universities
            
            universities = universities?.filter({$0.universityName.range(of: textField.text!, options: .caseInsensitive, range: Range(uncheckedBounds: ($0.universityName.startIndex,$0.universityName.endIndex)), locale: nil) != nil })
            
            if let universities = universities {
                autoCompleteTable.updateData(schoolCategoryId: schoolId, universities: universities)
            }
            
            let point = textField.superview?.convert(textField.center, to: self.view)
            let frame = textField.frame
            autoCompleteTable.frame = CGRect(x: frame.origin.x, y: (point?.y)! + 25, width: frame.width, height: 200)
            
            autoCompleteBackView.isHidden = false
            autoCompleteTable.isHidden = false
        }
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        hideAutoCompleteView()
        return true
    }
    
}

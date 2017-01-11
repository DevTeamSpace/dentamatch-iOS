//
//  DMWorkExperienceStart+TableViewExtension.swift
//  DentaMatch
//
//  Created by Sanjay Kumar Yadav on 04/01/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import Foundation
import UIKit

extension DMWorkExperienceStart
{
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
//        if section == 0
//        {
//            return 1
//        }else{
//            return 3
//        }
    }
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
//    {
//        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 45))
//        let headerLabel = UILabel(frame: headerView.frame)
//        headerLabel.frame.origin.x = 20
//        headerLabel.backgroundColor = UIColor.clear
//        headerLabel.font = UIFont.fontMedium(fontSize: 14)
//        headerView.addSubview(headerLabel)
//        headerView.backgroundColor = UIColor(red: 248.0/255.0, green: 248.0/255.0, blue: 248.0/255.0, alpha: 1.0)
//        if section == 0
//        {
//            headerLabel.text = ""
//        }else{
//            headerLabel.text = "Work Experience"
//        }
//        
//        return headerView
//    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch indexPath.row {
        case 0:
            return 213
        case 1:
            return 45
        case 2,3,4:
            return 75
        default:
            return 0
        }
        
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        if section == 0
        {
            return 0
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        switch indexPath.row {
        case 0:
            //PhotoNameCell
            let cell = tableView.dequeueReusableCell(withIdentifier: "PhotoNameCell") as! PhotoNameCell
            cell.nameLabel.text = "Where do you work?"
            cell.jobTitleLabel.text = "Relevant work experience strengthens your profile"
            cell.photoButton.progressBar.setProgress(profileProgress, animated: true)

            cell.selectionStyle = .none
            
            return cell

        case 1:
            //PhotoNameCell
            let cell = tableView.dequeueReusableCell(withIdentifier: "SectionHeadingTableCell") as! SectionHeadingTableCell
            cell.selectionStyle = .none
            cell.headingLabel.text = "Work Experience"
            
            return cell

        case 2,3,4:
            let cell = tableView.dequeueReusableCell(withIdentifier: "AnimatedPHTableCell") as! AnimatedPHTableCell
            cell.selectionStyle = .none
//            cell.commonTextFiled.text = self.experienceArray[indexPath.row-2] as? String
            switch indexPath.row {
            case 2:
                cell.commonTextFiled.placeholder = FieldType.CurrentJobTitle.description
                
                let pickerView = JobSelectionPickerView.loadJobSelectionView(withJobTitles: jobTitles)
                cell.commonTextFiled.inputView = pickerView
                pickerView.delegate = self
                cell.commonTextFiled.tag = 0
                pickerView.pickerView.reloadAllComponents()
                pickerView.backgroundColor = UIColor.white
                
            case 3:
                cell.commonTextFiled.placeholder = FieldType.YearOfExperience.description
                let yearViewObj = ExperiencePickerView.loadExperiencePickerView(withText: self.experienceArray[indexPath.row-2] as! String)
                yearViewObj.delegate = self
                cell.commonTextFiled.tag = 1
                cell.commonTextFiled.inputView = yearViewObj
            case 4:
                cell.commonTextFiled.placeholder = FieldType.OfficeName.description
                cell.commonTextFiled.tag = 2
            default:
                print("default")
            }
            
            cell.commonTextFiled.text = self.experienceArray[indexPath.row - 2] as? String
            cell.commonTextFiled.delegate = self
            return cell

        default: break
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
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField.tag {
//        case 0:
//            self.experienceArray.replaceObject(at: 0, with: textField.text!)
        case 2:
            self.experienceArray.replaceObject(at: 2, with: textField.text!)
        default:
            print("default")
            
        }

    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard string.characters.count > 0 else {
            return true
        }
        if (textField.text?.characters.count)! >= Constants.TextFieldMaxLenght.commonMaxLenght {
            return false
        }

        return true
        
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func doneButtonAction(year: Int, month: Int) {
        self.view.endEditing(true)
        
        var text:String = ""
        
        if year <= 1 {
            if year != 0 {
                text.append("\(year) year")
            }
        }else{
            text.append("\(year) years")
        }
        
        if month <= 1 {
            if month != 0 {
                text.append(" \(month) month")
            }
        }else {
            text.append(" \(month) months")
        }

        self.experienceArray.replaceObject(at: 1, with: text)
        self.workExperienceTable.reloadData()
        
        
    }
    func canceButtonAction() {
        self.view.endEditing(true)

        
    }
    
    

    
}

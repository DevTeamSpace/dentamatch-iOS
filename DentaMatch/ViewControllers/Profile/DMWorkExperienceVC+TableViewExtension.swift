//
//  DMWorkExperienceVC+TableViewExtension.swift
//  DentaMatch
//
//  Created by Sanjay Kumar Yadav on 04/01/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import Foundation
import UIKit

extension DMWorkExperienceVC
{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return   1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.workExperienceDetailTable
        {
            return 6 + (self.currentExperience!.references.count)
        }else{
            return (self.exprienceArray?.count)!
        }
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
//        headerLabel.text = "Work Experiense"
//        return headerView
//    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == self.workExperienceDetailTable
        {
            if indexPath.row > (self.currentExperience?.references.count)! + 4
            {
                let height =  self.currentExperience?.isFirstExperience == true ? 60:121
                return CGFloat(height)
            }
            if indexPath.row > 4
            {
                let index = indexPath.row - 5
                let height = index == 0 ? ((self.currentExperience?.references.count)! > index ? 230 : 257): ((self.currentExperience?.references.count)!-1 > index ? 250 : 303)
                debugPrint("row height \(height)")
                return CGFloat(height)
            }
            return 65

        }else{
            return 44
        }
        
    }
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
//    {
//        if section == 0
//        {
//            return 0
//        }
//        return 45
//    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == self.workExperienceDetailTable
        {
            
            if indexPath.row > (self.currentExperience?.references.count)! + 4
            {
                let cell = tableView.dequeueReusableCell(withIdentifier: "AddDeleteExperienceCell") as! AddDeleteExperienceCell
                cell.selectionStyle = .none
                
                let tag = indexPath.row - 5 - (self.currentExperience?.references.count)!
                cell.addMoreExperienceButton.tag = tag
                cell.deleteButton.tag = tag
                
                if self.currentExperience?.isEditMode == true {
                    cell.addMoreExperienceButton.setTitle("Save", for: .normal)
                }else{
                    cell.addMoreExperienceButton.setTitle("AddMore Experience", for: .normal)

                }
                
                
                cell.deleteButton.addTarget(self, action: #selector(DMWorkExperienceVC.deleteExperience(_:)), for: .touchUpInside)
                cell.addMoreExperienceButton.addTarget(self, action: #selector(DMWorkExperienceVC.addMoreExperience(_:)), for: .touchUpInside)

                if self.currentExperience?.isFirstExperience == true
                {
                    cell.deleteButton.isHidden = true
                    cell.topSpaceOfAddMoreExperience.constant = 10
                }else{
                    cell.deleteButton.isHidden = false
                    cell.topSpaceOfAddMoreExperience.constant = 57
                }
                cell.layoutIfNeeded()
                return cell
            }
            
            if indexPath.row > 4
            {
                let cell = tableView.dequeueReusableCell(withIdentifier: "ReferenceTableCell") as! ReferenceTableCell
                cell.selectionStyle = .none
                
                cell.referenceNameLabel.delegate = self
                cell.referenceMobileNoLabel.delegate = self
                cell.referenceEmailLabel.delegate = self
                cell.referenceNameLabel.keyboardType = .default
                cell.referenceMobileNoLabel.keyboardType = .numberPad
                cell.referenceEmailLabel.keyboardType = .emailAddress
                cell.referenceNameLabel.placeholder = FieldType.ReferenceName.description
                cell.referenceMobileNoLabel.placeholder = FieldType.ReferenceMobileNo.description
                cell.referenceEmailLabel.placeholder = FieldType.ReferenceEmail.description
                
                let tag = indexPath.row - 5
                cell.referenceButtonFirst.tag = tag
                cell.referenceButtonSecond.tag = tag
                
                cell.referenceNameLabel.tag = tag
                cell.referenceMobileNoLabel.tag = tag
                cell.referenceEmailLabel.tag = tag

                cell.referenceNameLabel.addTarget(self, action: #selector(referenceNameTextFieldDidEnd(_:)), for: .editingDidEnd)
                cell.referenceMobileNoLabel.addTarget(self, action: #selector(referenceMobileNumberTextFieldDidEnd(_:)), for: .editingDidEnd)
                cell.referenceEmailLabel.addTarget(self, action: #selector(referenceEmailTextFieldDidEnd(_:)), for: .editingDidEnd)

                
                let empRef = self.currentExperience?.references[tag]
                
                
                cell.referenceNameLabel.text = empRef?.referenceName
                cell.referenceMobileNoLabel.text = empRef?.mobileNumber
                cell.referenceEmailLabel.text = empRef?.email

                cell.referenceMobileNoLabel.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
                cell.referenceButtonFirst.addTarget(self, action: #selector(DMWorkExperienceVC.deleteReference(_:)), for: .touchUpInside)
                cell.referenceButtonSecond.addTarget(self, action: #selector(DMWorkExperienceVC.addMoreReference(_:)), for: .touchUpInside)
                if tag == 0 {
                    if (self.currentExperience?.references.count)! - 1 > tag {
                        cell.referenceButtonSecond.isHidden = true
                    }else
                    {
                        cell.referenceButtonSecond.isHidden = false

                    }
                    cell.referenceButtonFirst.isHidden = true
                    cell.addMoreButtonTopSpace.constant = 0
                    
                }else{
                    if (self.currentExperience?.references.count)! - 1 > tag {
                        cell.referenceButtonFirst.isHidden = false
                        cell.addMoreButtonTopSpace.constant = 0
                        cell.referenceButtonSecond.isHidden = true
                        
                    }else
                    {
                        cell.referenceButtonFirst.isHidden = false
                        cell.addMoreButtonTopSpace.constant = 55
                        cell.referenceButtonSecond.isHidden = false
                    }

                }

                cell.layoutIfNeeded()

                
                
                return cell
                
            }else{
                let cell = tableView.dequeueReusableCell(withIdentifier: "AnimatedPHTableCell") as! AnimatedPHTableCell
                cell.selectionStyle = .none
                
                cell.cellTopSpace.constant = 10
                cell.cellBottomSpace.constant = 10.5
                cell.commonTextFiled.delegate = self
                cell.commonTextFiled.tag = indexPath.row
                
                
                cell.commonTextFiled.addTarget(self, action: #selector(CommonExperiencelTextFieldDidEnd(_:)), for: .editingDidEnd)

                //CommonExperiencelTextFieldDidEnd
                switch indexPath.row {
                case 0:
                    cell.commonTextFiled.placeholder = FieldType.CurrentJobTitle.description
                    cell.commonTextFiled.text = self.currentExperience?.jobTitle

                case 1:
                    cell.commonTextFiled.placeholder = FieldType.YearOfExperience.description
                    cell.commonTextFiled.text = self.currentExperience?.yearOfExperience!

                    let yearViewObj = DMYearExperiencePickerView.loadExperiencePickerView(withText: (self.currentExperience?.yearOfExperience!)!)
                    yearViewObj.delegate = self
                    cell.commonTextFiled.inputAccessoryView = yearViewObj
                    
                case 2:
                    cell.commonTextFiled.placeholder = FieldType.OfficeName.description
                    cell.commonTextFiled.text = self.currentExperience?.officeName

                case 3:
                    cell.commonTextFiled.placeholder = FieldType.OfficeAddress.description
                    cell.commonTextFiled.text = self.currentExperience?.officeAddress

                case 4:
                    cell.commonTextFiled.placeholder = FieldType.CityName.description
                    cell.commonTextFiled.text = self.currentExperience?.cityName

                default:
                    print("default")
                    
                }
                
                return cell
                
                
            }

            
        }else{
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "ExperienceTableCell") as! ExperienceTableCell
            cell.selectionStyle = .none
            let exp  = self.exprienceArray?[indexPath.row] as! ExperienceModel

            cell.experienceLabel.text = exp.yearOfExperience
            cell.jobTitleLable.text = exp.jobTitle
            
            //ExperienceTableCell
           return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView == self.workExperienceTable {
            self.currentExperience = nil
            self.currentExperience = self.exprienceArray?[indexPath.row] as? ExperienceModel
            self.currentExperience?.isEditMode = true
            self.workExperienceDetailTable.reloadData()
            self.reSizeTableViewsAndScrollView()
        }
    }
    
    func referenceNameTextFieldDidEnd(_ textField: UITextField) {
        let tag  =  textField.tag
        let empRef =  self.currentExperience?.references[tag]
        empRef?.referenceName = textField.text
        self.currentExperience?.references[tag] = empRef!
        self.workExperienceDetailTable.reloadData()

    }
    func referenceMobileNumberTextFieldDidEnd(_ textField: UITextField) {
        let tag  =  textField.tag
        let empRef =  self.currentExperience?.references[tag]
        empRef?.mobileNumber = textField.text
        self.currentExperience?.references[tag] = empRef!
        self.workExperienceDetailTable.reloadData()

    }
    func referenceEmailTextFieldDidEnd(_ textField: UITextField) {
        let tag  =  textField.tag
        let empRef =  self.currentExperience?.references[tag]
        empRef?.email = textField.text
        self.currentExperience?.references[tag] = empRef!
        self.workExperienceDetailTable.reloadData()
    }

    func textFieldDidChange(_ textField: UITextField) {
        textField.text = self.phoneFormatter.format(textField.text!, hash: textField.hash)

        
//            if ((textField.text?.characters.count)! <= 13) {
//                if (textField.text?.characters.count==3) {
//                    
//                    let tempStr = "(\(textField.text!))-"
//                    textField.text = tempStr
//                } else if (textField.text?.characters.count==8) {
//                    let tempStr = "\(textField.text!)-"
//                    textField.text = tempStr
//                }
//            }else{
//                var tempStr = textField.text!
//                tempStr = tempStr.dropLast(1)
//                textField.text = tempStr
//        }

    }
    
    func CommonExperiencelTextFieldDidEnd(_ textField: UITextField) {
        
        switch textField.tag {
        case 0:
            self.currentExperience?.jobTitle = textField.text
        case 2:
            self.currentExperience?.officeName = textField.text
        case 3:
            self.currentExperience?.officeAddress = textField.text
        case 4:
            self.currentExperience?.cityName = textField.text

        default:
            print("default")
        }
        
    }
    
    
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()

        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
    }
    
    
    func doneButtonAction(year: Int, month: Int) {
        self.workExperienceTable.endEditing(true)
        
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
        
        self.currentExperience?.yearOfExperience = text
        self.workExperienceDetailTable.reloadData()
        
    }
    func canceButtonAction() {
        self.workExperienceDetailTable.endEditing(true)
    }
    
    func addMoreReference(_ sender: Any) {
        let refere = EmployeeReferenceModel()
        self.currentExperience?.references.append(refere)
        self.workExperienceDetailTable.reloadData()
        self.reSizeTableViewsAndScrollView()
    }
    func addMoreExperience(_ sender: Any) {
        self.view.endEditing(true)
        if !checkValidations()
        {
            return
        }
        if self.currentExperience?.isEditMode == true
        {
            self.exprienceArray?.replaceObject(at: (sender as AnyObject).tag, with: self.currentExperience!)
        }else {
            self.exprienceArray?.add(self.currentExperience!)
        }
        self.currentExperience = nil
        self.currentExperience = ExperienceModel()
        self.currentExperience?.references.append(EmployeeReferenceModel())
        self.workExperienceTable.reloadData()
        self.workExperienceDetailTable.reloadData()
        self.reSizeTableViewsAndScrollView()
    }
    func deleteReference(_ sender: Any) {
        self.view.endEditing(true)
        let tag = (sender as AnyObject).tag
        self.currentExperience?.references.remove(at: tag!)
        self.workExperienceDetailTable.reloadData()
        self.reSizeTableViewsAndScrollView()
    }
    func deleteExperience(_ sender: Any) {
        
    }
    
    func checkValidations() -> Bool  {
        
        if (self.currentExperience?.jobTitle?.trimmingCharacters(in: CharacterSet.whitespaces).isEmpty)! {
            self.makeToast(toastString:Constants.AlertMessage.jobTitle )
            return false
        }else if  (self.currentExperience?.yearOfExperience?.trimmingCharacters(in: CharacterSet.whitespaces).isEmpty)! {
            self.makeToast(toastString: Constants.AlertMessage.yearOfExperience)
            return false
        }else if  (self.currentExperience?.officeName?.trimmingCharacters(in: CharacterSet.whitespaces).isEmpty)! {
            self.makeToast(toastString: Constants.AlertMessage.officeName)
            return false
        }else if  (self.currentExperience?.officeAddress?.trimmingCharacters(in: CharacterSet.whitespaces).isEmpty)! {
            self.makeToast(toastString: Constants.AlertMessage.officeAddress)
            return false
        }else if  (self.currentExperience?.cityName?.trimmingCharacters(in: CharacterSet.whitespaces).isEmpty)! {
            self.makeToast(toastString: Constants.AlertMessage.CityName)
            return false
        }
        
//        for empRef in (self.currentExperience?.references)! {
//            if empRef.referenceName?.characters.count == 0 {
//                
//            }else if !(empRef.email?.isValidEmail)! {
//                
//            }else if self.phoneFormatter.isValid(empRef.mobileNumber!) {
//                
//            }
//            
//        }
        
        return true
    }

    
    
}

extension String {
    public func toPhoneNumber() -> String {
        return self.replacingOccurrences(of: "(\\d{3})(\\d{3})(\\d+)", with: "($1) $2-$3", options: .regularExpression, range: nil)
    }
}


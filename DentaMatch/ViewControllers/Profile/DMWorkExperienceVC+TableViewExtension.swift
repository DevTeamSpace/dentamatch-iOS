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
            return 6 + (self.currentExperience.references.count)
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
            if indexPath.row > (self.currentExperience.references.count) + 4
            {
                let height =  self.currentExperience.isFirstExperience == true ? 60:121
                return CGFloat(height)
            }
            if indexPath.row > 4
            {
                let index = indexPath.row - 5
                let height = index == 0 ? (self.currentExperience.references.count > index ? 230 : 257): (self.currentExperience.references.count-1 > index ? 250 : 303)
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
            
            if indexPath.row > (self.currentExperience.references.count) + 4
            {
                let cell = tableView.dequeueReusableCell(withIdentifier: "AddDeleteExperienceCell") as! AddDeleteExperienceCell
                cell.selectionStyle = .none
                
                let tag = indexPath.row - 6
                cell.addMoreExperienceButton.tag = tag
                cell.deleteButton.tag = tag
                
                
                cell.deleteButton.addTarget(self, action: #selector(DMWorkExperienceVC.deleteExperience(_:)), for: .touchUpInside)
                cell.addMoreExperienceButton.addTarget(self, action: #selector(DMWorkExperienceVC.addMoreExperience(_:)), for: .touchUpInside)

                if self.currentExperience.isFirstExperience == true
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
                
                cell.referenceMobileNoLabel.addTarget(self, action: #selector(textFieldDidChange), for: .allEditingEvents)
                
                cell.referenceNameLabel.keyboardType = .default
                cell.referenceMobileNoLabel.keyboardType = .numberPad
                cell.referenceEmailLabel.keyboardType = .emailAddress

                cell.referenceNameLabel.placeholder = FieldType.ReferenceName.description
                cell.referenceMobileNoLabel.placeholder = FieldType.ReferenceMobileNo.description
                cell.referenceEmailLabel.placeholder = FieldType.ReferenceEmail.description
                
                let tag = indexPath.row - 5
                cell.referenceButtonFirst.tag = tag
                cell.referenceButtonSecond.tag = tag
                

                cell.referenceButtonFirst.addTarget(self, action: #selector(DMWorkExperienceVC.deleteReference(_:)), for: .touchUpInside)
                cell.referenceButtonSecond.addTarget(self, action: #selector(DMWorkExperienceVC.addMoreReference(_:)), for: .touchUpInside)
                if tag == 0
                {
                    if self.currentExperience.references.count - 1 > tag
                    {
                        cell.referenceButtonSecond.isHidden = true
                    }else
                    {
                        cell.referenceButtonSecond.isHidden = false

                    }
                    cell.referenceButtonFirst.isHidden = true
                    cell.addMoreButtonTopSpace.constant = 0

                    
                }else{
                    
                    if self.currentExperience.references.count - 1 > tag
                    {
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
                switch indexPath.row {
                case 0:
                    cell.commonTextFiled.placeholder = FieldType.CurrentJobTitle.description
                case 1:
                    cell.commonTextFiled.placeholder = FieldType.YearOfExperience.description
//                    let yearViewObj = DMYearExperiencePickerView.loadExperiencePickerView(withText: self.exprienceArray![indexPath.row] as! String)
//                    yearViewObj.delegate = self
//                    cell.commonTextFiled.inputAccessoryView = yearViewObj
                    
                case 2:
                    cell.commonTextFiled.placeholder = FieldType.OfficeName.description
                case 3:
                    cell.commonTextFiled.placeholder = FieldType.OfficeAddress.description
                case 4:
                    cell.commonTextFiled.placeholder = FieldType.CityName.description
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
    
    
    func textFieldDidChange(_ textField: UITextField) {
        
            if ((textField.text?.characters.count)! <= 13) {
                if (textField.text?.characters.count==3) {
                    
                    let tempStr = "(\(textField.text!))-"
                    textField.text = tempStr
                } else if (textField.text?.characters.count==8) {
                    let tempStr = "\(textField.text!)-"
                    textField.text = tempStr
                }
            }else{
                var tempStr = textField.text!
                tempStr = tempStr.dropLast(1)
                textField.text = tempStr
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
        
        if year <= 1
        {
            text.append("\(year) year")
        }else{
            text.append("\(year) years")
            
        }
        
        if month <= 1
        {
            text.append(" \(month) month")
        }else{
            text.append(" \(month) months")
            
        }
        
        self.exprienceArray?.replaceObject(at: 1, with: text)
        self.workExperienceTable.reloadData()
        
    }
    func canceButtonAction() {
        self.workExperienceTable.endEditing(true)
        
        
    }
    
    func addMoreReference(_ sender: Any) {
        let refere = EmployeeReferenceModel()
        self.currentExperience.references.append(refere)
        self.workExperienceDetailTable.reloadData()
        self.reSizeTableViewsAndScrollView()

    }
    func addMoreExperience(_ sender: Any)
    {
        
        
    }
    func deleteReference(_ sender: Any)
    {
        let tag = (sender as AnyObject).tag
        self.currentExperience.references.remove(at: tag!)
        self.workExperienceDetailTable.reloadData()
        self.reSizeTableViewsAndScrollView()
        
    }
    func deleteExperience(_ sender: Any)
    {
        
    }
    
    
    
    
    
    
    
    
    
    

    
}

extension String {
    public func toPhoneNumber() -> String {
        return self.replacingOccurrences(of: "(\\d{3})(\\d{3})(\\d+)", with: "($1) $2-$3", options: .regularExpression, range: nil)
    }
}


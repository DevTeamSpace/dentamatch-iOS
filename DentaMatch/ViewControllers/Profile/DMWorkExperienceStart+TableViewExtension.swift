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
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0
        {
            return 1
        }else{
            return 3
        }
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 45))
        let headerLabel = UILabel(frame: headerView.frame)
        headerLabel.frame.origin.x = 20
        headerLabel.backgroundColor = UIColor.clear
        headerLabel.font = UIFont.fontMedium(fontSize: 14)
        headerView.addSubview(headerLabel)
        headerView.backgroundColor = UIColor(red: 248.0/255.0, green: 248.0/255.0, blue: 248.0/255.0, alpha: 1.0)
        if section == 0
        {
            headerLabel.text = ""
        }else{
            headerLabel.text = "Work Experience"
        }
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section == 0
        {
            return 226
            
        }else {
            return 75
            
        }
        
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        if section == 0
        {
            return 0
        }
        return 45
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if  indexPath.section == 0 {
            
            //PhotoNameCell
            let cell = tableView.dequeueReusableCell(withIdentifier: "PhotoNameCell") as! PhotoNameCell
            cell.selectionStyle = .none
            
            return cell

            
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "AnimatedPHTableCell") as! AnimatedPHTableCell
            cell.selectionStyle = .none
            cell.commonTextFiled.tag = indexPath.row
            switch indexPath.row {
            case 0:
                cell.commonTextFiled.placeholder = FieldType.CurrentJobTitle.description
            case 1:
                cell.commonTextFiled.placeholder = FieldType.YearOfExperience.description
                let yearViewObj = DMYearExperiencePickerView.loadExperiencePickerView(withText: self.experienceArray[indexPath.row] as! String)
                yearViewObj.delegate = self
                cell.commonTextFiled.inputView = yearViewObj
                
            case 2:
                cell.commonTextFiled.placeholder = FieldType.OfficeName.description
            case 3:
                cell.commonTextFiled.placeholder = FieldType.OfficeAddress.description
            case 4:
                cell.commonTextFiled.placeholder = FieldType.CityName.description
            default:
                print("default")
            }

            cell.commonTextFiled.text = self.experienceArray[indexPath.row] as? String
            cell.commonTextFiled.delegate = self
            return cell

        }
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
        case 0:
            self.experienceArray.replaceObject(at: 0, with: textField.text!)
        case 2:
            self.experienceArray.replaceObject(at: 2, with: textField.text!)
        default:
            print("default")
            
        }

    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
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

        self.experienceArray.replaceObject(at: 1, with: text)
        self.workExperienceTable.reloadData()
        
        
    }
    func canceButtonAction() {
        self.workExperienceTable.endEditing(true)

        
    }
    
    

    
}

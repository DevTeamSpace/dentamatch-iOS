//
//  DMWorkExperienceVC+TableViewExtension.swift
//  DentaMatch
//
//  Created by Sanjay Kumar Yadav on 04/01/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import Foundation
import UIKit

extension DMWorkExperienceVC: UITableViewDataSource,UITableViewDelegate
{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return   1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.workExperienceDetailTable
        {
            return 6 + self.currentExperience!.references.count
        }else{
            return self.exprienceArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == self.workExperienceDetailTable
        {
             return getHeightForworkExperienceDetailTable(indexPath: indexPath)
        }else{
            return 44
        }
        
    }
    
    func getHeightForworkExperienceDetailTable(indexPath: IndexPath)  -> CGFloat{
        
        if indexPath.row > (self.currentExperience?.references.count)! + 4
        {
            let height =  self.currentExperience?.isFirstExperience == true ? 80:130
            return CGFloat(height)
        }
        if indexPath.row > 4
        {
            let index = indexPath.row - 5
            var height = index == 0 ? ((self.currentExperience?.references.count)! > index ? 230 : 257): ((self.currentExperience?.references.count)!-1 > index ? 260 : 303)
            if (self.currentExperience?.references.count)! == 1 {
                height = 250 // if single experience is added add more experience button should be clickable
            }
            debugPrint("row height \(height)")
            return CGFloat(height)
        }
        if indexPath.row == 0 {
            return 95
        }
        return 75
        

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == self.workExperienceDetailTable
        {
            
            if indexPath.row > (self.currentExperience?.references.count)! + 4
            {
                let cell = tableView.dequeueReusableCell(withIdentifier: "AddDeleteExperienceCell") as! AddDeleteExperienceCell
                cell.selectionStyle = .none
                self.updateCellForAddDeleteExperienceCell(cell: cell, indexPth:indexPath)
                
                return cell
            }
            
            if indexPath.row > 4
            {
                let cell = tableView.dequeueReusableCell(withIdentifier: "ReferenceTableCell") as! ReferenceTableCell
                let tag = indexPath.row - 5
                cell.selectionStyle = .none
                cell.nameTextField.delegate = self
                cell.mobileNoTextField.delegate = self
                cell.emailTextField.delegate = self
                let empRef = self.currentExperience?.references[tag]
                cell.updateCell(empRef: empRef, tag: tag)
                cell.nameTextField.addTarget(self, action: #selector(referenceNameTextFieldDidEnd(_:)), for: .editingDidEnd)
                cell.nameTextField.autocapitalizationType = .sentences
                cell.mobileNoTextField.addTarget(self, action: #selector(referenceMobileNumberTextFieldDidEnd(_:)), for: .editingDidEnd)
                cell.emailTextField.addTarget(self, action: #selector(referenceEmailTextFieldDidEnd(_:)), for: .editingDidEnd)

                cell.mobileNoTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
                cell.deleteButton.addTarget(self, action: #selector(DMWorkExperienceVC.deleteReference(_:)), for: .touchUpInside)
                cell.addMoreReferenceButton.addTarget(self, action: #selector(DMWorkExperienceVC.addMoreReference(_:)), for: .touchUpInside)
                if tag == 0 {
                    if (self.currentExperience?.references.count)! - 1 > tag {
                        cell.addMoreReferenceButton.isHidden = true
                    }else
                    {
                        cell.addMoreReferenceButton.isHidden = false
                    }
                    cell.deleteButton.isHidden = true
                    cell.addMoreButtonTopSpace.constant = 10
                    
                }else{
                    if (self.currentExperience?.references.count)! - 1 > tag {
                        cell.deleteButton.isHidden = false
                        cell.addMoreButtonTopSpace.constant = 10
                        cell.addMoreReferenceButton.isHidden = true
                    }else
                    {
                        cell.deleteButton.isHidden = false
                        cell.addMoreButtonTopSpace.constant = 55
                        cell.addMoreReferenceButton.isHidden = false
                    }

                }

//                cell.addMoreReferenceButton.contentEdgeInsets = UIEdgeInsetsMake(-10, 15, -20, 0);
                cell.addMoreReferenceButton.layoutIfNeeded()
                cell.layoutIfNeeded()
                return cell
                
            }else{
                let cell = tableView.dequeueReusableCell(withIdentifier: "AnimatedPHTableCell") as! AnimatedPHTableCell
                cell.selectionStyle = .none

                updateCellForAnimatedPHTableCell(cell: cell, indexPath: indexPath)
                
                return cell
            }

            
        }else{
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "ExperienceTableCell") as! ExperienceTableCell
            cell.selectionStyle = .none
            let exp  = self.exprienceArray[indexPath.row] 

            cell.experienceLabel.text = exp.yearOfExperience
            cell.jobTitleLable.text = exp.jobTitle
            
            //ExperienceTableCell
           return cell
        }
        
    }
    
    func updateCellForAddDeleteExperienceCell(cell:AddDeleteExperienceCell , indexPth : IndexPath) {
        let tag = indexPth.row - 5 - (self.currentExperience?.references.count)!
        cell.addMoreExperienceButton.tag = tag
        cell.deleteButton.tag = tag
        
        if self.currentExperience?.isEditMode == true {
            cell.addMoreExperienceButton.setTitle(" Save", for: .normal)
        }else{
            cell.addMoreExperienceButton.setTitle(" Add More Experience", for: .normal)
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

        
    }
    func updateCellForAnimatedPHTableCell(cell : AnimatedPHTableCell , indexPath: IndexPath) {
        
        if indexPath.row == 0 {
            cell.cellTopSpace.constant = 30
        }else{
            cell.cellTopSpace.constant = 10
            
        }
        cell.cellBottomSpace.constant = 10.5
        cell.commonTextField.delegate = self
        cell.commonTextField.tag = indexPath.row
        
        cell.commonTextField.addTarget(self, action: #selector(CommonExperiencelTextFieldDidEnd(_:)), for: .editingDidEnd)

        switch indexPath.row {
        case 0:
            cellConfigureForJobSelection(cell: cell, indexPath: indexPath)
        case 1:
            cellConfigureForExperience(cell: cell, indexPath: indexPath)
        case 2:
            cell.commonTextField.placeholder = FieldType.OfficeName.description
            cell.commonTextField.text = self.currentExperience?.officeName
            cell.commonTextField.autocapitalizationType = .sentences
            
        case 3:
            cell.commonTextField.placeholder = FieldType.OfficeAddress.description
            cell.commonTextField.text = self.currentExperience?.officeAddress
            cell.commonTextField.autocapitalizationType = .sentences
            
        case 4:
            cell.commonTextField.placeholder = FieldType.CityName.description
            cell.commonTextField.text = self.currentExperience?.cityName
            cell.commonTextField.autocapitalizationType = .sentences
            
        default:
            debugPrint("default")
            
        }

    }
    
    
    
    func cellConfigureForJobSelection(cell:AnimatedPHTableCell, indexPath:IndexPath) {
        
        cell.commonTextField.placeholder = FieldType.CurrentJobTitle.description
        //Right View for drop down
        let rightView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: cell.commonTextField.frame.size.height))
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 40, height: cell.commonTextField.frame.size.height))
        label.font = UIFont.designFont(fontSize: 16.0)
        label.text = "c"
        label.textColor = UIColor.color(withHexCode: "a0a0a0")
        label.textAlignment = .center
        label.center = rightView.center
        rightView.addSubview(label)
        cell.commonTextField.rightView = rightView
        cell.commonTextField.rightViewMode = .always
        cell.commonTextField.rightView?.isUserInteractionEnabled = false

        cell.commonTextField.text = self.currentExperience?.jobTitle
        let pickerView = JobSelectionPickerView.loadJobSelectionView(withJobTitles: jobTitles)
        cell.commonTextField.type = 1
        cell.commonTextField.tintColor = UIColor.clear
        cell.commonTextField.inputView = pickerView
        pickerView.delegate = self
        pickerView.pickerView.reloadAllComponents()
        pickerView.backgroundColor = UIColor.white
        
    }
    func cellConfigureForExperience(cell:AnimatedPHTableCell, indexPath:IndexPath) {
        cell.commonTextField.placeholder = FieldType.YearOfExperience.description
        cell.commonTextField.text = self.currentExperience?.yearOfExperience!
        let yearViewObj = ExperiencePickerView.loadExperiencePickerView(withText: (self.currentExperience?.yearOfExperience!)!)
        yearViewObj.delegate = self
        cell.commonTextField.type = 1
        cell.commonTextField.tintColor = UIColor.clear
        cell.commonTextField.inputView = yearViewObj
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView == self.workExperienceTable {
            self.isHiddenExperienceTable = true
            selectedIndex = indexPath.row
//            let check  = indexPath.row == 0 ? true : false
            self.currentExperience = nil
            self.currentExperience = self.exprienceArray[indexPath.row]
            self.currentExperience?.isFirstExperience = false
            self.currentExperience?.isEditMode = true
            self.workExperienceTable.reloadData()
            self.workExperienceDetailTable.reloadData()
            self.reSizeTableViewsAndScrollView()
        }
    }
    
    @objc func referenceNameTextFieldDidEnd(_ textField: UITextField) {
        let tag  =  textField.tag
        let empRef =  self.currentExperience?.references[tag]
        empRef?.referenceName = textField.text
        self.currentExperience?.references[tag] = empRef!

    }
    @objc func referenceMobileNumberTextFieldDidEnd(_ textField: UITextField) {
        let tag  =  textField.tag
        let empRef =  self.currentExperience?.references[tag]
        empRef?.mobileNumber = textField.text
        self.currentExperience?.references[tag] = empRef!

    }
    @objc func referenceEmailTextFieldDidEnd(_ textField: UITextField) {
        let tag  =  textField.tag
        let empRef =  self.currentExperience?.references[tag]
        empRef?.email = textField.text
        self.currentExperience?.references[tag] = empRef!
    }

    @objc func textFieldDidChange(_ textField: UITextField) {
        textField.text = self.phoneFormatter.format(textField.text!, hash: textField.hash)
    }
    
    @objc func CommonExperiencelTextFieldDidEnd(_ textField: UITextField) {
        
        switch textField.tag {
//        case 0:
//            self.currentExperience?.jobTitle = textField.text
        case 2:
            self.currentExperience?.officeName = textField.text
        case 3:
            self.currentExperience?.officeAddress = textField.text
        case 4:
            self.currentExperience?.cityName = textField.text

        default:
            debugPrint("default")
        }
        
    }
    
    
    func toolBarButtonPressed(position: Position) {
        self.view.endEditing(true)
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
        let total = (year * 12) + month
        
        self.currentExperience?.yearOfExperience = text
        self.currentExperience?.experienceInMonth = total
        self.workExperienceDetailTable.reloadData()
    }
    func canceButtonAction() {
        self.workExperienceDetailTable.endEditing(true)
    }
    
    @objc func addMoreReference(_ sender: Any) {
        if (self.currentExperience?.references.count)! < 2
        {
            if (self.currentExperience?.references[0].referenceName?.isEmptyField)! && (self.currentExperience?.references[0].mobileNumber?.isEmptyField)! && (self.currentExperience?.references[0].email?.isEmptyField)! {
                self.makeToast(toastString: Constants.AlertMessage.empptyFirstReference)
                
            }else{
                let refere = EmployeeReferenceModel(empty: "")
                self.currentExperience?.references.append(refere)
                self.workExperienceDetailTable.reloadData()
                self.reSizeTableViewsAndScrollView()
                
            }
 
        }else{
            self.makeToast(toastString: Constants.AlertMessage.morethen2refernce)
        }
    }
    @objc func addMoreExperience(_ sender: Any) {
        self.view.endEditing(true)
        if !checkValidations()
        {
            return
        }
        var param = [String:AnyObject]()
        var isEdit = false
        
        if self.currentExperience?.isEditMode == true {
            isEdit = true
        }
        param = self.getParamsForSaveAndUpdate(isEdit:isEdit)
        
        saveUpdateExperience(params: param, completionHandler: { (response, error) in
            
            if response![Constants.ServerKey.status].boolValue {
                let resultArray = response![Constants.ServerKey.result][Constants.ServerKey.list].array
                if (resultArray?.count)! > 0
                {
                    let dict  = resultArray?[0].dictionary
                    self.currentExperience?.experienceID = (dict?[Constants.ServerKey.experienceId]?.intValue)!
                }
                if self.currentExperience?.isEditMode == true {
                    self.exprienceArray[self.selectedIndex] = self.currentExperience!

                }else{
                    self.exprienceArray.append(self.currentExperience!)
                }
                self.isHiddenExperienceTable = false
                self.currentExperience = nil
                self.currentExperience = ExperienceModel(empty: "")
                self.currentExperience?.isFirstExperience = false
                self.currentExperience?.references.append(EmployeeReferenceModel(empty: ""))
                self.workExperienceTable.reloadData()
                self.workExperienceDetailTable.reloadData()
                self.reSizeTableViewsAndScrollView()
                self.updateProfileScreen()

            }
        })
        self.workExperienceTable.reloadData()
        self.workExperienceDetailTable.reloadData()
//        self.makeToast(toastString: "Experience Added")
        self.reSizeTableViewsAndScrollView()
    }
    @objc func deleteReference(_ sender: Any) {
        self.view.endEditing(true)
        let tag = (sender as AnyObject).tag
        self.currentExperience?.references.remove(at: tag!)
        self.workExperienceTable.reloadData()
        self.workExperienceDetailTable.reloadData()
        self.reSizeTableViewsAndScrollView()
    }
    @objc func deleteExperience(_ sender: Any) {
        self.view.endEditing(true)

        if self.currentExperience?.isEditMode == true {
            self.deleteExperience(completionHandler: { (check, error) in
                if check == true{
                    self.exprienceArray.removeObject(object:self.currentExperience!)
                    self.currentExperience = nil
                    self.currentExperience = ExperienceModel(empty: "")
                    self.currentExperience?.isFirstExperience = false
                    self.currentExperience?.references.append(EmployeeReferenceModel(empty: ""))
                    self.isHiddenExperienceTable = false
                    self.workExperienceTable.reloadData()
                    self.workExperienceDetailTable.reloadData()
                    self.reSizeTableViewsAndScrollView()
                    self.updateProfileScreen()
                }
            })
        }else{
            self.currentExperience = nil
            self.currentExperience = ExperienceModel(empty: "")
            self.currentExperience?.isFirstExperience = false
            self.currentExperience?.references.append(EmployeeReferenceModel(empty: ""))
            self.isHiddenExperienceTable = false
            self.workExperienceTable.reloadData()
            self.workExperienceDetailTable.reloadData()
            self.reSizeTableViewsAndScrollView()
            self.updateProfileScreen()
        }

    }
    
    func checkValidations() -> Bool  {
        
        if (self.currentExperience?.jobTitle?.trimmingCharacters(in: CharacterSet.whitespaces).isEmpty)! {
            self.makeToast(toastString:Constants.AlertMessage.emptyCurrentJobTitle )
            return false
        }else if  (self.currentExperience?.yearOfExperience?.trimmingCharacters(in: CharacterSet.whitespaces).isEmpty)! {
            self.makeToast(toastString: Constants.AlertMessage.emptyYearOfExperience)
            return false
        }else if  (self.currentExperience?.officeName?.trimmingCharacters(in: CharacterSet.whitespaces).isEmpty)! {
            self.makeToast(toastString: Constants.AlertMessage.emptyOfficeName)
            return false
        }else if  (self.currentExperience?.officeAddress?.trimmingCharacters(in: CharacterSet.whitespaces).isEmpty)! {
            self.makeToast(toastString: Constants.AlertMessage.emptyOfficeAddress)
            return false
        }else if  (self.currentExperience?.cityName?.trimmingCharacters(in: CharacterSet.whitespaces).isEmpty)! {
            self.makeToast(toastString: Constants.AlertMessage.emptyCityName)
            return false
        }
        
        for index in 0..<(self.currentExperience?.references.count)!{
            let empRef = self.currentExperience?.references[index]
            
            if (empRef?.referenceName?.isEmptyField)! {
                
            }
            if !(empRef?.mobileNumber?.isEmptyField)!  {
                if !self.phoneFormatter.isValid((empRef?.mobileNumber!)!) {
                    self.makeToast(toastString: Constants.AlertMessage.referenceMobileNumber)
                    return false
                }
            }
            if !(empRef?.email?.isEmptyField)! {
                if !(empRef?.email?.isValidEmail)! {
                    self.makeToast(toastString: Constants.AlertMessage.invalidEmail)
                    return false
                }
            }
            
            if index == 1 {
                if (self.currentExperience?.references[0].referenceName?.isEmptyField)! && (self.currentExperience?.references[0].mobileNumber?.isEmptyField)! && (self.currentExperience?.references[0].email?.isEmptyField)! {
                    self.makeToast(toastString: Constants.AlertMessage.empptyFirstReference)
                    return false
                }
            }
        }
        
        return true
    }
    
    func checkAllFieldIsEmpty() -> Bool {
        if !(self.currentExperience?.jobTitle?.trimmingCharacters(in: CharacterSet.whitespaces).isEmpty)! {
            return false
        }
        if !(self.currentExperience?.yearOfExperience?.trimmingCharacters(in: CharacterSet.whitespaces).isEmpty)! {
            return false
        }
        if !(self.currentExperience?.officeName?.trimmingCharacters(in: CharacterSet.whitespaces).isEmpty)! {
            self.makeToast(toastString: Constants.AlertMessage.emptyOfficeName)
            return false
        }
        if !(self.currentExperience?.officeAddress?.trimmingCharacters(in: CharacterSet.whitespaces).isEmpty)! {
            return false
        }
        if !(self.currentExperience?.cityName?.trimmingCharacters(in: CharacterSet.whitespaces).isEmpty)! {
            return false
        }
        return true

    }
    
    func checkAllFieldsAreFilled() -> Bool {
        if (self.currentExperience?.jobTitle?.trimmingCharacters(in: CharacterSet.whitespaces).isEmpty)! {
            return false
        }
        if (self.currentExperience?.yearOfExperience?.trimmingCharacters(in: CharacterSet.whitespaces).isEmpty)! {
            return false
        }
        if (self.currentExperience?.officeName?.trimmingCharacters(in: CharacterSet.whitespaces).isEmpty)! {
            self.makeToast(toastString: Constants.AlertMessage.emptyOfficeName)
            return false
        }
        if (self.currentExperience?.officeAddress?.trimmingCharacters(in: CharacterSet.whitespaces).isEmpty)! {
            return false
        }
        if (self.currentExperience?.cityName?.trimmingCharacters(in: CharacterSet.whitespaces).isEmpty)! {
            return false
        }
        return true
        
    }

    
}
extension DMWorkExperienceVC :UITextFieldDelegate  {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard string.count > 0 else {
            return true
        }
        if (textField.text?.count)! >= Constants.Limit.commonMaxLimit {
            return false
        }
        return true
        
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
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        //        textField.resignFirstResponder()
    }

}
extension String {
    public func toPhoneNumber() -> String {
        return self.replacingOccurrences(of: "(\\d{3})(\\d{3})(\\d+)", with: "($1) $2-$3", options: .regularExpression, range: nil)
    }
}


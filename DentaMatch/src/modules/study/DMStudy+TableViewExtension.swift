//
//  DMStudy+TableViewExtension.swift
//  DentaMatch
//
//  Created by Rajan Maheshwari on 10/01/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import Foundation

extension DMStudyVC: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in _: UITableView) -> Int {
        return 2
    }
    
    func tableView(_: UITableView, numberOfRowsInSection section: Int) -> Int {
        let studyOption = Study(rawValue: section)!
        
        switch studyOption {
        case .profileHeader:
            return 2
        case .school:
            return schoolCategories.count
        }
    }
    
    func tableView(_: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let studyOption = Study(rawValue: indexPath.section)!
        
        switch studyOption {
        case .profileHeader:
            return getHeightForProfileHeader(indexPath: indexPath)
        case .school:
            let schoolCategory = schoolCategories[indexPath.row]
            if !schoolCategory.isOpen {
                return 60
            } else { return 202 }
        }
    }
    
    func getHeightForProfileHeader(indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            // Profile Header
            return 213
        case 1:
            // Heading
            return 44
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let studyOption = Study(rawValue: indexPath.section)!
        
        switch studyOption {
        case .profileHeader:
            return updateCellForProfileHeader(tableView: tableView, indexPath: indexPath)
            
        case .school:
            let cell = tableView.dequeueReusableCell(withIdentifier: "StudyCell") as! StudyCell
            updateCellForStudyCell(cell: cell, indexPath: indexPath)
            return cell
        }
    }
    
    func updateCellForProfileHeader(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "PhotoNameCell") as! PhotoNameCell
            cell.updateCellForPhotoNameCell(nametext: "Where did you Study?", jobTitleText: "Lorem Ipsum is simply dummy text for the typing and printing industry", profileProgress: profileProgress)
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SectionHeadingTableCell") as! SectionHeadingTableCell
            return cell
            
        default:
            return UITableViewCell()
        }
    }
    
    func updateCellForStudyCell(cell: StudyCell, indexPath: IndexPath) {
        let school = schoolCategories[indexPath.row]
        cell.headingButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        cell.schoolNameTextField.text = ""
        cell.yearOfGraduationTextField.text = ""
        
        cell.schoolNameTextField.delegate = self
        
        cell.schoolNameTextField.tag = Int(school.schoolCategoryId)!
        cell.yearOfGraduationTextField.tag = Int(school.schoolCategoryId)!
        cell.schoolNameTextField.returnKeyType = .done
        cell.yearOfGraduationTextField.inputView = yearPicker
        cell.yearOfGraduationTextField.delegate = self
        cell.yearOfGraduationTextField.tintColor = UIColor.clear
        cell.yearOfGraduationTextField.type = 1
        cell.yearOfGraduationTextField.returnKeyType = .done
        
        for dict in selectedData {
            if let selectedDict = dict as? NSDictionary, let parentId = selectedDict["parentId"] as? String {
                if parentId == "\(school.schoolCategoryId)" {
                    if let schoolName = selectedDict["other"] as? String {
                        cell.schoolNameTextField.text = schoolName
                    }
                    if let yearOfGraduation = selectedDict["yearOfGraduation"] as? String {
                        cell.yearOfGraduationTextField.text = yearOfGraduation
                    }
                }
            }
        }
        
        cell.schoolNameTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        cell.headingButton.tag = indexPath.row
        cell.headingButton.setTitle(school.schoolCategoryName, for: .normal)
    }
    
    @objc func buttonTapped(sender: UIButton) {
        let school = schoolCategories[sender.tag]
        if school.isOpen {
            school.isOpen = false
        } else {
            school.isOpen = true
        }
        // school[sender.tag] = dict
        
        studyTableView.reloadRows(at: [IndexPath(row: sender.tag, section: 1)], with: .automatic)
        DispatchQueue.main.async {
            self.studyTableView.scrollToRow(at: IndexPath(row: sender.tag, section: 1), at: .bottom, animated: true)
        }
    }
    
    func checkForEmptySchoolField() {
        let emptyData = NSMutableArray()
        for category in selectedData {
            if let dict = category as? NSMutableDictionary, (dict["other"] as? String ?? "").isEmptyField {
                emptyData.add(dict)
            }
        }
        selectedData.removeObjects(in: emptyData as [AnyObject])
        // debugPrint(selectedData)
        studyTableView.reloadData()
    }
}

extension DMStudyVC: UITextFieldDelegate {
    @objc func textFieldDidChange(textField: UITextField) {
        let schoolCategory = schoolCategories.filter({ $0.schoolCategoryId == "\(textField.tag)" }).first
        let university = schoolCategory?.universities.filter({ $0.universityName == textField.text })
        if (university?.count)! > 0 {
            // Its in the list
            // debugPrint("In the list")
        } else {
            // DO nothing
        }
        if textField.text!.isEmpty {
            hideAutoCompleteView()
        } else {
            let schoolId = "\(textField.tag)"
            var universities = schoolCategories.filter({ $0.schoolCategoryId == schoolId }).first?.universities
            universities = universities?.filter({ $0.universityName.range(of: textField.text!, options: .caseInsensitive, range: Range(uncheckedBounds: ($0.universityName.startIndex, $0.universityName.endIndex)), locale: nil) != nil })
            if let universities = universities {
                autoCompleteTable.updateData(schoolCategoryId: schoolId, universities: universities)
            }
            let point = textField.superview?.convert(textField.center, to: view)
            let frame = textField.frame
            autoCompleteTable.frame = CGRect(x: frame.origin.x, y: (point?.y)! + 25, width: frame.width, height: 200)
            autoCompleteBackView.isHidden = false
            autoCompleteTable.isHidden = false
        }
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        yearPicker?.getPreSelectedValues(dateString: "", curTag: textField.tag)
        
        return true
    }
    
    func textFieldDidBeginEditing(_: UITextField) {
        //textFieldDidBeginEditing
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        // debugPrint("textFieldDidEndEditing")
        let school = schoolCategories.filter({ $0.schoolCategoryId == "\(textField.tag)" }).first
        
        if textField.inputView is YearPickerView {
            // debugPrint("year picker")
        } else {
            if !isFilledFromAutoComplete {
                var flag = 0
                
                if selectedData.count == 0 {
                    let dict = NSMutableDictionary()
                    dict["parentId"] = "\(textField.tag)"
                    dict["schoolId"] = "\(textField.tag)"
                    dict["other"] = textField.text!
                    dict["parentName"] = school?.schoolCategoryName
                    selectedData.add(dict)
                    flag = 1
                } else {
                    for category in selectedData {
                        if let dict = category as? NSMutableDictionary,let parentId = dict["parentId"] as? String, parentId == "\(textField.tag)"  {
                            dict["other"] = textField.text!
                            flag = 1
                        }
                    }
                }
                
                // Array is > 0 but dict doesnt exists
                if flag == 0 {
                    let dict = NSMutableDictionary()
                    dict["parentId"] = "\(textField.tag)"
                    dict["schoolId"] = "\(textField.tag)"
                    dict["other"] = textField.text!
                    dict["parentName"] = school?.schoolCategoryName
                    selectedData.add(dict)
                }
                
                // debugPrint(selectedData)
            }
            isFilledFromAutoComplete = false
        }
        checkForEmptySchoolField()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        hideAutoCompleteView()
        return true
    }
}
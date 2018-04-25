//
//  DMEditStudyVC+TableViewExtension.swift
//  DentaMatch
//
//  Created by Rajan Maheshwari on 27/01/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import Foundation

extension DMEditStudyVC:UITableViewDataSource,UITableViewDelegate {
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return schoolCategories.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let schoolCategory = schoolCategories[indexPath.row]
        if !schoolCategory.isOpen {
            return 60
        } else { return 202 }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StudyCell") as! StudyCell
        updateCellForStudyCell(cell: cell, indexPath: indexPath)
        return cell
    }
    
    func updateCellForStudyCell(cell:StudyCell , indexPath: IndexPath) {
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
        cell.schoolNameTextField.keyboardType = .asciiCapable
        
        for dict in selectedData {
            let selectedDict = dict as! NSDictionary
            if selectedDict["parentId"] as! String == "\(school.schoolCategoryId)" {
                if let schoolName = selectedDict["other"] as? String {
                    cell.schoolNameTextField.text = schoolName
                }
                if let yearOfGraduation = selectedDict["yearOfGraduation"] as? String {
                    cell.yearOfGraduationTextField.text = yearOfGraduation
                }
            }
        }
        
        cell.schoolNameTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        cell.headingButton.tag = indexPath.row
        cell.headingButton.setTitle(school.schoolCategoryName, for: .normal)
        
    }
    
    @objc func buttonTapped(sender:UIButton) {
        let school = schoolCategories[sender.tag]
        if school.isOpen {
            school.isOpen = false
        } else {
            school.isOpen = true
        }
        //school[sender.tag] = dict
        
        self.studyTableView.reloadRows(at: [IndexPath(row: sender.tag, section: 0)], with: .automatic)
        DispatchQueue.main.async {
            self.studyTableView.scrollToRow(at: IndexPath(row: sender.tag, section: 0), at: .bottom, animated: true)
            
        }
    }
   
    func checkForEmptySchoolField() {
        let emptyData = NSMutableArray()
        for category in selectedData {
            let dict = category as! NSMutableDictionary
            if (dict["other"] as! String).isEmptyField {
                emptyData.add(dict)
            }
        }
//        selectedData.removeObjects(in: emptyData as [AnyObject])
//        if emptyData.count > 0 {
//            self.makeToast(toastString: "Please enter school name first")
//        }
        debugPrint(selectedData)
//        self.studyTableView.reloadData()
        
    }

}

extension DMEditStudyVC : UITextFieldDelegate {
    @objc func textFieldDidChange(textField:UITextField) {
        
        let schoolCategory = schoolCategories.filter({$0.schoolCategoryId == "\(textField.tag)"}).first
        
        let university = schoolCategory?.universities.filter({$0.universityName == textField.text})
        
        //selectedUniversities["\(textField.tag)"] = nil
        
        if (university?.count)! > 0 {
            //Its in the list
            debugPrint("In the list")
        } else {
            
            //            if textField.text!.isEmpty {
            //                selectedUniversities["other_\(textField.tag)"] = nil
            //                selectedUniversities["other_date\(textField.tag)"] = nil
            //            } else {
            //                selectedUniversities["other_date\(textField.tag)"] = "" as AnyObject?
            //                selectedUniversities["other_\(textField.tag)"] = textField.text! as AnyObject?
            //            }
        }
        
        //print(selectedUniversities)
        
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
        self.yearPicker?.getPreSelectedValues(dateString: "", curTag: textField.tag)
        
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        //textFieldDidBeginEditing
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        //textFieldDidEndEditing
//        textField.resignFirstResponder()

        debugPrint("textFieldDidEndEditing")
        
        let school = schoolCategories.filter({$0.schoolCategoryId == "\(textField.tag)"}).first
        
        
        if textField.inputView is YearPickerView {
            debugPrint("year picker")
        }
        else {
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
                        let dict = category as! NSMutableDictionary
                        
                        if dict["parentId"] as! String == "\(textField.tag)" {
                            dict["other"] = textField.text!
                            flag = 1
                        }
                    }
                }
                
                //Array is > 0 but dict doesnt exists
                if flag == 0 {
                    let dict = NSMutableDictionary()
                    dict["parentId"] = "\(textField.tag)"
                    dict["schoolId"] = "\(textField.tag)"
                    dict["other"] = textField.text!
                    dict["parentName"] = school?.schoolCategoryName
                    selectedData.add(dict)
                }
                
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

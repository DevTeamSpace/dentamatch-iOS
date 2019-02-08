//
//  DMEditStudyVC+TableViewExtension.swift
//  DentaMatch
//
//  Created by Rajan Maheshwari on 27/01/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import Foundation

extension DMEditStudyVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return viewOutput?.schoolCategories.count ?? 0
    }

    func tableView(_: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let schoolCategory = viewOutput?.schoolCategories[indexPath.row] else { return 0 }
        if !schoolCategory.isOpen {
            return 60
        } else { return 202 }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StudyCell") as! StudyCell
        updateCellForStudyCell(cell: cell, indexPath: indexPath)
        return cell
    }

    func updateCellForStudyCell(cell: StudyCell, indexPath: IndexPath) {
        guard let viewOutput = viewOutput else { return }
        let school = viewOutput.schoolCategories[indexPath.row]
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

        for dict in viewOutput.selectedData {
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
        guard let school = viewOutput?.schoolCategories[sender.tag] else { return }
        if school.isOpen {
            school.isOpen = false
        } else {
            school.isOpen = true
        }
        // school[sender.tag] = dict

        studyTableView.reloadRows(at: [IndexPath(row: sender.tag, section: 0)], with: .automatic)
        DispatchQueue.main.async { [weak self] in
            self?.studyTableView.scrollToRow(at: IndexPath(row: sender.tag, section: 0), at: .bottom, animated: true)
        }
    }
}

extension DMEditStudyVC: UITextFieldDelegate {
    @objc func textFieldDidChange(textField: UITextField) {
        let schoolCategory = viewOutput?.schoolCategories.filter({ $0.schoolCategoryId == "\(textField.tag)" }).first

        let university = schoolCategory?.universities.filter({ $0.universityName == textField.text })

        // selectedUniversities["\(textField.tag)"] = nil

        if (university?.count)! > 0 {
            LogManager.logDebug("In the list")
        } else {
           LogManager.logDebug("Out of list")
        }
        // print(selectedUniversities)

        if textField.text!.isEmpty {
            hideAutoCompleteView()
        } else {
            let schoolId = "\(textField.tag)"

            var universities = viewOutput?.schoolCategories.filter({ $0.schoolCategoryId == schoolId }).first?.universities

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
        overlayView.isHidden = false
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        overlayView.isHidden = true
        //textFieldDidEndEditing
//        textField.resignFirstResponder()

        // debugPrint("textFieldDidEndEditing")

        let school = viewOutput?.schoolCategories.filter({ $0.schoolCategoryId == "\(textField.tag)" }).first

        if textField.inputView is YearPickerView {
            // debugPrint("year picker")
        } else {
            if viewOutput?.isFilledFromAutoComplete == false {
                var flag = 0

                if viewOutput?.selectedData.count == 0 {
                    let dict = NSMutableDictionary()
                    dict["parentId"] = "\(textField.tag)"
                    dict["schoolId"] = "\(textField.tag)"
                    dict["other"] = textField.text!
                    dict["parentName"] = school?.schoolCategoryName
                    viewOutput?.selectedData.add(dict)
                    flag = 1
                } else {
                    for category in viewOutput?.selectedData ?? NSMutableArray() {
                        if let dict = category as? NSMutableDictionary, let parentId = dict["parentId"] as? String  {
                            if parentId == "\(textField.tag)" {
                                dict["other"] = textField.text!
                                flag = 1
                            }
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
                    viewOutput?.selectedData.add(dict)
                }
            }
            viewOutput?.isFilledFromAutoComplete = false
        }
        viewOutput?.checkForEmptySchoolField()
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        hideAutoCompleteView()
        return true
    }
}

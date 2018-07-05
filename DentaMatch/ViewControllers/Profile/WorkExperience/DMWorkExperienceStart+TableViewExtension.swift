//
//  DMWorkExperienceStart+TableViewExtension.swift
//  DentaMatch
//
//  Created by Sanjay Kumar Yadav on 04/01/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import Foundation
import UIKit

extension DMWorkExperienceStart: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in _: UITableView) -> Int {
        return 1
    }

    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return 5
    }

    func tableView(_: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return 213
        case 1:
            return 45
        case 2:
            return 95
        case 3, 4:
            return 75
        default:
            return 0
        }
    }

    func tableView(_: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0
        }
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            // PhotoNameCell
            let cell = tableView.dequeueReusableCell(withIdentifier: "PhotoNameCell") as! PhotoNameCell
            cell.updateCellForPhotoNameCell(nametext: "Where do you work?", jobTitleText: "Relevant work experience strengthens your profile", profileProgress: profileProgress)
            cell.selectionStyle = .none

            return cell

        case 1:
            // Section Heading Cell
            let cell = tableView.dequeueReusableCell(withIdentifier: "SectionHeadingTableCell") as! SectionHeadingTableCell
            cell.headingLabel.text = "WORK EXPERIENCE"

            return cell

        case 2, 3, 4:
            let cell = tableView.dequeueReusableCell(withIdentifier: "AnimatedPHTableCell") as! AnimatedPHTableCell
            updateCellForWorkeExperienceStart(cell: cell, indexPath: indexPath)
            return cell

        default: break
        }

        return UITableViewCell()
    }

    func updateCellForWorkeExperienceStart(cell: AnimatedPHTableCell, indexPath: IndexPath) {
        if indexPath.row == 2 {
            cell.cellTopSpace.constant = 30
        } else {
            cell.cellTopSpace.constant = 10
        }

        switch indexPath.row {
        case 2:
            cellConfigureForJobSelection(cell: cell, indexPath: indexPath)
        case 3:
            cellConfigureForExperience(cell: cell, indexPath: indexPath)
        case 4:
            cell.commonTextField.placeholder = FieldType.OfficeName.description
            cell.commonTextField.tag = 2
            cell.commonTextField.type = 0
            cell.commonTextField.tintColor = view.tintColor
            cell.commonTextField.autocapitalizationType = .sentences
        default:
            debugPrint("default")
        }
        cell.commonTextField.text = self.experienceArray[indexPath.row - 2] as? String
        cell.commonTextField.delegate = self
    }

    func cellConfigureForJobSelection(cell: AnimatedPHTableCell, indexPath _: IndexPath) {
        cell.commonTextField.placeholder = FieldType.CurrentJobTitle.description
        let pickerView = JobSelectionPickerView.loadJobSelectionView(withJobTitles: jobTitles)
        cell.commonTextField.type = 1
        // Right View for drop down
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
        cell.commonTextField.tintColor = UIColor.clear
        cell.commonTextField.inputView = pickerView
        pickerView.delegate = self
        cell.commonTextField.tag = 0
        pickerView.pickerView.reloadAllComponents()
        pickerView.backgroundColor = UIColor.white
    }

    func cellConfigureForExperience(cell: AnimatedPHTableCell, indexPath: IndexPath) {
        cell.commonTextField.placeholder = FieldType.YearOfExperience.description
        let yearViewObj = ExperiencePickerView.loadExperiencePickerView(withText: experienceArray[indexPath.row - 2] as! String)
        yearViewObj.delegate = self
        cell.commonTextField.tag = 1
        cell.commonTextField.type = 1
        cell.commonTextField.tintColor = UIColor.clear
        cell.commonTextField.inputView = yearViewObj
    }

    func doneButtonAction(year: Int, month: Int) {
        view.endEditing(true)

        var text: String = ""

        if year <= 1 {
            if year != 0 {
                text.append("\(year) year")
            }
        } else {
            text.append("\(year) years")
        }

        if month <= 1 {
            if month != 0 {
                text.append(" \(month) month")
            }
        } else {
            text.append(" \(month) months")
        }
        totalExperience = (year * 12) + month

        experienceArray.replaceObject(at: 1, with: text)
        workExperienceTable.reloadData()
    }

    func canceButtonAction() {
        view.endEditing(true)
    }
}

extension DMWorkExperienceStart: UITextFieldDelegate {
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
        case 2:
            experienceArray.replaceObject(at: 2, with: textField.text!)
        default:
            debugPrint("default")
        }
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn _: NSRange, replacementString string: String) -> Bool {
        guard string.characters.count > 0 else {
            return true
        }
        if (textField.text?.characters.count)! >= Constants.Limit.commonMaxLimit {
            return false
        }

        return true
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

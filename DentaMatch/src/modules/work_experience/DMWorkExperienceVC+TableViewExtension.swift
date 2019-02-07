import Foundation
import UIKit

extension DMWorkExperienceVC: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in _: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection _: Int) -> Int {
        guard let viewOutput = viewOutput else { return 0 }
        if tableView == workExperienceDetailTable {
            return 7 + viewOutput.currentExperience.references.count
        } else {
            return viewOutput.exprienceArray.count
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == workExperienceDetailTable {
            return getHeightForworkExperienceDetailTable(indexPath: indexPath)
        } else {
            return 44
        }
    }

    func getHeightForworkExperienceDetailTable(indexPath: IndexPath) -> CGFloat {
        guard let viewOutput = viewOutput else { return 0.0 }
        if indexPath.row > viewOutput.currentExperience.references.count + 5 {
            let height = viewOutput.currentExperience.isFirstExperience ? 80 : 130
            return CGFloat(height)
        }
        
        if indexPath.row > 5 {
            let index = indexPath.row - 5
            var height = index == 0 ? (viewOutput.currentExperience.references.count > index ? 230 : 257) : (viewOutput.currentExperience.references.count - 1 > index ? 260 : 303)
            if viewOutput.currentExperience.references.count == 1 {
                height = 250 // if single experience is added add work experience button should be clickable
            }
            
            return CGFloat(height)
        }
        if indexPath.row == 0 {
            return 95
        }
        return 75
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let viewOutput = viewOutput else { return UITableViewCell() }
        if tableView == workExperienceDetailTable {
            if indexPath.row > viewOutput.currentExperience.references.count + 5 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "AddDeleteExperienceCell") as! AddDeleteExperienceCell
                cell.selectionStyle = .none
                updateCellForAddDeleteExperienceCell(cell: cell, indexPth: indexPath)

                return cell
            }

            if indexPath.row > 5 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "ReferenceTableCell") as! ReferenceTableCell
                let tag = indexPath.row - 6
                cell.selectionStyle = .none
                cell.nameTextField.delegate = self
                cell.mobileNoTextField.delegate = self
                cell.emailTextField.delegate = self
                let empRef = viewOutput.currentExperience.references[tag]
                cell.updateCell(empRef: empRef, tag: tag)
                cell.nameTextField.addTarget(self, action: #selector(referenceNameTextFieldDidEnd(_:)), for: .editingDidEnd)
                cell.nameTextField.autocapitalizationType = .sentences
                cell.mobileNoTextField.addTarget(self, action: #selector(referenceMobileNumberTextFieldDidEnd(_:)), for: .editingDidEnd)
                cell.emailTextField.addTarget(self, action: #selector(referenceEmailTextFieldDidEnd(_:)), for: .editingDidEnd)

                cell.mobileNoTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
                cell.deleteButton.addTarget(self, action: #selector(DMWorkExperienceVC.deleteReference(_:)), for: .touchUpInside)
                cell.addMoreReferenceButton.addTarget(self, action: #selector(DMWorkExperienceVC.addMoreReference(_:)), for: .touchUpInside)
                if tag == 0 {
                    if viewOutput.currentExperience.references.count - 1 > tag {
                        cell.addMoreReferenceButton.isHidden = true
                    } else if viewOutput.currentExperience.references.count >= 2 {
                        cell.addMoreReferenceButton.isHidden = true
                    } else {
                        cell.addMoreReferenceButton.isHidden = false
                    }
                    cell.deleteButton.isHidden = true
                    cell.addMoreButtonTopSpace.constant = 10

                } else {
                    if viewOutput.currentExperience.references.count - 1 > tag {
                        cell.deleteButton.isHidden = false
                        cell.addMoreButtonTopSpace.constant = 10
                        cell.addMoreReferenceButton.isHidden = true
                    } else if viewOutput.currentExperience.references.count >= 2 {
                        cell.addMoreButtonTopSpace.constant = 10
                        cell.addMoreReferenceButton.isHidden = true
                    } else {
                        cell.deleteButton.isHidden = false
                        cell.addMoreButtonTopSpace.constant = 55
                        cell.addMoreReferenceButton.isHidden = false
                    }
                }

//                cell.addMoreReferenceButton.contentEdgeInsets = UIEdgeInsetsMake(-10, 15, -20, 0);
                cell.addMoreReferenceButton.layoutIfNeeded()
                cell.layoutIfNeeded()
                return cell

            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "AnimatedPHTableCell") as! AnimatedPHTableCell
                cell.selectionStyle = .none

                updateCellForAnimatedPHTableCell(cell: cell, indexPath: indexPath)

                return cell
            }

        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ExperienceTableCell") as! ExperienceTableCell
            cell.selectionStyle = .none
            let exp = viewOutput.exprienceArray[indexPath.row]

            cell.experienceLabel.text = exp.yearOfExperience
            cell.jobTitleLable.text = exp.jobTitle

            // ExperienceTableCell
            return cell
        }
    }

    func updateCellForAddDeleteExperienceCell(cell: AddDeleteExperienceCell, indexPth: IndexPath) {
        guard let viewOutput = viewOutput else { return }
        let tag = indexPth.row - 5 - viewOutput.currentExperience.references.count
        cell.addMoreExperienceButton.tag = tag
        cell.deleteButton.tag = tag

        if viewOutput.currentExperience.isEditMode == true {
            cell.addMoreExperienceButton.setTitle(" Save", for: .normal)
        } else {
            cell.addMoreExperienceButton.setTitle(" Save Job", for: .normal)
        }

        cell.deleteButton.addTarget(self, action: #selector(DMWorkExperienceVC.deleteExperience(_:)), for: .touchUpInside)
        cell.addMoreExperienceButton.addTarget(self, action: #selector(DMWorkExperienceVC.addMoreExperience(_:)), for: .touchUpInside)

        if viewOutput.currentExperience.isFirstExperience == true {
            cell.deleteButton.isHidden = true
            cell.topSpaceOfAddMoreExperience.constant = 10
        } else {
            cell.deleteButton.isHidden = false
            cell.topSpaceOfAddMoreExperience.constant = 57
        }
        cell.addMoreExperienceButton.isHidden = true
        cell.layoutIfNeeded()
        
    }

    func updateCellForAnimatedPHTableCell(cell: AnimatedPHTableCell, indexPath: IndexPath) {
        guard let viewOutput = viewOutput else { return }
        if indexPath.row == 0 {
            cell.cellTopSpace.constant = 30
        } else {
            cell.cellTopSpace.constant = 10
        }
        cell.cellBottomSpace.constant = 10.5
        cell.commonTextField.delegate = self
        cell.commonTextField.tag = indexPath.row
        cell.commonTextField.autocapitalizationType = .sentences
        cell.commonTextField.addTarget(self, action: #selector(CommonExperiencelTextFieldDidEnd(_:)), for: .editingDidEnd)

        switch indexPath.row {
        case 0:
            cellConfigureForJobSelection(cell: cell, indexPath: indexPath)
        case 1:
            cellConfigureForExperience(cell: cell, indexPath: indexPath)
        case 2:
            cell.commonTextField.placeholder = FieldType.OfficeName.description
            cell.commonTextField.text = viewOutput.currentExperience.officeName

        case 3:
            cell.commonTextField.placeholder = FieldType.OfficeAddress.description
            cell.commonTextField.text = viewOutput.currentExperience.officeAddress

        case 4:
            cell.commonTextField.placeholder = FieldType.CityName.description
            cell.commonTextField.text = viewOutput.currentExperience.cityName
        case 5:
            cell.commonTextField.placeholder = FieldType.StateName.description
            cell.commonTextField.text = viewOutput.currentExperience.stateName
           
        default:
            LogManager.logDebug("default")
        }
    }

    func cellConfigureForJobSelection(cell: AnimatedPHTableCell, indexPath _: IndexPath) {
        guard let viewOutput = viewOutput else { return }
        cell.commonTextField.placeholder = FieldType.CurrentJobTitle.description
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

        cell.commonTextField.text = viewOutput.currentExperience.jobTitle
        let pickerView = JobSelectionPickerView.loadJobSelectionView(withJobTitles: viewOutput.jobTitles)
        cell.commonTextField.type = 1
        cell.commonTextField.tintColor = UIColor.clear
        cell.commonTextField.inputView = pickerView
        pickerView.delegate = self
        pickerView.pickerView.reloadAllComponents()
        pickerView.backgroundColor = UIColor.white
    }

    func cellConfigureForExperience(cell: AnimatedPHTableCell, indexPath _: IndexPath) {
        guard let viewOutput = viewOutput else { return }
        cell.commonTextField.placeholder = FieldType.YearOfExperience.description
        cell.commonTextField.text = viewOutput.currentExperience.yearOfExperience!
        let yearViewObj = ExperiencePickerView.loadExperiencePickerView(withText: viewOutput.currentExperience.yearOfExperience ?? "")
        yearViewObj.delegate = self
        cell.commonTextField.type = 1
        cell.commonTextField.tintColor = UIColor.clear
        cell.commonTextField.inputView = yearViewObj
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView == workExperienceTable {
            viewOutput?.isHiddenExperienceTable = true
            viewOutput?.selectedIndex = indexPath.row
//            let check  = indexPath.row == 0 ? true : false
            let model = viewOutput?.exprienceArray[indexPath.row] ?? ExperienceModel(empty: "")
            viewOutput?.currentExperience = model
            viewOutput?.currentExperience.isFirstExperience = false
            viewOutput?.currentExperience.isEditMode = true
            workExperienceTable.reloadData()
            workExperienceDetailTable.reloadData()
            reSizeTableViewsAndScrollView()
        }
    }

    @objc func referenceNameTextFieldDidEnd(_ textField: UITextField) {
        guard let viewOutput = viewOutput else { return }
        let tag = textField.tag
        let empRef = viewOutput.currentExperience.references[tag]
        empRef.referenceName = textField.text
        viewOutput.currentExperience.references[tag] = empRef
    }

    @objc func referenceMobileNumberTextFieldDidEnd(_ textField: UITextField) {
        guard let viewOutput = viewOutput else { return }
        let tag = textField.tag
        let empRef = viewOutput.currentExperience.references[tag]
        empRef.mobileNumber = textField.text
        viewOutput.currentExperience.references[tag] = empRef
    }

    @objc func referenceEmailTextFieldDidEnd(_ textField: UITextField) {
        guard let viewOutput = viewOutput else { return }
        let tag = textField.tag
        let empRef = viewOutput.currentExperience.references[tag]
        empRef.email = textField.text
        viewOutput.currentExperience.references[tag] = empRef
    }

    @objc func textFieldDidChange(_ textField: UITextField) {
        textField.text = phoneFormatter.format(textField.text!, hash: textField.hash)
    }

    @objc func CommonExperiencelTextFieldDidEnd(_ textField: UITextField) {
        guard let viewOutput = viewOutput else { return }
        switch textField.tag {
        case 2:
            viewOutput.currentExperience.officeName = textField.text
        case 3:
            viewOutput.currentExperience.officeAddress = textField.text
        case 4:
            viewOutput.currentExperience.cityName = textField.text
        default:
            LogManager.logDebug("default")
        }
    }

    func toolBarButtonPressed(position _: Position) {
        view.endEditing(true)
    }

    func doneButtonAction(year: Int, month: Int) {
        guard let viewOutput = viewOutput else { return }
        workExperienceTable.endEditing(true)

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
        let total = (year * 12) + month

        viewOutput.currentExperience.yearOfExperience = text
        viewOutput.currentExperience.experienceInMonth = total
        workExperienceDetailTable.reloadData()
    }

    func canceButtonAction() {
        workExperienceDetailTable.endEditing(true)
    }

    @objc func addMoreReference(_: Any) {
        guard let viewOutput = viewOutput else { return }
        if viewOutput.currentExperience.references.count < 2 {
            if viewOutput.currentExperience.references[0].referenceName?.isEmptyField == true && viewOutput.currentExperience.references[0].mobileNumber?.isEmptyField == true && viewOutput.currentExperience.references[0].email?.isEmptyField == true {
                
                makeToast(toastString: Constants.AlertMessage.firstEmptyExperience)

            } else {
                let refere = EmployeeReferenceModel(empty: "")
                viewOutput.currentExperience.references.append(refere)
                workExperienceDetailTable.reloadData()
                reSizeTableViewsAndScrollView()
                var aRect = self.workExperienceDetailTable.frame
                aRect.size.height += 300
                self.mainScrollView.scrollRectToVisible(aRect, animated: true)
            }

        } else {
            makeToast(toastString: Constants.AlertMessage.morethen2refernce)
        }
    }

    @objc func addMoreExperience(_: Any) {

        view.endEditing(true)
        if !checkValidations() {
            return
        }
        
        viewOutput?.saveUpdateExperience(isAddExperience: true)
    }

    @objc func deleteReference(_ sender: Any) {
        guard let viewOutput = viewOutput else { return }
        view.endEditing(true)
        let tag = (sender as AnyObject).tag
        viewOutput.currentExperience.references.remove(at: tag!)
        workExperienceTable.reloadData()
        workExperienceDetailTable.reloadData()
        reSizeTableViewsAndScrollView()
    }

    @objc func deleteExperience(_: Any) {
        guard let viewOutput = viewOutput else { return }
        view.endEditing(true)

        let alertController = UIAlertController(title: "", message: "Are you sure you want to delete this work experience?", preferredStyle: .alert)
        let action1 = UIAlertAction(title: "OK", style: .default) { (_: UIAlertAction) in
            if viewOutput.currentExperience.isEditMode == true {
                viewOutput.deleteExperience()
            } else {
                self.viewOutput?.currentExperience = ExperienceModel(empty: "")
                self.viewOutput?.currentExperience.isFirstExperience = false
                self.viewOutput?.currentExperience.references.append(EmployeeReferenceModel(empty: ""))
                self.viewOutput?.isHiddenExperienceTable = false
                
                self.workExperienceTable.reloadData()
                self.workExperienceDetailTable.reloadData()
                self.reSizeTableViewsAndScrollView()
                self.updateProfileScreen()
            }
        }
        let action2 = UIAlertAction(title: "CANCEL", style: .default) { (_: UIAlertAction) in
            // debugPrint("No")
        }
        alertController.addAction(action2)
        alertController.addAction(action1)
        present(alertController, animated: true, completion: nil)
    }

    func checkValidations() -> Bool {
        guard let viewOutput = viewOutput else { return false }
        if viewOutput.currentExperience.jobTitle?.trimmingCharacters(in: CharacterSet.whitespaces).isEmpty == true {
            makeToast(toastString: Constants.AlertMessage.emptyCurrentJobTitle)
            return false
        } else if viewOutput.currentExperience.yearOfExperience?.trimmingCharacters(in: CharacterSet.whitespaces).isEmpty == true {
            makeToast(toastString: Constants.AlertMessage.emptyYearOfExperience)
            return false
        } else if viewOutput.currentExperience.officeName?.trimmingCharacters(in: CharacterSet.whitespaces).isEmpty == true {
            makeToast(toastString: Constants.AlertMessage.emptyOfficeName)
            return false
        } else if viewOutput.currentExperience.officeAddress?.trimmingCharacters(in: CharacterSet.whitespaces).isEmpty == true {
            makeToast(toastString: Constants.AlertMessage.emptyOfficeAddress)
            return false
        } else if viewOutput.currentExperience.cityName?.trimmingCharacters(in: CharacterSet.whitespaces).isEmpty == true {
            makeToast(toastString: Constants.AlertMessage.emptyCityName)
            return false
        }else if viewOutput.currentExperience.stateName?.trimmingCharacters(in: CharacterSet.whitespaces).isEmpty == true {
            makeToast(toastString: Constants.AlertMessage.emptyStateName)
            return false
        }

        for index in 0 ..< viewOutput.currentExperience.references.count {
            let empRef = viewOutput.currentExperience.references[index]

            if empRef.mobileNumber?.isEmptyField == false {
                if !phoneFormatter.isValid((empRef.mobileNumber!)) {
                    makeToast(toastString: Constants.AlertMessage.referenceMobileNumber)
                    return false
                }
            }
            if empRef.email?.isEmptyField == false {
                if !(empRef.email?.isValidEmail)! {
                    makeToast(toastString: Constants.AlertMessage.invalidEmailAddress)
                    return false
                }
            }

            if index == 1 {
                if viewOutput.currentExperience.references[0].referenceName?.isEmptyField == true && viewOutput.currentExperience.references[0].mobileNumber?.isEmptyField == true && viewOutput.currentExperience.references[0].email?.isEmptyField == true {
                    makeToast(toastString: Constants.AlertMessage.empptyFirstReference)
                    return false
                }
            }
        }

        return true
    }

    func checkAllFieldIsEmpty() -> Bool {
        guard let viewOutput = viewOutput else { return false }
        if viewOutput.currentExperience.jobTitle?.trimmingCharacters(in: CharacterSet.whitespaces).isEmpty == false {
            return false
        }
        if viewOutput.currentExperience.yearOfExperience?.trimmingCharacters(in: CharacterSet.whitespaces).isEmpty == false {
            return false
        }
        if viewOutput.currentExperience.officeName?.trimmingCharacters(in: CharacterSet.whitespaces).isEmpty == false {
            makeToast(toastString: Constants.AlertMessage.emptyOfficeName)
            return false
        }
        if viewOutput.currentExperience.officeAddress?.trimmingCharacters(in: CharacterSet.whitespaces).isEmpty == false {
            return false
        }
        if viewOutput.currentExperience.cityName?.trimmingCharacters(in: CharacterSet.whitespaces).isEmpty == false {
            return false
        }
        if viewOutput.currentExperience.stateName?.trimmingCharacters(in: CharacterSet.whitespaces).isEmpty == false {
            return false
        }
        return true
    }

    func checkAllFieldsAreFilled() -> Bool {
        guard let viewOutput = viewOutput else { return false }
        if viewOutput.currentExperience.jobTitle?.trimmingCharacters(in: CharacterSet.whitespaces).isEmpty == true {
            return false
        }
        if viewOutput.currentExperience.yearOfExperience?.trimmingCharacters(in: CharacterSet.whitespaces).isEmpty == true {
            return false
        }
        if viewOutput.currentExperience.officeName?.trimmingCharacters(in: CharacterSet.whitespaces).isEmpty == true {
            makeToast(toastString: Constants.AlertMessage.emptyOfficeName)
            return false
        }
        if viewOutput.currentExperience.officeAddress?.trimmingCharacters(in: CharacterSet.whitespaces).isEmpty == true {
            return false
        }
        if viewOutput.currentExperience.cityName?.trimmingCharacters(in: CharacterSet.whitespaces).isEmpty == true {
            return false
        }
        if viewOutput.currentExperience.stateName?.trimmingCharacters(in: CharacterSet.whitespaces).isEmpty == true {
            return false
        }
        return true
    }
}

extension DMWorkExperienceVC: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn _: NSRange, replacementString string: String) -> Bool {
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
        if textField.tag == 5 {
            textField.resignFirstResponder()
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

    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.tag == 5 {
            textField.resignFirstResponder()
            self.goToStates(textField.text)
        }
    }
}

extension String {
    public func toPhoneNumber() -> String {
        return replacingOccurrences(of: "(\\d{3})(\\d{3})(\\d+)", with: "($1) $2-$3", options: .regularExpression, range: nil)
    }
}

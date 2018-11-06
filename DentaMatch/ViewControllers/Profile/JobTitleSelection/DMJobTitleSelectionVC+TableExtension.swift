//
//  DMJobTitleSelectionVC+TableExtension.swift
//  DentaMatch
//
//  Created by Rajan Maheshwari on 06/11/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import Foundation

extension DMJobTitleSelectionVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row > 2 {
            return 110
        }
        if selectedJobTitle == nil {
            if indexPath.row == 1 || indexPath.row == 2 {
                return 0
            }
            return UITableViewAutomaticDimension
        }
        if let selectedJobTitle = selectedJobTitle, selectedJobTitle.isLicenseRequired == false {
            if indexPath.row == 1 || indexPath.row == 2 {
                return 0
            }
            return UITableViewAutomaticDimension
        } else {
            return UITableViewAutomaticDimension
        }
    }

    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return 4
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // For about yourself
        if indexPath.row > 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AboutMeJobSelectionCell") as! AboutMeJobSelectionCell
            cell.aboutMeTextView.delegate = self
            cell.aboutMeTextView.inputAccessoryView = addToolBarOnTextView()
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AnimatedPHToolTipCell") as! AnimatedPHToolTipCell
            cell.isToolTipHidden = true
            updateCellForTextField(cell: cell, indexPath: indexPath)
            cell.clipsToBounds = true
            cell.commonTextField.type = 1
            cell.editAction { [weak self](text) in
                self?.goToStates(text)
            }
            return cell
        }
    }

    func updateCellForTextField(cell: AnimatedPHToolTipCell, indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            cell.commonTextField.inputView = jobSelectionPickerView
            cell.commonTextField.placeholder = "Job Title"
            cell.commonTextField.tag = 1
            cell.commonTextField.tintColor = UIColor.clear
            cell.commonTextField.delegate = self
        case 1:
            cell.commonTextField.placeholder = "License Number"
            cell.commonTextField.tag = 2
            cell.toolTipLabel?.text = "We’ll confirm your license within the next business day."
            cell.commonTextField.delegate = self
            cell.isToolTipHidden = false
        case 2:
            cell.commonTextField.placeholder = "License State"
            cell.commonTextField.tag = 3
            cell.showKeyboard = false
            cell.commonTextField.text = self.state

        case 3:
            break
        default:
            break
        }
    }
}

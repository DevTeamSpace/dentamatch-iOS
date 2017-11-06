//
//  DMJobTitleSelectionVC+TableExtension.swift
//  DentaMatch
//
//  Created by Rajan Maheshwari on 06/11/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import Foundation

extension DMJobTitleSelectionVC : UITableViewDataSource,UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row > 2 {
            return 110
        }
        if let selectedJobTitle = selectedJobTitle, selectedJobTitle.isLicenseRequired == false {
            if indexPath.row == 1 || indexPath.row == 2 {
                return 0
            }
            return 76
        }
        return 76
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //For about yourself
        if indexPath.row > 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AboutMeJobSelectionCell") as! AboutMeJobSelectionCell
            cell.aboutMeTextView.delegate = self
            cell.aboutMeTextView.inputAccessoryView = self.addToolBarOnTextView()
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AnimatedPHTableCell") as! AnimatedPHTableCell
            updateCellForTextField(cell: cell, indexPath: indexPath)
            cell.clipsToBounds = true
            cell.commonTextField.delegate = self
            cell.commonTextField.type = 1
            return cell
        }
    }
    
    func updateCellForTextField(cell:AnimatedPHTableCell ,indexPath :IndexPath ) {
        switch indexPath.row {
        case 0:
            cell.commonTextField.inputView = jobSelectionPickerView
            cell.commonTextField.placeholder = "Current Job Title"
            cell.commonTextField.tag = 1
            cell.commonTextField.tintColor = UIColor.clear
        case 1:
            cell.commonTextField.placeholder = "License Number"
            cell.commonTextField.tag = 2
        case 2:
            cell.commonTextField.placeholder = "State"
            cell.commonTextField.tag = 3

        case 3:
            break
        default:
            break
        }
    }
    
}

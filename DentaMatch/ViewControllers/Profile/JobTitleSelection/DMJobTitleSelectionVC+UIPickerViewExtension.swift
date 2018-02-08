//
//  DMJobTitleSelectionVC+UIPickerViewExtension.swift
//  DentaMatch
//
//  Created by Rajan Maheshwari on 09/01/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import Foundation

extension DMJobTitleSelectionVC:JobSelectionPickerViewDelegate {
    
    func jobPickerDoneButtonAction(job: JobTitle?) {
        if let jobTitle = job {
            self.selectedJobTitle = jobTitle

            if let cell = self.jobTitleSelectionTableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? AnimatedPHTableCell {
                cell.commonTextField.text = jobTitle.jobTitle
                self.jobTitleSelectionTableView.reloadData()
            }
        }
        self.changeUIOFCreateProfileButton(self.isCreateProfileButtonEnable())
        self.view.endEditing(true)
    }
    
    func jobPickerCancelButtonAction() {
        self.changeUIOFCreateProfileButton(self.isCreateProfileButtonEnable())
        self.view.endEditing(true)
    }
}

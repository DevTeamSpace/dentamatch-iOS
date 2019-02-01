import Foundation

extension DMJobTitleSelectionVC: JobSelectionPickerViewDelegate {
    func jobPickerDoneButtonAction(job: JobTitle?) {
        if let jobTitle = job {
            viewOutput?.selectedJobTitle = jobTitle
            licenseNumber = ""
            state = ""
            if let cell = self.jobTitleSelectionTableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? AnimatedPHToolTipCell {
                cell.commonTextField.text = jobTitle.jobTitle
                jobTitleSelectionTableView.reloadData()
            }
        }
        changeUIOFCreateProfileButton(isCreateProfileButtonEnable())
        view.endEditing(true)
    }

    func jobPickerCancelButtonAction() {
        changeUIOFCreateProfileButton(isCreateProfileButtonEnable())
        view.endEditing(true)
    }
}

//
//  JobSelectionPickerView.swift
//  DentaMatch
//
//  Created by Rajan Maheshwari on 09/01/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

@objc protocol JobSelectionPickerViewDelegate {
    func jobPickerDoneButtonAction(job: JobTitle?)
    func jobPickerCancelButtonAction()
}

class JobSelectionPickerView: UIView, UIPickerViewDataSource, UIPickerViewDelegate {
    @IBOutlet var toolBar: UIToolbar!
    @IBOutlet var pickerView: UIPickerView!

    var jobTitles = [JobTitle]()

    weak var delegate: JobSelectionPickerViewDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    class func loadJobSelectionView(withJobTitles: [JobTitle]) -> JobSelectionPickerView {
        guard let instance = Bundle.main.loadNibNamed("JobSelectionPickerView", owner: self)?.first as? JobSelectionPickerView else {
            fatalError("Could not instantiate from nib: YearExperiencePickerView")
        }
        instance.setup(jobTitles: withJobTitles)
        return instance
    }

    func setup(jobTitles: [JobTitle]) {
        self.jobTitles = jobTitles
        pickerView.reloadAllComponents()
    }

    // MARK: - Picker View Datasource/Delegates

    func numberOfComponents(in _: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_: UIPickerView, numberOfRowsInComponent _: Int) -> Int {
        return jobTitles.count
    }

    func pickerView(_: UIPickerView, titleForRow row: Int, forComponent _: Int) -> String? {
        return jobTitles[row].jobTitle
    }

    func pickerView(_: UIPickerView, didSelectRow _: Int, inComponent _: Int) {
        // didSelectRow
    }

    @IBAction func cancelButtonPressed(_: Any) {
        if let delegate = delegate {
            delegate.jobPickerCancelButtonAction()
        }
    }

    @IBAction func doneButtonPressed(_: Any) {
        if let delegate = delegate {
            if jobTitles.count > 0 {
                delegate.jobPickerDoneButtonAction(job: jobTitles[self.pickerView.selectedRow(inComponent: 0)])
            } else {
                delegate.jobPickerDoneButtonAction(job: nil)
            }
        }
    }
}

//
//  JobSelectionPickerView.swift
//  DentaMatch
//
//  Created by Rajan Maheshwari on 09/01/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

@objc protocol JobSelectionPickerViewDelegate {
    
//    func numberOfComponents(in jobSelectionPickerView: UIPickerView) -> Int
//    func pickerView(_ jobSelectionPickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
//    func pickerView(_ jobSelectionPickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
//    func pickerView(_ jobSelectionPickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    
    func jobPickerDoneButtonAction(job:JobTitle?)
    func jobPickerCancelButtonAction()

}

class JobSelectionPickerView: UIView,UIPickerViewDataSource,UIPickerViewDelegate {

    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var pickerView: UIPickerView!
    
    var jobTitles = [JobTitle]()
    
    var delegate:JobSelectionPickerViewDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    class func loadJobSelectionView(withJobTitles:[JobTitle]) ->  JobSelectionPickerView{
        guard let instance = Bundle.main.loadNibNamed("JobSelectionPickerView", owner: self)?.first as? JobSelectionPickerView else {
            fatalError("Could not instantiate from nib: YearExperiencePickerView")
        }
        instance.setup(jobTitles: withJobTitles)
        return instance
    }

    
    func setup(jobTitles:[JobTitle]) {
        self.jobTitles = jobTitles
        self.pickerView.reloadAllComponents()
    }
    
    //MARK:- Picker View Datasource/Delegates
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return jobTitles.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let jobTitle = jobTitles[row]
        if jobTitle.jobTitle.isEmpty {
            return jobTitle.jobTitleName
        }
        return jobTitle.jobTitle
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // didSelectRow
    }

    @IBAction func cancelButtonPressed(_ sender: Any) {
        if let delegate = delegate {
            delegate.jobPickerCancelButtonAction()
        }
    }
    @IBAction func doneButtonPressed(_ sender: Any) {
        if let delegate = delegate {
            if jobTitles.count > 0 {
                delegate.jobPickerDoneButtonAction(job: jobTitles[self.pickerView.selectedRow(inComponent: 0)])
            } else {
                delegate.jobPickerDoneButtonAction(job: nil)
            }
        }
    }

}

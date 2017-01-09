//
//  DMJobTitleSelectionVC+UIPickerViewExtension.swift
//  DentaMatch
//
//  Created by Rajan Maheshwari on 09/01/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import Foundation

extension DMJobTitleSelectionVC:JobSelectionPickerViewDelegate {
    
    func numberOfComponents(in jobSelectionPickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ jobSelectionPickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 5
    }
    
    func pickerView(_ jobSelectionPickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "Job"
    }
    
    func pickerView(_ jobSelectionPickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print(row)
        self.currentJobTitleTextField.text = "Job"
    }
}

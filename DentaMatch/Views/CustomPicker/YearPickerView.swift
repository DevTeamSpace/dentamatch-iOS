//
//  YearPickerView.swift
//  DentaMatch
//
//  Created by Rajan Maheshwari on 23/01/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

protocol YearPickerViewDelegate {
    func canceButtonAction()
    func doneButtonAction(year: Int, tag: Int)
}

class YearPickerView: UIView, UIPickerViewDataSource, UIPickerViewDelegate {
    @IBOutlet var yearPickerView: UIPickerView!
    var delegate: YearPickerViewDelegate?
    var currentYear: Int = 0
    var currentTag: Int = 0

    class func loadYearPickerView(withText: String, withTag _: Int) -> YearPickerView {
        guard let instance = Bundle.main.loadNibNamed("YearPickerView", owner: self)?.first as? YearPickerView else {
            fatalError("Could not instantiate from nib: ExperiencePickerView")
        }
        instance.getPreSelectedValues(dateString: withText, curTag: 1)
        return instance
    }

    func getPreSelectedValues(dateString _: String, curTag: Int) {
        let date = Date()
        let calendar = Calendar.current
        currentTag = curTag
        let year = calendar.component(.year, from: date)
        currentYear = year
    }

    func numberOfComponents(in _: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_: UIPickerView, numberOfRowsInComponent _: Int) -> Int {
        return 100 + 1
    }

    func pickerView(_: UIPickerView, titleForRow row: Int, forComponent _: Int) -> String? {
        if row == 0 {
            return "Year of Graduation"
        }
        return "\(currentYear - row + 1)"
    }

    func pickerView(_: UIPickerView, didSelectRow _: Int, inComponent _: Int) {
        // Handle selection of picker view
    }

    @IBAction func doneButtonPressed(_: Any) {
        if let delegate = delegate {
            let row = yearPickerView.selectedRow(inComponent: 0)
            var selctedRow = -1

            if row == 0 {
//                let selctedRow = self.currentYear - row
                selctedRow = -1

            } else {
                selctedRow = currentYear - row + 1
            }

            delegate.doneButtonAction(year: selctedRow, tag: currentTag)
        }
    }

    @IBAction func canceButtonPressed(_: Any) {
        if let delegate = delegate {
            delegate.canceButtonAction()
        }
    }
}

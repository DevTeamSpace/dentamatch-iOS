//
//  DatePickerView.swift
//  DentaMatch
//
//  Created by Sanjay Kumar Yadav on 12/01/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit
@objc protocol DatePickerViewDelegate {
    func canceButtonAction()
    func doneButtonAction(date: String, tag: Int)
}

class DatePickerView: UIView {
    @IBOutlet var datePicker: UIDatePicker!
    weak var delegate: DatePickerViewDelegate?
    var currentTag: Int?

    class func loadExperiencePickerView(withText: String, tag: Int) -> DatePickerView {
        guard let instance = Bundle.main.loadNibNamed("DatePickerView", owner: self)?.first as? DatePickerView else {
            fatalError("Could not instantiate from nib: DatePickerView")
        }
        instance.getPreSelectedValues(dateString: withText, curTag: tag)
        return instance
    }

    func getPreSelectedValues(dateString: String, curTag: Int) {
        datePicker.minimumDate = Date()
        if dateString.trim().count > 0 {
            let date = Date.stringToDate(dateString: dateString)
            if date < Date() {
                // Handle less date scenario
            } else {
                datePicker.setDate(date, animated: true)
            }
        } else {
            datePicker.setDate(Date(), animated: false)
        }
        currentTag = curTag
    }

    @IBAction func cancelButtonClicked(_: Any) {
        delegate?.canceButtonAction()
        removeFromSuperview()
    }

    @IBAction func doneButtonClicked(_: Any) {
        let date = datePicker.date

        delegate?.doneButtonAction(date: Date.dateToString(date: date), tag: currentTag!)
        removeFromSuperview()
    }
}

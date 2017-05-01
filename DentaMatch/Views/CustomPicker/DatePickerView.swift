//
//  DatePickerView.swift
//  DentaMatch
//
//  Created by Sanjay Kumar Yadav on 12/01/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit
protocol DatePickerViewDelegate{
    
    func canceButtonAction()
    func doneButtonAction(date:String,tag:Int)
}

class DatePickerView: UIView {

    @IBOutlet weak var datePicker: UIDatePicker!
    var delegate: DatePickerViewDelegate?
    var currentTag:Int?
    
    class func loadExperiencePickerView(withText:String,tag:Int) ->  DatePickerView{
        guard let instance = Bundle.main.loadNibNamed("DatePickerView", owner: self)?.first as? DatePickerView else {
            fatalError("Could not instantiate from nib: DatePickerView")
        }
        instance.getPreSelectedValues(dateString: withText, curTag:tag )
        return instance
    }
    
    func getPreSelectedValues(dateString:String,curTag:Int)
    {
        self.datePicker.minimumDate = Date()
        if dateString.trim().characters.count > 0
        {
            let date =  Date.stringToDate(dateString: dateString)
            if date < Date() {
                //Handle less date scenario
            } else {
            self.datePicker.setDate(date, animated: true)
            }
        } else {
            self.datePicker.setDate(Date(), animated: false)
        }
        self.currentTag = curTag
    }
    @IBAction func cancelButtonClicked(_ sender: Any) {
        delegate?.canceButtonAction()
        self.removeFromSuperview()

    }
    @IBAction func doneButtonClicked(_ sender: Any) {
        let date = self.datePicker.date
        
        delegate?.doneButtonAction(date: Date.dateToString(date: date), tag: self.currentTag!)
        self.removeFromSuperview()
    }

}

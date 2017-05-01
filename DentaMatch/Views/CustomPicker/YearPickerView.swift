//
//  YearPickerView.swift
//  DentaMatch
//
//  Created by Rajan Maheshwari on 23/01/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

protocol YearPickerViewDelegate{
    
    func canceButtonAction()
    func doneButtonAction(year:Int,tag:Int)
}

class YearPickerView: UIView,UIPickerViewDataSource,UIPickerViewDelegate {

    @IBOutlet weak var yearPickerView: UIPickerView!
    var delegate:YearPickerViewDelegate?
    var currentYear : Int = 0
    var currentTag: Int = 0
    
    class func loadYearPickerView(withText:String, withTag:Int) ->  YearPickerView{
        guard let instance = Bundle.main.loadNibNamed("YearPickerView", owner: self)?.first as? YearPickerView else {
            fatalError("Could not instantiate from nib: ExperiencePickerView")
        }
        instance.getPreSelectedValues(dateString: withText, curTag: 1)
        return instance
    }
    
    
    func getPreSelectedValues(dateString:String,curTag:Int) {
        let date = Date()
        let calendar = Calendar.current
        self.currentTag = curTag
        let year = calendar.component(.year, from: date)
        
        currentYear = year
//        let month = calendar.component(.month, from: date)
//        let day = calendar.component(.day, from: date)
      //self.currentTag = curTag
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 100
       
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return "\(currentYear - row)"
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //Handle selection of picker view
    }

    @IBAction func doneButtonPressed(_ sender: Any) {
        
        if let delegate = delegate {
            let row  = self.yearPickerView.selectedRow(inComponent: 0)
            let selctedRow = self.currentYear - row

            delegate.doneButtonAction( year: selctedRow, tag: self.currentTag)
        }
    }
    @IBAction func canceButtonPressed(_ sender: Any) {
        if let delegate = delegate {
            delegate.canceButtonAction()
        }
    }

}

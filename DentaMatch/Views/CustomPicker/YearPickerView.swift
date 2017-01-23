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
    func doneButtonAction(year:Int,month:Int)
}

class YearPickerView: UIView,UIPickerViewDataSource,UIPickerViewDelegate {

    @IBOutlet weak var yearPickerView: UIPickerView!
    var delegate:YearPickerViewDelegate?
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    class func loadYearPickerView(withText:String) ->  YearPickerView{
        guard let instance = Bundle.main.loadNibNamed("YearPickerView", owner: self)?.first as? YearPickerView else {
            fatalError("Could not instantiate from nib: ExperiencePickerView")
        }
        instance.getPreSelectedValues(dateString: withText, curTag: 1)
        return instance
    }
    
    
    func getPreSelectedValues(dateString:String,curTag:Int)
    {
      //self.currentTag = curTag
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 100
       
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return "\(row)"
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    }

    @IBAction func doneButtonPressed(_ sender: Any) {
    }
    @IBAction func canceButtonPressed(_ sender: Any) {
    }

}

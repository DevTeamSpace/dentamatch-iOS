//
//  ExperiencePickerView.swift
//  DentaMatch
//
//  Created by Sanjay Kumar Yadav on 10/01/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit


protocol ExperiencePickerViewDelegate{
    
    func canceButtonAction()
    func doneButtonAction(year:Int,month:Int)
}
class ExperiencePickerView: UIView,UIPickerViewDataSource,UIPickerViewDelegate {
    
    @IBOutlet weak var yearExperiencePickerView: UIPickerView!
    var delegate: ExperiencePickerViewDelegate?
    
    class func loadExperiencePickerView(withText:String) ->  ExperiencePickerView{
        guard let instance = Bundle.main.loadNibNamed("ExperiencePickerView", owner: self)?.first as? ExperiencePickerView else {
            fatalError("Could not instantiate from nib: ExperiencePickerView")
        }
        instance.getPreSelectedValues(text: withText)
        return instance
    }
    
    func getPreSelectedValues(text:String)
    {
        let component = text.components(separatedBy:NSCharacterSet.decimalDigits.inverted)
        let list = component.filter({ $0 != "" })
        if list.count >= 2
        {
            let firstValue  = Int(list[0])
            let secondValue  = Int(list[1])
            self.yearExperiencePickerView.selectRow(firstValue!, inComponent: 0, animated: true)
            self.yearExperiencePickerView.selectRow(secondValue!, inComponent: 1, animated: true)
        }else if list.count >= 1
        {
            if text.range(of: "year") != nil {
                let firstValue  = Int(list[0])
                self.yearExperiencePickerView.selectRow(firstValue!, inComponent: 0, animated: true)
                
                //debugPrint("year available")
            }else{
                let secondValue  = Int(list[0])
                self.yearExperiencePickerView.selectRow(secondValue!, inComponent: 1, animated: true)
                
                //debugPrint("month available")
            }
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0
        {
            return 31
        }else
        {
            return 12
        }
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return "\(row)"
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //Handle Selection of picker row
    }
    
    @IBAction func cancelButtonClicked(_ sender: Any) {
        
        self.delegate?.canceButtonAction()
    }
    @IBAction func DoneButtonClicked(_ sender: Any) {
        let year  = self.yearExperiencePickerView.selectedRow(inComponent: 0)
        let month  = self.yearExperiencePickerView.selectedRow(inComponent: 1)
        
        self.delegate?.doneButtonAction(year: year, month: month)
        
    }
    
}


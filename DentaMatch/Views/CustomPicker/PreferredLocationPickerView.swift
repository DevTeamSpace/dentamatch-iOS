//
//  PreferredLocationPickerView.swift
//  DentaMatch
//
//  Created by Rajan Maheshwari on 03/11/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

@objc protocol PreferredLocationPickerViewDelegate {
    
    func preferredLocationPickerDoneButtonAction(preferredLocation:PreferredLocation?)
    func preferredLocationPickerCancelButtonAction()
    
}

class PreferredLocationPickerView: UIView,UIPickerViewDataSource,UIPickerViewDelegate {

    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var pickerView: UIPickerView!
    var delegate:PreferredLocationPickerViewDelegate?
    
    var preferredLocations = [PreferredLocation]()

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    class func loadPreferredLocationPickerView(preferredLocations:[PreferredLocation]) ->  PreferredLocationPickerView{
        guard let instance = Bundle.main.loadNibNamed("PreferredLocationPickerView", owner: self)?.first as? PreferredLocationPickerView else {
            fatalError("Could not instantiate from nib: PreferredLocationPickerView")
        }
        instance.setup(preferredLocations: preferredLocations)
        return instance
    }
    
    
    func setup(preferredLocations:[PreferredLocation]) {
        self.preferredLocations = preferredLocations
        self.pickerView.reloadAllComponents()
    }
    
    //MARK:- Picker View Datasource/Delegates
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return preferredLocations.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return preferredLocations[row].preferredLocationName
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // didSelectRow
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        if let delegate = delegate {
            delegate.preferredLocationPickerCancelButtonAction()
        }
    }
    @IBAction func doneButtonPressed(_ sender: Any) {
        if let delegate = delegate {
            if preferredLocations.count > 0 {
                delegate.preferredLocationPickerDoneButtonAction(preferredLocation: preferredLocations[self.pickerView.selectedRow(inComponent: 0)])
            } else {
                delegate.preferredLocationPickerDoneButtonAction(preferredLocation: nil)
            }
        }
    }


    

}

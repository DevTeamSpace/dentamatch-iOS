//
//  JobSelectionPickerView.swift
//  DentaMatch
//
//  Created by Rajan Maheshwari on 09/01/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

@objc protocol JobSelectionPickerViewDelegate {
    
    func numberOfComponents(in jobSelectionPickerView: UIPickerView) -> Int
    func pickerView(_ jobSelectionPickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    func pickerView(_ jobSelectionPickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    func pickerView(_ jobSelectionPickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    
}

class JobSelectionPickerView: UIPickerView,UIPickerViewDataSource,UIPickerViewDelegate {
    
    var selectionDelegate:JobSelectionPickerViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.showsSelectionIndicator = true
        self.dataSource = self
        self.delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK:- Picker View Datasource/Delegates
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        if let pickerView = pickerView as? JobSelectionPickerView {
            if let delegate = selectionDelegate {
                    return delegate.numberOfComponents(in: pickerView)
            }
        }
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if let pickerView = pickerView as? JobSelectionPickerView {
            if let delegate = selectionDelegate {
                return delegate.pickerView(pickerView, numberOfRowsInComponent: component)
            }
        }
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if let pickerView = pickerView as? JobSelectionPickerView {
            if let delegate = selectionDelegate {
                return delegate.pickerView(pickerView, titleForRow: row, forComponent: component)
            }
        }
        return ""
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if let pickerView = pickerView as? JobSelectionPickerView {
            if let delegate = selectionDelegate {
                delegate.pickerView(pickerView, didSelectRow: row, inComponent: component)
            }
        }
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}

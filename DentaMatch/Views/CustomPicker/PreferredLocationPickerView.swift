//
//  PreferredLocationPickerView.swift
//  DentaMatch
//
//  Created by Rajan Maheshwari on 03/11/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

@objc protocol PreferredLocationPickerViewDelegate {
    func preferredLocationPickerDoneButtonAction(preferredLocation: PreferredLocation?)
    func preferredLocationPickerCancelButtonAction()
}

class PreferredLocationPickerView: UIView, UIPickerViewDataSource, UIPickerViewDelegate {
    @IBOutlet var toolBar: UIToolbar!
    @IBOutlet var pickerView: UIPickerView!
    weak var delegate: PreferredLocationPickerViewDelegate?

    var preferredLocations = [PreferredLocation]()

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    class func loadPreferredLocationPickerView(preferredLocations: [PreferredLocation]) -> PreferredLocationPickerView {
        guard let instance = Bundle.main.loadNibNamed("PreferredLocationPickerView", owner: self)?.first as? PreferredLocationPickerView else {
            fatalError("Could not instantiate from nib: PreferredLocationPickerView")
        }
        instance.setup(preferredLocations: preferredLocations)
        return instance
    }

    func setup(preferredLocations: [PreferredLocation]) {
        self.preferredLocations = preferredLocations
        pickerView.reloadAllComponents()
    }

    // MARK: - Picker View Datasource/Delegates

    func numberOfComponents(in _: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_: UIPickerView, numberOfRowsInComponent _: Int) -> Int {
        return preferredLocations.count
    }

    func pickerView(_: UIPickerView, titleForRow row: Int, forComponent _: Int) -> String? {
        return preferredLocations[row].preferredLocationName
    }

    func pickerView(_: UIPickerView, didSelectRow _: Int, inComponent _: Int) {
        // didSelectRow
    }

    @IBAction func cancelButtonPressed(_: Any) {
        if let delegate = delegate {
            delegate.preferredLocationPickerCancelButtonAction()
        }
    }

    @IBAction func doneButtonPressed(_: Any) {
        if let delegate = delegate {
            if preferredLocations.count > 0 {
                delegate.preferredLocationPickerDoneButtonAction(preferredLocation: preferredLocations[self.pickerView.selectedRow(inComponent: 0)])
            } else {
                delegate.preferredLocationPickerDoneButtonAction(preferredLocation: nil)
            }
        }
    }
}

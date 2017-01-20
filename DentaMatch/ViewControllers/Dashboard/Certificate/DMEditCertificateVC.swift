//
//  DMEditCertificateVC.swift
//  DentaMatch
//
//  Created by Rajan Maheshwari on 20/01/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

class DMEditCertificateVC: DMBaseVC,DatePickerViewDelegate {

    @IBOutlet weak var certificateNameLabel: UILabel!
    @IBOutlet weak var certificateImageButton: UIButton!
    @IBOutlet weak var validityDatePicker: PickerAnimatedTextField!
    
    var certificate:Certification?
    var dateView:DatePickerView?

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        // Do any additional setup after loading the view.
    }
    
    func setup() {
        self.dateView = DatePickerView.loadExperiencePickerView(withText:"" , tag: 0)
        self.dateView?.delegate = self
        self.validityDatePicker.text = certificate?.validityDate
        self.validityDatePicker.inputView = dateView
        self.validityDatePicker.tintColor = UIColor.clear
        self.title = "EDIT PROFILE"
        self.changeNavBarAppearanceForDefault()
        self.navigationItem.leftBarButtonItem = self.backBarButton()
        certificateNameLabel.text = certificate?.certificationName
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    @IBAction func certificateImageButtonAction(_ sender: Any) {
    }
    @IBAction func saveButtonPressed(_ sender: Any) {
    }
    
    // MARK :- DatePicker Delegate
    func canceButtonAction() {
        self.view.endEditing(true)
    }
    func doneButtonAction(date: String, tag: Int) {
        self.view.endEditing(true)
        self.validityDatePicker.text = date
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension DMEditCertificateVC : UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        self.dateView?.getPreSelectedValues(dateString: textField.text!, curTag: textField.tag)
        debugPrint("set Tag =\(textField.tag)")
        if let textField = textField as? PickerAnimatedTextField {
            textField.layer.borderColor = Constants.Color.textFieldColorSelected.cgColor
        }
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if let textField = textField as? PickerAnimatedTextField {
            textField.layer.borderColor = Constants.Color.textFieldBorderColor.cgColor
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

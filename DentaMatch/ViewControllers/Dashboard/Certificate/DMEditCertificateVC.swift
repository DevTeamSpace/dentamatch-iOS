//
//  DMEditCertificateVC.swift
//  DentaMatch
//
//  Created by Rajan Maheshwari on 20/01/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit
import SwiftyJSON

class DMEditCertificateVC: DMBaseVC,DatePickerViewDelegate {

    @IBOutlet weak var certificateNameLabel: UILabel!
    @IBOutlet weak var certificateImageButton: UIButton!
    @IBOutlet weak var validityDatePicker: PickerAnimatedTextField!
    
    var certificate:Certification?
    var dateView:DatePickerView?
    var certificateImage:UIImage?
    var isEditMode = false
    var dateSelected = ""

    //MARK:- View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    //MARK:- Private Methods
    func setup() {
        self.certificateImageButton.layer.cornerRadius = self.certificateImageButton.frame.size.width/2
        self.certificateImageButton.clipsToBounds = true
        self.certificateImageButton.imageView?.contentMode = .scaleAspectFill
        
        if let imageUrl =  URL(string: (certificate?.certificateImageURL)!) {
            self.certificateImageButton.sd_setImage(with: imageUrl, for: .normal, placeholderImage: kCertificatePlaceHolder)
        }
        
        self.dateView = DatePickerView.loadExperiencePickerView(withText:"" , tag: 0)
        self.dateView?.delegate = self
        if let date = certificate?.validityDate {
            dateSelected = date
        }
        self.validityDatePicker.text = self.getCertificateDateFormat(dateString: dateSelected)
        
        self.validityDatePicker.inputView = dateView
        self.validityDatePicker.tintColor = UIColor.clear
        self.title = "EDIT PROFILE"
        self.changeNavBarAppearanceForDefault()
        self.navigationItem.leftBarButtonItem = self.backBarButton()
        certificateNameLabel.text = certificate?.certificationName
    }
    
    
    func getCertificateDateFormat(dateString:String) -> String {
        if !dateString.isEmptyField {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat =  Date.dateFormatYYYYMMDDDashed()
            let date = dateFormatter.date(from: dateString)
            dateFormatter.dateFormat = Date.dateFormatDDMMMMYYYY()
            return dateFormatter.string(from: date!)
        }
        return ""
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    @IBAction func certificateImageButtonAction(_ sender: Any) {
        addPhoto()
    }
    
    //MARK:- IBActions
    @IBAction func saveButtonPressed(_ sender: Any) {
        if !(certificate?.certificateImageURL?.isEmptyField)! {
            if !self.validityDatePicker.text!.isEmptyField {
                self.uploadValidityDate { (response:JSON?, error:NSError?) in
                    if let _ = response {
                        self.certificate?.validityDate = self.dateSelected
                        self.updateProfileScreen()
                        _ = self.navigationController?.popViewController(animated: true)
                    }
                }
            } else {
                self.makeToast(toastString: Constants.AlertMessage.emptyValidityDate)
            }
        } else {
            self.makeToast(toastString: "Please upload certificate image first")
        }
    }
    
    func addPhoto() {
        self.cameraGalleryOptionActionSheet(title: "", message: "Please select", leftButtonText: "Camera", rightButtonText: "Gallery") { (isCameraButtonPressed, isGalleryButtonPressed, isCancelButtonPressed) in
            if isCancelButtonPressed {
                //cancel action
            } else if isCameraButtonPressed {
                self.getPhotoFromCamera()
            } else {
                self.getPhotoFromGallery()
            }
        }
    }
    
    func getPhotoFromCamera() {
        CameraGalleryManager.shared.openCamera(viewController: self, allowsEditing: false, completionHandler: { (image:UIImage?, error:NSError?) in
            if error != nil {
                DispatchQueue.main.async {
                    self.makeToast(toastString: (error?.localizedDescription)!)
                }
                return
            }
            self.certificateImage = image
          
            
            DispatchQueue.main.async {
                self.uploadCertificateImage(certObj:self.certificate!, completionHandler: { (response, error) in
                    if let response = response {
                        if response[Constants.ServerKey.status].boolValue {
                            self.certificateImageButton.setImage(image, for: .normal)
                            self.makeToast(toastString: response[Constants.ServerKey.message].stringValue)
                            self.certificate!.certificateImageURL = response[Constants.ServerKey.result][Constants.ServerKey.imageURLForPostResponse].stringValue
                            self.updateProfileScreen()
                        } else {
                            self.makeToast(toastString: response[Constants.ServerKey.message].stringValue)
                        }
                    }
                    
                })
            }
        })
    }
    
    func getPhotoFromGallery() {
        CameraGalleryManager.shared.openGallery(viewController: self, allowsEditing: false, completionHandler: { (image:UIImage?, error:NSError?) in
            if error != nil {
                DispatchQueue.main.async {
                    self.makeToast(toastString: (error?.localizedDescription)!)
                }
                return
            }
            self.certificateImage = image
            
            DispatchQueue.main.async {
                self.uploadCertificateImage(certObj:self.certificate!, completionHandler: { (response, error) in
                    if let response = response {
                        if response[Constants.ServerKey.status].boolValue {
                            self.certificateImageButton.setImage(image, for: .normal)
                            self.makeToast(toastString: response[Constants.ServerKey.message].stringValue)
                            self.certificate!.certificateImageURL = response[Constants.ServerKey.result][Constants.ServerKey.imageURLForPostResponse].stringValue
                            self.updateProfileScreen()
                        } else {
                            self.makeToast(toastString: response[Constants.ServerKey.message].stringValue)
                        }
                    }
                    
                })
            }
        })
        
    }

    
    // MARK :- DatePicker Delegate
    func canceButtonAction() {
        self.view.endEditing(true)
    }
    func doneButtonAction(date: String, tag: Int) {
        self.view.endEditing(true)
        self.dateSelected = date
        self.validityDatePicker.text = self.getCertificateDateFormat(dateString: dateSelected)
    }
    
    func updateProfileScreen() {
        NotificationCenter.default.post(name: .updateProfileScreen, object: nil, userInfo: ["certification":self.certificate!])
    }
}

extension DMEditCertificateVC : UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        self.dateView?.getPreSelectedValues(dateString: dateSelected, curTag: textField.tag)
        //debugPrint("set Tag =\(textField.tag)")
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

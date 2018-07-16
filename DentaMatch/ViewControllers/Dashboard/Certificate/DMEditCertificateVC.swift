//
//  DMEditCertificateVC.swift
//  DentaMatch
//
//  Created by Rajan Maheshwari on 20/01/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import SwiftyJSON
import UIKit

class DMEditCertificateVC: DMBaseVC, DatePickerViewDelegate {
    @IBOutlet var certificateNameLabel: UILabel!
    @IBOutlet var certificateImageButton: UIButton!
    @IBOutlet var validityDatePicker: PickerAnimatedTextField!

    var certificate: Certification?
    var dateView: DatePickerView?
    var certificateImage: UIImage?
    var isEditMode = false
    var dateSelected = ""

    // MARK: - View LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }

    // MARK: - Private Methods

    func setup() {
        certificateImageButton.layer.cornerRadius = certificateImageButton.frame.size.width / 2
        certificateImageButton.clipsToBounds = true
        certificateImageButton.imageView?.contentMode = .scaleAspectFill

        if let imageUrl = URL(string: (certificate?.certificateImageURL)!) {
            certificateImageButton.sd_setImage(with: imageUrl, for: .normal, placeholderImage: kCertificatePlaceHolder)
        }

        dateView = DatePickerView.loadExperiencePickerView(withText: "", tag: 0)
        dateView?.delegate = self
        if let date = certificate?.validityDate {
            dateSelected = date
        }
        validityDatePicker.text = getCertificateDateFormat(dateString: dateSelected)

        validityDatePicker.inputView = dateView
        validityDatePicker.tintColor = UIColor.clear
        title = "EDIT PROFILE"
        changeNavBarAppearanceForDefault()
        navigationItem.leftBarButtonItem = backBarButton()
        certificateNameLabel.text = certificate?.certificationName
    }

    func getCertificateDateFormat(dateString: String) -> String {
        if !dateString.isEmptyField {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = Date.dateFormatYYYYMMDDDashed()
            let date = dateFormatter.date(from: dateString)
            dateFormatter.dateFormat = Date.dateFormatDDMMMMYYYY()
            return dateFormatter.string(from: date!)
        }
        return ""
    }

    override func touchesBegan(_: Set<UITouch>, with _: UIEvent?) {
        view.endEditing(true)
    }

    @IBAction func certificateImageButtonAction(_: Any) {
        addPhoto()
    }

    // MARK: - IBActions

    @IBAction func saveButtonPressed(_: Any) {
        if !(certificate?.certificateImageURL?.isEmptyField)! {
            if !validityDatePicker.text!.isEmptyField {
                uploadValidityDate { (response: JSON?, _: NSError?) in
                    if let _ = response {
                        self.certificate?.validityDate = self.dateSelected
                        self.updateProfileScreen()
                        _ = self.navigationController?.popViewController(animated: true)
                    }
                }
            } else {
                makeToast(toastString: Constants.AlertMessage.emptyValidityDate)
            }
        } else {
            makeToast(toastString: "Please upload certificate image first")
        }
    }

    func addPhoto() {
        cameraGalleryOptionActionSheet(title: "", message: "Please select", leftButtonText: "Camera", rightButtonText: "Gallery") { isCameraButtonPressed, _, isCancelButtonPressed in
            if isCancelButtonPressed {
                // cancel action
            } else if isCameraButtonPressed {
                self.getPhotoFromCamera()
            } else {
                self.getPhotoFromGallery()
            }
        }
    }

    func getPhotoFromCamera() {
        CameraGalleryManager.shared.openCamera(viewController: self, allowsEditing: false, completionHandler: { [weak self](image: UIImage?, error: NSError?) in
            if error != nil {
                DispatchQueue.main.async {
                    self?.makeToast(toastString: (error?.localizedDescription)!)
                }
                return
            }
            self?.certificateImage = image

            DispatchQueue.main.async {
                self?.uploadCertificateImage(certObj: (self?.certificate)!, completionHandler: { response, _ in
                    if let response = response {
                        if response[Constants.ServerKey.status].boolValue {
                            self?.certificateImageButton.setImage(image, for: .normal)
                            self?.makeToast(toastString: response[Constants.ServerKey.message].stringValue)
                            self?.certificate!.certificateImageURL = response[Constants.ServerKey.result][Constants.ServerKey.imageURLForPostResponse].stringValue
                            self?.updateProfileScreen()
                        } else {
                            self?.makeToast(toastString: response[Constants.ServerKey.message].stringValue)
                        }
                    }

                })
            }
        })
    }

    func getPhotoFromGallery() {
        CameraGalleryManager.shared.openGallery(viewController: self, allowsEditing: false, completionHandler: {  [weak self](image: UIImage?, error: NSError?) in
            if error != nil {
                DispatchQueue.main.async {
                    self?.makeToast(toastString: (error?.localizedDescription)!)
                }
                return
            }
            self?.certificateImage = image

            DispatchQueue.main.async {
                self?.uploadCertificateImage(certObj: (self?.certificate)!, completionHandler: { response, _ in
                    if let response = response {
                        if response[Constants.ServerKey.status].boolValue {
                            self?.certificateImageButton.setImage(image, for: .normal)
                            self?.makeToast(toastString: response[Constants.ServerKey.message].stringValue)
                            self?.certificate!.certificateImageURL = response[Constants.ServerKey.result][Constants.ServerKey.imageURLForPostResponse].stringValue
                            self?.updateProfileScreen()
                        } else {
                            self?.makeToast(toastString: response[Constants.ServerKey.message].stringValue)
                        }
                    }

                })
            }
        })
    }

    // MARK: - DatePicker Delegate

    func canceButtonAction() {
        view.endEditing(true)
    }

    func doneButtonAction(date: String, tag _: Int) {
        view.endEditing(true)
        dateSelected = date
        validityDatePicker.text = getCertificateDateFormat(dateString: dateSelected)
    }

    func updateProfileScreen() {
        NotificationCenter.default.post(name: .updateProfileScreen, object: nil, userInfo: ["certification": self.certificate!])
    }
}

extension DMEditCertificateVC: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        dateView?.getPreSelectedValues(dateString: dateSelected, curTag: textField.tag)
        // debugPrint("set Tag =\(textField.tag)")
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

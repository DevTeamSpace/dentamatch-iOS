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
    
    var dateView: DatePickerView?
    
    var viewOutput: DMEditCertificateViewOutput?

    lazy var isEditingResume : Bool = {
        if let certificateName = viewOutput?.certificate?.certificationName, certificateName == "Resume" {
            return true
        }
        return false
    }()
    // MARK: - View LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        
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
        title = "EDIT PROFILE"
        certificateImageButton.layer.cornerRadius = certificateImageButton.frame.size.width / 2
        certificateImageButton.clipsToBounds = true
        certificateImageButton.imageView?.contentMode = .scaleAspectFill

        if let imageUrl = URL(string: viewOutput?.certificate?.certificateImageURL ?? "") {
            certificateImageButton.setImage(for: .normal, url: imageUrl, placeholder: kCertificatePlaceHolder)
        }

        dateView = DatePickerView.loadExperiencePickerView(withText: "", tag: 0)
        dateView?.delegate = self
        if let date = viewOutput?.certificate?.validityDate {
            viewOutput?.dateSelected = date
        }
        validityDatePicker.text = getCertificateDateFormat(dateString: viewOutput?.dateSelected)
        validityDatePicker.inputView = dateView
        validityDatePicker.tintColor = UIColor.clear
        if isEditingResume {
           validityDatePicker.isHidden = true
        }
        changeNavBarAppearanceForDefault()
        navigationItem.leftBarButtonItem = backBarButton()
        certificateNameLabel.text = viewOutput?.certificate?.certificationName
    }

    func getCertificateDateFormat(dateString: String?) -> String {
        guard let dateString = dateString else { return "" }
        if !dateString.isEmptyField && dateString != Constants.kEmptyDate {
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
        if viewOutput?.certificate?.certificateImageURL?.isEmptyField == false {
            if isEditingResume || !validityDatePicker.text!.isEmptyField  {
                viewOutput?.uploadValidityDate()
            }else {
                makeToast(toastString: Constants.AlertMessage.emptyValidityDate)
            }
        } else {
            makeToast(toastString: "Please upload certificate image first")
        }
    }
    
    func addPhoto() {
        cameraGalleryOptionActionSheet(title: "", message: "Please select", leftButtonText: "Take a Photo", rightButtonText: "Choose from Library") { isCameraButtonPressed, _, isCancelButtonPressed in
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
            
            if let image = image {
                self?.viewOutput?.uploadCertificateImage(image)
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
            
            if let image = image {
                self?.viewOutput?.uploadCertificateImage(image)
            }
        })
    }

    // MARK: - DatePicker Delegate

    func canceButtonAction() {
        view.endEditing(true)
    }

    func doneButtonAction(date: String, tag _: Int) {
        view.endEditing(true)
        viewOutput?.dateSelected = date
        validityDatePicker.text = getCertificateDateFormat(dateString: viewOutput?.dateSelected)
    }
}

extension DMEditCertificateVC: DMEditCertificateViewInput {
    
    func configureImageButton(image: UIImage) {
        certificateImageButton.setImage(image, for: .normal)
    }
}

extension DMEditCertificateVC: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        dateView?.getPreSelectedValues(dateString: viewOutput?.dateSelected ?? "", curTag: textField.tag)
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

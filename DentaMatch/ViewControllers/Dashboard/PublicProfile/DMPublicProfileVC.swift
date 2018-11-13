//
//  DMPublicProfileVC.swift
//  DentaMatch
//
//  Created by Rajan Maheshwari on 19/01/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import CoreLocation
import UIKit

class DMPublicProfileVC: DMBaseVC {
    enum ProfileOptions: Int {
        case firstName = 1
        case lastName
        case preferredJobLocation
        case jobTitle
        case license
        case state
    }

    @IBOutlet var publicProfileTableView: UITableView!

    var originalParams = [String: String]()

    var editProfileParams = [
        Constants.ServerKey.firstName: "",
        Constants.ServerKey.lastName: "",
        Constants.ServerKey.preferredJobLocation: "",
        Constants.ServerKey.preferredJobLocationId: "",
        Constants.ServerKey.jobTitileId: "",
        Constants.ServerKey.aboutMe: "",
        Constants.ServerKey.licenseNumber: "",
        Constants.ServerKey.state: "",
    ]

    var profileImage: UIImage?
    var jobSelectionPickerView: JobSelectionPickerView!
    var preferredJobLocationPickerView: PreferredLocationPickerView!
    var jobTitles = [JobTitle]()
    var selectedJob = JobTitle()
    var preferredLocations = [PreferredLocation]()
    var selectedLocation: PreferredLocation!
    // var selectedLocationCoordinate:CLLocationCoordinate2D?
    var licenseString: String?
    var stateString: String?
    var activeField: UITextField?
    var activeView: UITextView?
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        getPreferredLocations()
        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        adjustLicenseAndStateTextFields(job: selectedJob)
    }

    func setup() {
        licenseString = UserManager.shared().activeUser.licenseNumber
        stateString = UserManager.shared().activeUser.state

        editProfileParams[Constants.ServerKey.firstName] = UserManager.shared().activeUser.firstName
        editProfileParams[Constants.ServerKey.lastName] = UserManager.shared().activeUser.lastName
        editProfileParams[Constants.ServerKey.jobTitileId] = String(selectedJob.jobId)
//        editProfileParams[Constants.ServerKey.latitude] = UserManager.shared().activeUser.latitude
//        editProfileParams[Constants.ServerKey.longitude] = UserManager.shared().activeUser.longitude
        editProfileParams[Constants.ServerKey.licenseNumber] = licenseString // UserManager.shared().activeUser.licenseNumber
        editProfileParams[Constants.ServerKey.state] = stateString // UserManager.shared().activeUser.state

        editProfileParams[Constants.ServerKey.preferredJobLocation] = UserManager.shared().activeUser.preferredJobLocation
        editProfileParams[Constants.ServerKey.preferredJobLocationId] = UserManager.shared().activeUser.preferredLocationId

        editProfileParams[Constants.ServerKey.aboutMe] = UserManager.shared().activeUser.aboutMe

        // selectedLocationCoordinate = CLLocationCoordinate2D(latitude: Double(UserManager.shared().activeUser.latitude!)!, longitude: Double(UserManager.shared().activeUser.longitude!)!)
        jobSelectionPickerView = JobSelectionPickerView.loadJobSelectionView(withJobTitles: jobTitles)
        jobSelectionPickerView.delegate = self
        jobSelectionPickerView.pickerView.reloadAllComponents()

        preferredJobLocationPickerView = PreferredLocationPickerView.loadPreferredLocationPickerView(preferredLocations: [])
        preferredJobLocationPickerView.delegate = self
        preferredJobLocationPickerView.pickerView.reloadAllComponents()

        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        publicProfileTableView.addGestureRecognizer(tap)

        title = "EDIT PROFILE"
        navigationItem.leftBarButtonItem = backBarButton()
        publicProfileTableView.rowHeight = UITableViewAutomaticDimension
        publicProfileTableView.estimatedRowHeight = 650
        publicProfileTableView.register(UINib(nibName: "EditPublicProfileTableCell", bundle: nil), forCellReuseIdentifier: "EditPublicProfileTableCell")

        originalParams = editProfileParams
    }

    /* func backButtonAction() {
     if editProfileParams == originalParams {
     print("same")
     } else {
     print("Different")
     }
     }*/

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: - Keyboard Show Hide Observers

    @objc func keyboardWillShow(note: NSNotification) {
        if let kbSize = (note.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            //publicProfileTableView.contentInset = UIEdgeInsetsMake(0, 0, kbSize.height + 1, 0)
            
            let contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0)
            publicProfileTableView.contentInset = contentInsets
            publicProfileTableView.scrollIndicatorInsets = contentInsets;
            
            // If active text field is hidden by keyboard, scroll it so it's visible
            // Your app might not need or want this behavior.
            var aRect = self.publicProfileTableView.frame
           
            if activeField != nil {
                 aRect.size.height -= kbSize.height;
                if (!aRect.contains((activeField?.frame.origin)!) ) {
                    self.publicProfileTableView.scrollRectToVisible(aRect, animated: true)
                }
            }
            if activeView != nil {
                var reducingFactor : CGFloat = 120.0
                if UIDevice.current.screenType == .iPhone5{
                     reducingFactor = 0.0
                }
                if UIDevice.current.screenType == .iPhoneX{
                    reducingFactor = 250.0
                }
                aRect.size.height += kbSize.height - reducingFactor
                //if (!aRect.contains((activeView?.frame.origin)!) ) {
                    self.publicProfileTableView.scrollRectToVisible(aRect, animated: true)
                //}
            }
            
        }
    }

    @objc func keyboardWillHide(note _: NSNotification) {
        publicProfileTableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
    }

    func validateFields() -> Bool {
        if editProfileParams[Constants.ServerKey.firstName]!.isEmptyField {
            makeToast(toastString: Constants.AlertMessage.emptyFirstName)
            return false
        }

        if editProfileParams[Constants.ServerKey.lastName]!.isEmptyField {
            makeToast(toastString: Constants.AlertMessage.emptyLastName)
            return false
        }

        if editProfileParams[Constants.ServerKey.aboutMe]!.isEmptyField {
            makeToast(toastString: Constants.AlertMessage.emptyAboutMe)
            return false
        }

        if !selectedJob.isLicenseRequired {
            editProfileParams[Constants.ServerKey.licenseNumber] = nil
            editProfileParams[Constants.ServerKey.state] = nil
        } else {
            if editProfileParams[Constants.ServerKey.licenseNumber]!.isEmptyField {
                makeToast(toastString: Constants.AlertMessage.emptyLicenseNumber)
                return false
            }
            if editProfileParams[Constants.ServerKey.state]!.isEmptyField {
                makeToast(toastString: Constants.AlertMessage.emptyState)
                return false
            }
        }
        return true
    }

    @IBAction func saveButtonPressed(_: Any) {
        view.endEditing(true)
        if validateFields() {
            // debugPrint("Edit Profile Params\n\(editProfileParams)")
            updatePublicProfileAPI(params: editProfileParams)
        }
    }

    @objc func addPhoto() {
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
            self?.profileImage = image
            self?.uploadProfileImageAPI()
        })
    }

    func getPhotoFromGallery() {
        CameraGalleryManager.shared.openGallery(viewController: self, allowsEditing: false, completionHandler: { [weak self](image: UIImage?, error: NSError?) in
            if error != nil {
                DispatchQueue.main.async {
                    self?.makeToast(toastString: (error?.localizedDescription)!)
                }
                return
            }
            self?.profileImage = image
            self?.uploadProfileImageAPI()
        })
    }

    func openMapsScreen() {
//        let mapVC = UIStoryboard.registrationStoryBoard().instantiateViewController(type: DMRegisterMapsVC.self)!
//        mapVC.delegate = self
//        mapVC.userSelectedCoordinate = selectedLocationCoordinate
//        mapVC.addressSelectedFromProfile = editProfileParams[Constants.ServerKey.preferredJobLocation]!
//        mapVC.fromEditProfile = true
//        self.navigationController?.pushViewController(mapVC, animated: true)
//        self.view.endEditing(true)
    }

    func updateProfileScreen() {
        // NotificationCenter.default.post(name: .updateProfileScreen, object: nil, userInfo: ["license":license!])

        NotificationCenter.default.post(name: .updateProfileScreen, object: nil, userInfo: nil)
    }
    
    func goToStates(_ text: String?) {
        let searchVc = UIStoryboard.statesStoryBoard().instantiateViewController(withIdentifier: "SearchStateViewController") as! SearchStateViewController
        searchVc.delegate = self
        searchVc.preSelectedState = stateString
        self.navigationController?.pushViewController(searchVc, animated: true)
    }
}

extension DMPublicProfileVC: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn _: NSRange, replacementString string: String) -> Bool {
        guard string.count > 0 else {
            return true
        }
        let characterset = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLKMNOPQRSTUVWXYZ")

        let profileOptions = ProfileOptions(rawValue: textField.tag)!
        switch profileOptions {
        case .firstName:

            if string.rangeOfCharacter(from: characterset.inverted) != nil {
                // debugPrint("string contains special characters")
                return false
            }
            if textField.text!.count >= Constants.Limit.commonMaxLimit {
                return false
            }
            return true

        case .lastName:

            if string.rangeOfCharacter(from: characterset.inverted) != nil {
                // debugPrint("string contains special characters")
                return false
            }
            if textField.text!.count >= Constants.Limit.commonMaxLimit {
                return false
            }
            return true

        case .license:
            let characterset = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLKMNOPQRSTUVWXYZ0123456789-")
            if string == "-" && textField.text?.count == 0 {
                makeToast(toastString: Constants.AlertMessage.lienseNoStartError)
                return false
            }

            if string.rangeOfCharacter(from: characterset.inverted) != nil {
                // debugPrint("string contains special characters")
                return false
            }

            if (textField.text?.count)! >= Constants.Limit.licenseNumber { return false
            }
            return true

        case .state:
            let characterset = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLKMNOPQRSTUVWXYZ- ")
            if string == "-" && textField.text?.count == 0 {
                // self.dismissKeyboard()
                makeToast(toastString: Constants.AlertMessage.stateStartError)
                return false
            }
            if string.rangeOfCharacter(from: characterset.inverted) != nil {
                // debugPrint("string contains special characters")
                return false
            }
            if (textField.text?.count)! >= Constants.Limit.commonMaxLimit { return false
            }
            return true

        default:
            return true
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let profileOptions = ProfileOptions(rawValue: textField.tag)!
        switch profileOptions {
        case .firstName:
            if let cell = self.publicProfileTableView.cellForRow(at: IndexPath(row: 0, section: 0)) as?
                EditPublicProfileTableCell {
                cell.lastNameTextField.becomeFirstResponder()
            }
        case .lastName:
            textField.resignFirstResponder()
        default:
            view.endEditing(true)
        }
        return true
    }

    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        activeView = nil
        activeField = textField
        if let textField = textField as? AnimatedPHTextField {
            textField.layer.borderColor = Constants.Color.textFieldColorSelected.cgColor
        }
        return true
    }

    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        textField.text = textField.text!.trim()
        if let textField = textField as? AnimatedPHTextField {
            textField.layer.borderColor = Constants.Color.textFieldBorderColor.cgColor
        }
        return true
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        activeField = nil
        let profileOptions = ProfileOptions(rawValue: textField.tag)!

        switch profileOptions {
        case .firstName:
            editProfileParams[Constants.ServerKey.firstName] = textField.text!
        case .lastName:
            editProfileParams[Constants.ServerKey.lastName] = textField.text!
        case .preferredJobLocation:
            editProfileParams[Constants.ServerKey.preferredJobLocation] = textField.text!
        case .jobTitle:
            editProfileParams[Constants.ServerKey.jobTitle] = textField.text!
        case .state:
            editProfileParams[Constants.ServerKey.state] = textField.text!
        case .license:
            editProfileParams[Constants.ServerKey.licenseNumber] = textField.text!
        }
    }

    func adjustLicenseAndStateTextFields(job: JobTitle) {
        if let cell = self.publicProfileTableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? EditPublicProfileTableCell {
            cell.jobTitleTextField.text = job.jobTitle
            if job.isLicenseRequired {
                cell.stateTextField.isHidden = false
                cell.licenseNumberTextField.isHidden = false
                cell.licenseStateConstraint.constant = 130
                cell.licenseStateTopConstraint.constant = 20
                cell.licenseNumberTextField.text = licenseString
                cell.stateTextField.text = stateString
            } else {
                cell.stateTextField.isHidden = true
                cell.licenseNumberTextField.isHidden = true
                cell.licenseStateConstraint.constant = 0
                cell.licenseStateTopConstraint.constant = 0
            }
            editProfileParams[Constants.ServerKey.jobTitileId] = "\(selectedJob.jobId)"
        }
    }
}

extension DMPublicProfileVC: JobSelectionPickerViewDelegate {
    func jobPickerDoneButtonAction(job: JobTitle?) {
        selectedJob = job!
        if selectedJob.jobTitle != UserManager.shared().activeUser.jobTitle {
            licenseString = nil
            stateString = nil
            editProfileParams[Constants.ServerKey.state] = ""
            editProfileParams[Constants.ServerKey.licenseNumber] = ""
        }

        adjustLicenseAndStateTextFields(job: selectedJob)
        view.endEditing(true)
//        publicProfileTableView.reloadData()
    }

    func jobPickerCancelButtonAction() {
        view.endEditing(true)
    }
}

extension DMPublicProfileVC: PreferredLocationPickerViewDelegate {
    func preferredLocationPickerCancelButtonAction() {
        view.endEditing(true)
    }

    func preferredLocationPickerDoneButtonAction(preferredLocation: PreferredLocation?) {
        editProfileParams[Constants.ServerKey.preferredJobLocationId] = preferredLocation?.id
        if let cell = self.publicProfileTableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? EditPublicProfileTableCell {
            cell.preferredJobLocationTextField.text = preferredLocation?.preferredLocationName
            selectedLocation = preferredLocation
        }
        view.endEditing(true)
    }
}

extension DMPublicProfileVC: SearchStateViewControllerDelegate {
    func selectedState(state: String?) {
        stateString = state
        editProfileParams[Constants.ServerKey.state] = state
        self.publicProfileTableView.reloadData()
    }
}

// MARK: - LocationAddress Delegate

// extension DMPublicProfileVC:LocationAddressDelegate {
//    func locationAddress(location: Location) {
//        //coordinateSelected = location.coordinateSelected
//        if let address = location.address {
//            if let cell = self.publicProfileTableView.cellForRow(at: IndexPath(row: 0, section: 0)) as?
//                EditPublicProfileTableCell {
//                cell.locationTextField.text = address
//                selectedLocationCoordinate = location.coordinateSelected
//                editProfileParams[Constants.ServerKey.latitude] = "\(location.coordinateSelected!.latitude)"
//                editProfileParams[Constants.ServerKey.longitude] = "\(location.coordinateSelected!.longitude)"
//                editProfileParams[Constants.ServerKey.preferredJobLocation] = address
//                editProfileParams["zipcode"] = location.postalCode
//                editProfileParams["preferredCity"] = location.city
//                editProfileParams["preferredState"] = location.state
//                editProfileParams["preferredCountry"] = location.country
//            }
//            //debugPrint(address)
//        } else {
//            //debugPrint("Address is empty")
//        }
//    }
// }

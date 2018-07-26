//
//  DMRegistrationVC.swift
//  DentaMatch
//
//  Created by Rajan Maheshwari on 25/10/16.
//  Copyright © 2016 Appster. All rights reserved.
//

import CoreLocation
import UIKit

class DMRegistrationVC: DMBaseVC {
    @IBOutlet var registrationTableView: UITableView!
    var coordinateSelected: CLLocationCoordinate2D?
    var termsAndConditionsAccepted = false
    var preferredLocations = [PreferredLocation]()
    var selectedPreferredLocation: PreferredLocation?

    var preferredLocationPickerView: PreferredLocationPickerView!
    var registrationParams = [
        Constants.ServerKey.deviceId: "",
        Constants.ServerKey.deviceToken: "",
        Constants.ServerKey.deviceType: "",
        Constants.ServerKey.email: "",
        Constants.ServerKey.firstName: "",
        Constants.ServerKey.lastName: "",
        Constants.ServerKey.password: "",
        Constants.ServerKey.preferredJobLocationId: "",
        // Constants.ServerKey.zipCode:"",
        // Constants.JobDetailKey.city:"",
        // Constants.JobDetailKey.state:"",
        // Constants.JobDetailKey.country:""
        // Constants.ServerKey.latitude:"",
        // Constants.ServerKey.longitude:""
    ]

    // MARK: - View LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        getPreferredLocations()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        registrationTableView.reloadData()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: - Keyboard Show Hide Observers

    @objc func keyboardWillShow(note: NSNotification) {
        if let keyboardSize = (note.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            registrationTableView.contentInset = UIEdgeInsetsMake(0, 0, keyboardSize.height + 1, 0)
        }
    }

    @objc func keyboardWillHide(note _: NSNotification) {
        registrationTableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
    }

    // MARK: - Private Methods

    func setup() {
        preferredLocationPickerView = PreferredLocationPickerView.loadPreferredLocationPickerView(preferredLocations: preferredLocations)
        preferredLocationPickerView.delegate = self
        UserDefaultsManager.sharedInstance.isOnBoardingDone = true
        registrationTableView.register(UINib(nibName: "RegistrationTableViewCell", bundle: nil), forCellReuseIdentifier: "RegistrationTableViewCell")
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        registrationTableView.addGestureRecognizer(tap)
    }

    func validateFields() -> Bool {
        if registrationParams[Constants.ServerKey.firstName]!.isEmpty {
            makeToast(toastString: Constants.AlertMessage.emptyFirstName)
            return false
        }

        if registrationParams[Constants.ServerKey.lastName]!.isEmpty {
            makeToast(toastString: Constants.AlertMessage.emptyLastName)
            return false
        }
        if registrationParams[Constants.ServerKey.email]!.isEmpty {
            makeToast(toastString: Constants.AlertMessage.emptyEmail)
            return false
        }

        if !registrationParams[Constants.ServerKey.email]!.isValidEmail {
            makeToast(toastString: Constants.AlertMessage.invalidEmail)
            return false
        }
        if registrationParams[Constants.ServerKey.password]!.count < Constants.Limit.passwordLimit {
            if registrationParams[Constants.ServerKey.password]!.count == 0 {
                makeToast(toastString: Constants.AlertMessage.emptyPassword)
            } else {
                makeToast(toastString: Constants.AlertMessage.passwordRange)
            }
            return false
        }
        if selectedPreferredLocation == nil {
            makeToast(toastString: Constants.AlertMessage.emptyPreferredJobLocation)
            return false
        }
//        if coordinateSelected == nil {
//            self.makeToast(toastString: Constants.AlertMessage.emptyPreferredJobLocation)
//            return false
//        }
//
//        if registrationParams[Constants.ServerKey.zipCode]!.isEmpty {
//            self.makeToast(toastString: Constants.AlertMessage.emptyPinCode)
//            return false
//        }

        if !termsAndConditionsAccepted {
            makeToast(toastString: Constants.AlertMessage.termsAndConditions)
            return false
        }

        return true
    }

    func openTermsAndConditions(isPrivacyPolicy: Bool) {
        view.endEditing(true)
        let termsVC = UIStoryboard.registrationStoryBoard().instantiateViewController(type: DMTermsAndConditionsVC.self)!
        termsVC.isPrivacyPolicy = isPrivacyPolicy
        navigationController?.pushViewController(termsVC, animated: true)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

    // MARK: - IBActions
    @IBAction func registerButtonPressed(_: Any) {
        dismissKeyboard()
        registrationParams[Constants.ServerKey.deviceId] = Utilities.deviceId()
        registrationParams[Constants.ServerKey.deviceType] = "iOS"
        registrationParams[Constants.ServerKey.deviceToken] = UserDefaultsManager.sharedInstance.deviceToken
        if validateFields() {
            registrationAPI(params: registrationParams)
        }
    }

    @objc func acceptTermsButtonPressed(sender _: UIButton) {
        termsAndConditionsAccepted = termsAndConditionsAccepted ? false : true
        registrationTableView.reloadData()
    }
}

// MARK: - Extensions

extension DMRegistrationVC: UITextViewDelegate {
    func textView(_: UITextView, shouldInteractWith URL: URL, in _: NSRange) -> Bool {
        if URL.absoluteString == "openTermsAndConditions" {
            openTermsAndConditions(isPrivacyPolicy: false)
        } else if URL.absoluteString == "openPrivacyPolicy" {
            openTermsAndConditions(isPrivacyPolicy: true)
        }
        return false
    }

    func textViewDidChangeSelection(_ textView: UITextView) {
        if !NSEqualRanges(textView.selectedRange, NSRange(location: 0, length: 0)) {
            textView.selectedRange = NSRange(location: 0, length: 0)
        }
    }
}

extension DMRegistrationVC: PreferredLocationPickerViewDelegate {
    func preferredLocationPickerCancelButtonAction() {
        view.endEditing(true)
    }

    func preferredLocationPickerDoneButtonAction(preferredLocation: PreferredLocation?) {
        if let cell = self.registrationTableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? RegistrationTableViewCell {
            cell.preferredLocationTextField.text = preferredLocation?.preferredLocationName
            selectedPreferredLocation = preferredLocation
            if let location = selectedPreferredLocation {
                registrationParams[Constants.ServerKey.preferredJobLocationId] = location.id
            }
            view.endEditing(true)
        }
    }
}

// MARK: - LocationAddress Delegate

// extension DMRegistrationVC:LocationAddressDelegate {
//    func locationAddress(location: Location) {
//        coordinateSelected = location.coordinateSelected
//        if let address = location.address {
//            if let cell = self.registrationTableView.cellForRow(at: IndexPath(row: 0, section: 0)) as?
//                RegistrationTableViewCell {
//                cell.preferredLocationTextField.text = address
//
//                registrationParams[Constants.ServerKey.zipCode] = location.postalCode
//                registrationParams[Constants.JobDetailKey.state] = location.state
//                registrationParams[Constants.JobDetailKey.country] = location.country
//                registrationParams[Constants.JobDetailKey.city] = location.city
//
//                registrationParams[Constants.ServerKey.preferredLocation] = address
//                if let _ = coordinateSelected {
//                    registrationParams[Constants.ServerKey.latitude] = "\((coordinateSelected?.latitude)!)"
//                    registrationParams[Constants.ServerKey.longitude] = "\((coordinateSelected?.longitude)!)"
//                }
//
//            }
//            debugPrint(address)
//        } else {
//            debugPrint("Address is empty")
//        }
//    }
// }

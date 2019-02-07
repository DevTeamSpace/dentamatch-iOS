import CoreLocation
import UIKit

enum ProfileOptions: Int {
    case firstName = 1
    case lastName
    case preferredJobLocation
    case jobTitle
    case license
    case state
}

class DMPublicProfileVC: DMBaseVC {
    

    @IBOutlet var publicProfileTableView: UITableView!
    
    var viewOutput: DMPublicProfileViewOutput?
    
    var jobSelectionPickerView: JobSelectionPickerView!
    var preferredJobLocationPickerView: PreferredLocationPickerView!
    var activeField: UITextField?
    var activeView: UITextView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        viewOutput?.didLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        adjustLicenseAndStateTextFields(job: viewOutput?.selectedJob)
    }

    func setup() {
        
        jobSelectionPickerView = JobSelectionPickerView.loadJobSelectionView(withJobTitles: viewOutput?.jobTitles ?? [])
        jobSelectionPickerView.delegate = self
        jobSelectionPickerView.pickerView.reloadAllComponents()

        preferredJobLocationPickerView = PreferredLocationPickerView.loadPreferredLocationPickerView(preferredLocations: [])
        preferredJobLocationPickerView.delegate = self
        preferredJobLocationPickerView.pickerView.reloadAllComponents()

        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        publicProfileTableView.addGestureRecognizer(tap)

        title = "EDIT PROFILE"
        navigationItem.leftBarButtonItem = backBarButton()
        publicProfileTableView.rowHeight = UITableView.automaticDimension
        publicProfileTableView.estimatedRowHeight = 650
        publicProfileTableView.register(UINib(nibName: "EditPublicProfileTableCell", bundle: nil), forCellReuseIdentifier: "EditPublicProfileTableCell")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: true)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
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
        if let kbSize = (note.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            //publicProfileTableView.contentInset = UIEdgeInsetsMake(0, 0, kbSize.height + 1, 0)
            
            let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: kbSize.height, right: 0.0)
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
        publicProfileTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }

    func validateFields() -> Bool {
        return viewOutput?.validateFields() == true
    }

    @IBAction func saveButtonPressed(_: Any) {
        view.endEditing(true)
        
        if validateFields() {
            viewOutput?.updatePublicProfile()
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
            
            if let image = image {
                self?.viewOutput?.uploadProfileImage(image)
            }
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
            
            if let image = image {
                self?.viewOutput?.uploadProfileImage(image)
            }
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
        NotificationCenter.default.post(name: .updateProfileScreen, object: nil, userInfo: nil)
    }
    
    func goToStates(_ text: String?) {
        viewOutput?.openStates(preselectedState: text, delegate: self)
    }
}

extension DMPublicProfileVC: DMPublicProfileViewInput {
    
    func configureLocationPicker(locations: [PreferredLocation]) {
        
        self.preferredJobLocationPickerView.setup(preferredLocations: locations)
        self.preferredJobLocationPickerView.pickerView.reloadAllComponents()
        self.preferredJobLocationPickerView.backgroundColor = UIColor.white
    }
    
    func reloadData() {
        publicProfileTableView.reloadData()
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

        viewOutput?.textFieldDidEndEditins(type: profileOptions, text: textField.text ?? "")
    }

    func adjustLicenseAndStateTextFields(job: JobTitle?) {
        guard let job = job, let viewOutput = viewOutput else { return }
        if let cell = self.publicProfileTableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? EditPublicProfileTableCell {
            cell.jobTitleTextField.text = job.jobTitle
            if job.isLicenseRequired {
                cell.stateTextField.isHidden = false
                cell.licenseNumberTextField.isHidden = false
                cell.licenseStateConstraint.constant = 130
                cell.licenseStateTopConstraint.constant = 20
                cell.licenseNumberTextField.text = viewOutput.licenseString
                cell.stateTextField.text = viewOutput.stateString
            } else {
                cell.stateTextField.isHidden = true
                cell.licenseNumberTextField.isHidden = true
                cell.licenseStateConstraint.constant = 0
                cell.licenseStateTopConstraint.constant = 0
            }
            
            self.viewOutput?.editProfileParams[Constants.ServerKey.jobTitileId] = "\(viewOutput.selectedJob?.jobId ?? -1)"
        }
    }
}

extension DMPublicProfileVC: JobSelectionPickerViewDelegate {
    func jobPickerDoneButtonAction(job: JobTitle?) {
        
        viewOutput?.onPickerDoneButtonTap(job: job)
        adjustLicenseAndStateTextFields(job: viewOutput?.selectedJob)
        view.endEditing(true)
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
        viewOutput?.editProfileParams[Constants.ServerKey.preferredJobLocationId] = preferredLocation?.id
        if let cell = self.publicProfileTableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? EditPublicProfileTableCell {
            cell.preferredJobLocationTextField.text = preferredLocation?.preferredLocationName
            viewOutput?.selectedLocation = preferredLocation
        }
        view.endEditing(true)
    }
}

extension DMPublicProfileVC: SearchStateViewControllerDelegate {
    func selectedState(state: String?) {
        
        viewOutput?.stateString = state
        viewOutput?.editProfileParams[Constants.ServerKey.state] = state
        self.publicProfileTableView.reloadData()
    }
}

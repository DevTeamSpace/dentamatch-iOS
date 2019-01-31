import CoreLocation
import UIKit

class DMRegistrationVC: DMBaseVC {
    @IBOutlet var registrationTableView: UITableView!
    
    var viewOutput: DMRegistrationViewOutput?
    
    var termsAndConditionsAccepted = false

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
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        viewOutput?.didLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        registrationTableView.reloadData()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self)
    }
}

extension DMRegistrationVC: DMRegistrationViewInput {
    
    func configurePickerView() {
        guard let preferredLocations = viewOutput?.preferredLocations else { return }
        
        preferredLocationPickerView.setup(preferredLocations: preferredLocations)
        preferredLocationPickerView.pickerView.reloadAllComponents()
        preferredLocationPickerView.backgroundColor = UIColor.white
    }
}

extension DMRegistrationVC {
    
    @objc func keyboardWillShow(note: NSNotification) {
        if let keyboardSize = (note.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            registrationTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height + 1, right: 0)
        }
    }
    
    @objc func keyboardWillHide(note _: NSNotification) {
        registrationTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func setup() {
        
        if let preferredLocations = viewOutput?.preferredLocations {
            
            preferredLocationPickerView = PreferredLocationPickerView.loadPreferredLocationPickerView(preferredLocations: preferredLocations)
            preferredLocationPickerView.delegate = self
        }
        
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
        
        if viewOutput?.selectedPreferredLocation == nil && viewOutput?.preferredLocations.isEmpty == false {
            makeToast(toastString: Constants.AlertMessage.emptyPreferredJobLocation)
            return false
        }
        
        if !termsAndConditionsAccepted {
            makeToast(toastString: Constants.AlertMessage.termsAndConditions)
            return false
        }
        
        return true
    }
    
    func openTermsAndConditions(isPrivacyPolicy: Bool) {
        view.endEditing(true)
        viewOutput?.openTermsAndConditions(isPrivacyPolicy: isPrivacyPolicy)
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
            viewOutput?.onRegisterButtonTap(params: registrationParams)
        }
    }
    
    @objc func acceptTermsButtonPressed(sender _: UIButton) {
        termsAndConditionsAccepted = termsAndConditionsAccepted ? false : true
        registrationTableView.reloadData()
    }
}

extension DMRegistrationVC: UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - TableView Datasource/Delegates
    
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt _: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RegistrationTableViewCell") as! RegistrationTableViewCell
        cell.emailTextField.delegate = self
        cell.newPasswordTextField.delegate = self
        cell.firstNameTextField.delegate = self
        cell.lastNameTextField.delegate = self
        cell.preferredLocationTextField.delegate = self
        cell.termsAndConditionsTextView.delegate = self
        cell.preferredLocationTextField.inputView = preferredLocationPickerView
        
        if termsAndConditionsAccepted {
            cell.acceptTermsButton.setTitle(Constants.DesignFont.acceptTermsSelected, for: .normal)
            cell.acceptTermsButton.setTitleColor(Constants.Color.textFieldColorSelected, for: .normal)
        } else {
            cell.acceptTermsButton.setTitle(Constants.DesignFont.acceptTermsDeSelected, for: .normal)
            cell.acceptTermsButton.setTitleColor(Constants.Color.textFieldPlaceHolderColor, for: .normal)
        }
        
        cell.acceptTermsButton.addTarget(self, action: #selector(acceptTermsButtonPressed), for: .touchUpInside)
        return cell
    }
    
    func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
        return 520
    }
}

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
        if let cell = registrationTableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? RegistrationTableViewCell {
            
            cell.preferredLocationTextField.text = preferredLocation?.preferredLocationName
            viewOutput?.selectedPreferredLocation = preferredLocation
            
            if let location = preferredLocation {
                registrationParams[Constants.ServerKey.preferredJobLocationId] = location.id
            }
            view.endEditing(true)
        }
    }
}

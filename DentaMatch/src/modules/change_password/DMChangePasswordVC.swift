import UIKit

class DMChangePasswordVC: DMBaseVC {
    @IBOutlet var changePasswordTableView: UITableView!
    var passwordArray: [String] = []
    
    var viewOutput: DMChangePasswordViewOutput?

    override func viewDidLoad() {
        super.viewDidLoad()

        passwordArray = ["", "", ""]
        setup()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        changePasswordTableView.reloadData()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func setup() {
        navigationController?.setNavigationBarHidden(false, animated: true)
        changeNavBarAppearanceForDefault()
        navigationItem.leftBarButtonItem = backBarButton()

        changePasswordTableView.register(UINib(nibName: "ChangePasswordTableCell", bundle: nil), forCellReuseIdentifier: "ChangePasswordTableCell")
        changePasswordTableView.separatorStyle = .none
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        changePasswordTableView.addGestureRecognizer(tap)
        title = Constants.ScreenTitleNames.resetPassword
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

    // MARK: - Keyboard Show Hide Observers

    @objc func keyboardWillShow(note: NSNotification) {
        if let keyboardSize = (note.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            changePasswordTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height + 1, right: 0)
        }
    }

    @objc func keyboardWillHide(note _: NSNotification) {
        changePasswordTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }

    @IBAction func saveButtonClicked(_: Any) {
        if !checkValidation() {
            // some error
            return
        }
        if !matchPassword() {
            // some error
            return
        }
        // do next
        viewOutput?.changePassword(passwords: passwordArray)
    }

    func checkValidation() -> Bool {
        for index in 0 ..< passwordArray.count {
            let text = passwordArray[index]

            switch index {
            case 0:
                if text.isEmptyField {
                    makeToast(toastString: Constants.AlertMessage.emptyOldPassword)
                    return false
                } else if text.count < Constants.Limit.passwordLimit {
                    makeToast(toastString: Constants.AlertMessage.passwordRange)
                    return false
                }
            case 1:
                if text.isEmptyField {
                    makeToast(toastString: Constants.AlertMessage.emptyNewPassword)
                    return false
                } else if text.count < Constants.Limit.passwordLimit {
                    makeToast(toastString: Constants.AlertMessage.passwordRange)
                    return false
                }
            case 2:
                if text.isEmptyField {
                    makeToast(toastString: Constants.AlertMessage.emptyConfirmPassword)
                    return false
                } else if text.count < Constants.Limit.passwordLimit {
                    makeToast(toastString: Constants.AlertMessage.passwordRange)
                    return false
                }

            default:
                break
            }
        }
        return true
    }

    func matchPassword() -> Bool {
        let newPassword = passwordArray[1]
        let ConfirmPassword = passwordArray[2]
        if newPassword == ConfirmPassword {
            return true
        } else {
            makeToast(toastString: Constants.AlertMessage.matchPassword)
        }
        return false
    }
}

extension DMChangePasswordVC: DMChangePasswordViewInput {
    
    
}

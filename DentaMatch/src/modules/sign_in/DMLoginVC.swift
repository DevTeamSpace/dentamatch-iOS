import UIKit

class DMLoginVC: DMBaseVC {
    @IBOutlet var loginTableView: UITableView!

    var loginParams = [
        Constants.ServerKey.deviceId: "",
        Constants.ServerKey.deviceToken: "",
        Constants.ServerKey.deviceType: "",
        Constants.ServerKey.email: "",
        Constants.ServerKey.password: "",
    ]
    
    var viewOutput: DMLoginViewOutput?

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loginTableView.reloadData()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
}

extension DMLoginVC: DMLoginViewInput {
    
    
}

extension DMLoginVC {
    
    // MARK: - Keyboard Show Hide Observers
    
    @objc func keyboardWillShow(note: NSNotification) {
        if let keyboardSize = (note.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            loginTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height + 1, right: 0)
        }
    }
    
    @objc func keyboardWillHide(note _: NSNotification) {
        loginTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    // MARK: - Private Methods
    
    func setup() {
        loginTableView.register(UINib(nibName: "LoginTableViewCell", bundle: nil), forCellReuseIdentifier: "LoginTableViewCell")
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        loginTableView.addGestureRecognizer(tap)
    }
    
    func clearData() {
        if let cell = self.loginTableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? LoginTableViewCell {
            cell.emailTextField.text = ""
            cell.passwordTextField.text = ""
        }
    }
    
    func validateFields() -> Bool {
        if loginParams[Constants.ServerKey.email]!.isValidEmail {
            if !loginParams[Constants.ServerKey.password]!.isEmpty {
                return true
            } else {
                makeToast(toastString: Constants.AlertMessage.emptyPassword)
                return false
            }
        } else {
            makeToast(toastString: Constants.AlertMessage.invalidEmail)
            return false
        }
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    // MARK: - IBActions
    
    @objc func forgotPasswordButtonPressed() {
        view.endEditing(true)
        viewOutput?.openForgotPassword()
    }
    
    @IBAction func loginButtonPressed(_: Any) {
        view.endEditing(true)
        loginParams[Constants.ServerKey.deviceId] = Utilities.deviceId()
        loginParams[Constants.ServerKey.deviceType] = "iOS"
        loginParams[Constants.ServerKey.deviceToken] = UserDefaultsManager.sharedInstance.deviceToken
        if validateFields() {
            viewOutput?.onLoginButtonTap(params: loginParams)
        }
    }
}

extension DMLoginVC: UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - TableView Datasource/Delegates
    
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt _: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LoginTableViewCell") as! LoginTableViewCell
        cell.emailTextField.delegate = self
        cell.passwordTextField.delegate = self
        cell.forgotPasswordButton.addTarget(self, action: #selector(forgotPasswordButtonPressed), for: .touchUpInside)
        return cell
    }
    
    func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
        return loginTableView.frame.size.height
    }
}

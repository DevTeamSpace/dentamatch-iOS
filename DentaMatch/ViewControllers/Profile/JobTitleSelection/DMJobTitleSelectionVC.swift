//
//  DMJobTitleSelectionVC.swift
//  DentaMatch
//
//  Created by Rajan Maheshwari on 30/12/16.
//  Copyright © 2016 Appster. All rights reserved.
//

import UIKit

class DMJobTitleSelectionVC: DMBaseVC, ToolBarButtonDelegate {
    @IBOutlet var jobTitleSelectionTableView: UITableView!
    @IBOutlet var createProfileButton: UIButton!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var prefferedJobLocationLabel: UILabel!
    @IBOutlet var addPhotoButton: UIButton!
    @IBOutlet var profileButton: ProfileImageButton!

    @IBOutlet var profileHeaderView: UIView!

    var aboutMe = ""
    var profileImage: UIImage?
    var jobSelectionPickerView: JobSelectionPickerView!
    var jobTitles = [JobTitle]()
    var selectedJobTitle: JobTitle?
    var licenseNumber = ""
    var state = ""

    // MARK: - View LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        getJobsAPI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: - Keyboard Show Hide Observers

    @objc func keyboardWillShow(note: NSNotification) {
        if let keyboardSize = (note.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            jobTitleSelectionTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height + 1, right: 0)
        }
    }

    @objc func keyboardWillHide(note _: NSNotification) {
        jobTitleSelectionTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }

    @objc func makeTip() {
        UIView.makeTip(view: profileHeaderView, size: 8, x: profileHeaderView.frame.midX / 2, y: profileHeaderView.frame.midY)
    }

    // MARK: - Private Methods

    func setup() {
        /*let headerView = TitleHeaderView.loadTitleHeaderView()
        headerView.frame = CGRect(x: 0, y: 0, width: Utilities.ScreenSize.SCREEN_WIDTH, height: 54)
        jobTitleSelectionTableView.tableHeaderView = headerView*/

        jobTitleSelectionTableView.register(UINib(nibName: "AnimatedPHToolTipCell", bundle: nil), forCellReuseIdentifier: "AnimatedPHToolTipCell")
        jobTitleSelectionTableView.register(UINib(nibName: "AboutMeJobSelectionCell", bundle: nil), forCellReuseIdentifier: "AboutMeJobSelectionCell")
        nameLabel.text = "Hi " + UserManager.shared().activeUser.firstName!
        prefferedJobLocationLabel.text = UserManager.shared().activeUser.preferredJobLocation
        addJobSelectionPickerViewTextField()
        profileButton.isUserInteractionEnabled = false

        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        jobTitleSelectionTableView.addGestureRecognizer(tap)
        changeUIOFCreateProfileButton(isCreateProfileButtonEnable())
        perform(#selector(makeTip), with: nil, afterDelay: 0.2)
    }

    @objc func dismissKeyboard() {
        changeUIOFCreateProfileButton(isCreateProfileButtonEnable())
        view.endEditing(true)
    }

    func addToolBarOnTextView() -> UIToolbar {
        let keyboardDoneButtonView = UIToolbar()
        keyboardDoneButtonView.sizeToFit()
        keyboardDoneButtonView.barTintColor = Constants.Color.toolBarColor
        // Setup the buttons to be put in the system.
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: self, action: nil)

        let item = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(toolBarButtonTapped))
        item.tag = 2
        item.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.fontRegular(fontSize: 20.0)], for: UIControl.State.normal)

        item.tintColor = UIColor.white

        let toolbarButtons = [flexibleSpace, item]

        // Put the buttons into the ToolBar and display the tool bar
        keyboardDoneButtonView.setItems(toolbarButtons, animated: false)

        return keyboardDoneButtonView
    }

    func addJobSelectionPickerViewTextField() {
        // Job Title Picker
        jobSelectionPickerView = JobSelectionPickerView.loadJobSelectionView(withJobTitles: [])
        jobSelectionPickerView.delegate = self
    }

    func validateFields() -> Bool {
        if selectedJobTitle == nil {
            makeToast(toastString: "Please select job title")
            return false
        }
        if selectedJobTitle!.isLicenseRequired {
            if licenseNumber.count == 0 {
                makeToast(toastString: "Please fill license number")
                return false
            }
            if state.count == 0 {
                makeToast(toastString: "Please fill state")
                return false
            }
        }
        if aboutMe.trim().count > 0 {
            return true
        } else {
            makeToast(toastString: "Please fill about me section")
            return false
        }
    }

    func isCreateProfileButtonEnable() -> Bool {
        if selectedJobTitle == nil {
            return false
        }
        if selectedJobTitle!.isLicenseRequired {
            if licenseNumber.count == 0 {
                return false
            }
            if state.count == 0 {
                return false
            }
        }
        if aboutMe.trim().count > 0 {
            return true
        } else {
            return false
        }
    }

    func changeUIOFCreateProfileButton(_ isEnable: Bool) {
        if isEnable {
            createProfileButton.setTitleColor(UIColor.white, for: .normal)

        } else {
            let bgcolor = UIColor(red: CGFloat(255.0) / 255.0, green: CGFloat(255.0) / 255.0, blue: CGFloat(255.0) / 255.0, alpha: 0.5)
            createProfileButton.setTitleColor(bgcolor, for: .normal)
        }
    }

    @objc func toolBarButtonTapped() {
        changeUIOFCreateProfileButton(isCreateProfileButtonEnable())
        view.endEditing(true)
    }

    override func touchesBegan(_: Set<UITouch>, with _: UIEvent?) {
        changeUIOFCreateProfileButton(isCreateProfileButtonEnable())
        view.endEditing(true)
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
        CameraGalleryManager.shared.openCamera(viewController: self, allowsEditing: false, completionHandler: {  [weak self](image: UIImage?, error: NSError?) in
            if error != nil {
                DispatchQueue.main.async {
                    self?.makeToast(toastString: (error?.localizedDescription)!)
                }
                return
            }
            self?.profileImage = image
            DispatchQueue.main.async {
                self?.profileButton.setImage(image, for: .normal)
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
            self?.profileImage = image
            DispatchQueue.main.async {
                self?.profileButton.setImage(image, for: .normal)
            }
        })
    }

    // MARK: - IBActions

    @IBAction func addPhotoButtonPressed(_: Any) {
        addPhoto()
    }

    @IBAction func profileButtonPressed(_: Any) {
        // profile button action
    }

    @IBAction func nextButtonPressed(_: Any) {
        if profileImage != nil {
            if selectedJobTitle != nil {
                // openLicenseScreen()
                // uploadProfileImageAPI()
            } else {
                makeToast(toastString: Constants.AlertMessage.emptyCurrentJobTitle)
            }
        } else {
            makeToast(toastString: "Please select profile image")
        }
    }

    func openLicenseScreen() {
        performSegue(withIdentifier: Constants.StoryBoard.SegueIdentifier.goToLicense, sender: self)
    }

    func openDashboard() {
        let dashboardVC = UIStoryboard.dashBoardStoryBoard().instantiateViewController(type: TabBarVC.self)!
        kAppDelegate?.window?.rootViewController = dashboardVC
        UserDefaultsManager.sharedInstance.isProfileSkipped = true
    }

    override func prepare(for segue: UIStoryboardSegue, sender _: Any?) {
        if segue.identifier == Constants.StoryBoard.SegueIdentifier.goToLicense {
            guard let destinationVC: DMLicenseSelectionVC = segue.destination as? DMLicenseSelectionVC else {return}
            destinationVC.jobTitles = jobTitles
            destinationVC.selectedJobTitle = selectedJobTitle
        }
    }

    @IBAction func createProfileButtonPressed(_: Any) {
        if validateFields() {
            var params = [
                "jobTitleId": selectedJobTitle!.jobId,
                "aboutMe": aboutMe,
            ] as [String: Any]
            if selectedJobTitle!.isLicenseRequired {
                params["license"] = licenseNumber
                params["state"] = state
            }
            if profileImage != nil {
                uploadProfileImageAPI(textParams: params)
            } else {
                updateLicenseDetails(params: params)
            }
        }
    }

    // MARK: - ToolBarButton Delegate

    func toolBarButtonPressed(position _: Position) {
        changeUIOFCreateProfileButton(isCreateProfileButtonEnable())
        view.endEditing(true)
    }
    
    func goToStates(_ text: String?) {
        let searchVc = UIStoryboard.statesStoryBoard().instantiateViewController(withIdentifier: "SearchStateViewController") as! SearchStateViewController
        searchVc.delegate = self
        searchVc.preSelectedState = self.state
        self.navigationController?.pushViewController(searchVc, animated: true)
    }
}

extension DMJobTitleSelectionVC: SearchStateViewControllerDelegate {
    func selectedState(state: String?) {
        guard let text = state else {return}
          self.state = text
        //editProfileParams[Constants.ServerKey.state] = state
        self.jobTitleSelectionTableView.reloadData()
    }
}

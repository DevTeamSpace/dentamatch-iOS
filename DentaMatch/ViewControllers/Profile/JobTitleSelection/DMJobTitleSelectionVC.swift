//
//  DMJobTitleSelectionVC.swift
//  DentaMatch
//
//  Created by Rajan Maheshwari on 30/12/16.
//  Copyright © 2016 Appster. All rights reserved.
//

import UIKit

class DMJobTitleSelectionVC: DMBaseVC,ToolBarButtonDelegate {

    @IBOutlet weak var jobTitleSelectionTableView: UITableView!
    @IBOutlet weak var createProfileButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var prefferedJobLocationLabel: UILabel!
    @IBOutlet weak var addPhotoButton: UIButton!
    @IBOutlet weak var profileButton: ProfileImageButton!
//    @IBOutlet weak var currentJobTitleTextField: AnimatedPHTextField!
    @IBOutlet weak var profileHeaderView: UIView!
    
    var aboutMe = ""
    var profileImage:UIImage?
    var jobSelectionPickerView:JobSelectionPickerView!
    var jobTitles = [JobTitle]()
    var selectedJobTitle:JobTitle?
    var licenseNumber = ""
    var state = ""
    
    //MARK:- View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        self.getJobsAPI()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //jobSelectionView?.frame = self.currentJobTitleTextField.frame
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    //MARK:- Keyboard Show Hide Observers
    @objc func keyboardWillShow(note: NSNotification) {
        if let keyboardSize = (note.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            jobTitleSelectionTableView.contentInset =  UIEdgeInsetsMake(0, 0, keyboardSize.height+1, 0)
        }
    }
    
    @objc func keyboardWillHide(note: NSNotification) {
        jobTitleSelectionTableView.contentInset =  UIEdgeInsetsMake(0, 0, 0, 0)
    }
    
    @objc func makeTip() {
        UIView.makeTip(view: profileHeaderView, size: 8, x: profileHeaderView.frame.midX/2, y: profileHeaderView.frame.midY)
    }
    
    //MARK:- Private Methods
    func setup() {
        let headerView = TitleHeaderView.loadTitleHeaderView()
        headerView.frame = CGRect(x: 0, y: 0, width: Utilities.ScreenSize.SCREEN_WIDTH, height: 54)
        self.jobTitleSelectionTableView.tableHeaderView = headerView
        
        self.jobTitleSelectionTableView.register(UINib(nibName: "AnimatedPHTableCell", bundle: nil), forCellReuseIdentifier: "AnimatedPHTableCell")
        self.jobTitleSelectionTableView.register(UINib(nibName: "AboutMeJobSelectionCell", bundle: nil), forCellReuseIdentifier: "AboutMeJobSelectionCell")

        //currentJobTitleTextField.tintColor = UIColor.clear
        self.nameLabel.text = "Hi " + UserManager.shared().activeUser.firstName! + " " + UserManager.shared().activeUser.lastName!
        self.prefferedJobLocationLabel.text = UserManager.shared().activeUser.preferredJobLocation
        self.addJobSelectionPickerViewTextField()
        //currentJobTitleTextField.type = 1
        self.profileButton.isUserInteractionEnabled = false
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.jobTitleSelectionTableView.addGestureRecognizer(tap)
        self.changeUIOFCreateProfileButton(self.isCreateProfileButtonEnable())
        //Right View for drop down
//        let rightView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: currentJobTitleTextField.frame.size.height))
//        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 40, height: currentJobTitleTextField.frame.size.height))
//        label.font = UIFont.designFont(fontSize: 16.0)
//        label.text = "c"
//        label.textColor = UIColor.color(withHexCode: "a0a0a0")
//        label.textAlignment = .center
//        label.center = rightView.center
//        rightView.addSubview(label)
//        currentJobTitleTextField.rightView = rightView
//        currentJobTitleTextField.rightViewMode = .always
//        currentJobTitleTextField.rightView?.isUserInteractionEnabled = false
        self.perform(#selector(makeTip), with: nil, afterDelay: 0.2)
    }
    
    @objc func dismissKeyboard() {
        self.changeUIOFCreateProfileButton(self.isCreateProfileButtonEnable())
        self.view.endEditing(true)
    }
    
    func addToolBarOnTextView() -> UIToolbar {
        let keyboardDoneButtonView = UIToolbar()
        keyboardDoneButtonView.sizeToFit()
        keyboardDoneButtonView.barTintColor = Constants.Color.toolBarColor
        // Setup the buttons to be put in the system.
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: self, action: nil)
        
        let item = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(toolBarButtonTapped))
        item.tag = 2
        item.setTitleTextAttributes([NSAttributedStringKey.font: UIFont.fontRegular(fontSize: 20.0)!], for: UIControlState.normal)
        
        item.tintColor = UIColor.white
        
        let toolbarButtons = [flexibleSpace,item]
        
        //Put the buttons into the ToolBar and display the tool bar
        keyboardDoneButtonView.setItems(toolbarButtons, animated: false)
        
        return keyboardDoneButtonView
    }
    
    func addJobSelectionPickerViewTextField(){
        //Job Title Picker
        jobSelectionPickerView = JobSelectionPickerView.loadJobSelectionView(withJobTitles: [])
//        currentJobTitleTextField.inputView = jobSelectionPickerView
        jobSelectionPickerView.delegate = self
    }
    
    func validateFields() -> Bool {
        if selectedJobTitle == nil {
            self.makeToast(toastString: "Please select job title")
            return false
        }
        if selectedJobTitle!.isLicenseRequired {
            if licenseNumber.count == 0 {
                self.makeToast(toastString: "Please fill license number")
                return false
            }
            if state.count == 0 {
                self.makeToast(toastString: "Please fill state")
                return false
            }
        }
        if aboutMe.trim().count > 0 {
            return true
        } else {
            self.makeToast(toastString: "Please fill about me section")
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
            self.createProfileButton.setTitleColor(UIColor.white, for: .normal)
            
        } else {
            let bgcolor =  UIColor(red: CGFloat(255.0)/255.0, green: CGFloat(255.0)/255.0, blue: CGFloat(255.0)/255.0, alpha: 0.5)
            self.createProfileButton.setTitleColor(bgcolor, for: .normal)
        }
    }
    
    @objc func toolBarButtonTapped() {
        self.changeUIOFCreateProfileButton(self.isCreateProfileButtonEnable())
        self.view.endEditing(true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.changeUIOFCreateProfileButton(self.isCreateProfileButtonEnable())
        self.view.endEditing(true)
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
            self.profileImage = image
            DispatchQueue.main.async {
                self.profileButton.setImage(image, for: .normal)
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
            self.profileImage = image
            DispatchQueue.main.async {
                self.profileButton.setImage(image, for: .normal)
            }
        })

    }
    
    //MARK:- IBActions
    
    @IBAction func addPhotoButtonPressed(_ sender: Any) {
        addPhoto()
    }
    
    @IBAction func profileButtonPressed(_ sender: Any) {
        //profile button action
    }
    
    @IBAction func nextButtonPressed(_ sender: Any) {
        if profileImage != nil {
            if selectedJobTitle != nil {
                //openLicenseScreen()
                uploadProfileImageAPI()
            } else {
                self.makeToast(toastString: Constants.AlertMessage.emptyCurrentJobTitle)
            }
        } else{
            self.makeToast(toastString: "Please select profile image")
        }
    }
    
    func openLicenseScreen() {
        self.performSegue(withIdentifier: Constants.StoryBoard.SegueIdentifier.goToLicense, sender: self)
    }
    
    func openDashboard() {
        let dashboardVC = UIStoryboard.dashBoardStoryBoard().instantiateViewController(type: TabBarVC.self)!
        kAppDelegate.window?.rootViewController = dashboardVC
        UserDefaultsManager.sharedInstance.isProfileSkipped = true

//        UIView.transition(with: self.view.window!, duration: 0.5, options: .transitionCrossDissolve, animations: {
//            kAppDelegate.window?.rootViewController = dashboardVC
//        }) { (bool:Bool) in
//            
//        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.StoryBoard.SegueIdentifier.goToLicense {
            let destinationVC:DMLicenseSelectionVC = segue.destination as! DMLicenseSelectionVC
            destinationVC.jobTitles = self.jobTitles
            destinationVC.selectedJobTitle = self.selectedJobTitle
        }
    }
    
    
    @IBAction func createProfileButtonPressed(_ sender: Any) {
        if validateFields() {
            var params = [
                "jobTitleId":selectedJobTitle!.jobId,
                "aboutMe":aboutMe
                ] as [String : Any]
            if selectedJobTitle!.isLicenseRequired {
                params["license"] = licenseNumber
                params["state"] = state
            }
            self.updateLicenseDetails(params: params)
    }
//        self.alertMessage(title: "", message: Constants.AlertMessage.skipProfile, leftButtonText: "Cancel", rightButtonText: kOkButtonTitle) { (isLeftButtonPressed:Bool) in
//            if !isLeftButtonPressed {
//                DispatchQueue.main.async {
//                    UserDefaultsManager.sharedInstance.isProfileSkipped = true
//                    if UserDefaultsManager.sharedInstance.loadSearchParameter() == nil {
//                        kAppDelegate.goToSearch()
//                    }else {
//                        self.openDashboard()
//                    }
//                }
//            } else {
//               //Remain here
//            }
//        }
    }
    
    //MARK:- ToolBarButton Delegate
    func toolBarButtonPressed(position: Position) {
        self.changeUIOFCreateProfileButton(self.isCreateProfileButtonEnable())
        self.view.endEditing(true)
    }
    
    //MARK:- UITextFieldDelegates
//    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
//        debugPrint("Open Picker")
//        //currentJobTitleTextField.layer.borderColor = Constants.Color.textFieldColorSelected.cgColor
//        return true
//    }
//    
//    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
//        //currentJobTitleTextField.layer.borderColor = Constants.Color.textFieldBorderColor.cgColor
//        return true
//    }
}

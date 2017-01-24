//
//  DMJobTitleSelectionVC.swift
//  DentaMatch
//
//  Created by Rajan Maheshwari on 30/12/16.
//  Copyright © 2016 Appster. All rights reserved.
//

import UIKit

class DMJobTitleSelectionVC: DMBaseVC,UITextFieldDelegate,ToolBarButtonDelegate {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addPhotoButton: UIButton!
    @IBOutlet weak var profileButton: ProfileImageButton!
    @IBOutlet weak var notNowButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var currentJobTitleTextField: AnimatedPHTextField!
    @IBOutlet weak var profileHeaderView: UIView!
    
    var profileImage:UIImage?
    var jobSelectionPickerView:JobSelectionPickerView!
    var jobTitles = [JobTitle]()
    var selectedJobTitle:JobTitle?
    
    //MARK:- View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        self.getJobsAPI()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //jobSelectionView?.frame = self.currentJobTitleTextField.frame
    }
    
    func makeTip() {
        UIView.makeTip(view: profileHeaderView, size: 8, x: profileHeaderView.frame.midX/2, y: profileHeaderView.frame.midY)
    }
    
    //MARK:- Private Methods
    func setup() {
        currentJobTitleTextField.tintColor = UIColor.clear
        self.nameLabel.text = "Hi \(UserManager.shared().activeUser.firstName!)"
        self.addJobSelectionPickerViewTextField()
        currentJobTitleTextField.type = 1
        self.profileButton.isUserInteractionEnabled = false
        self.perform(#selector(makeTip), with: nil, afterDelay: 0.2)
    }
    
    func addJobSelectionPickerViewTextField(){
        //Job Title Picker
        jobSelectionPickerView = JobSelectionPickerView.loadJobSelectionView(withJobTitles: [])
        currentJobTitleTextField.inputView = jobSelectionPickerView
        jobSelectionPickerView.delegate = self
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
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
        
//        //For testing
        //openLicenseScreen()
    }
    
    func openLicenseScreen() {
        self.performSegue(withIdentifier: Constants.StoryBoard.SegueIdentifier.goToLicense, sender: self)
    }
    
    func openDashboard() {
        let dashboardVC = UIStoryboard.dashBoardStoryBoard().instantiateViewController(type: TabBarVC.self)!
        kAppDelegate.window?.rootViewController = dashboardVC

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
    
    
    @IBAction func notNowButtonPressed(_ sender: Any) {
        self.alertMessage(title: "", message: Constants.AlertMessage.skipProfile, leftButtonText: "Cancel", rightButtonText: kOkButtonTitle) { (isLeftButtonPressed:Bool) in
            if !isLeftButtonPressed {
                DispatchQueue.main.async {
                    self.openDashboard()
                }
            } else {
               //Remain here
            }
        }
    }
    
    //MARK:- ToolBarButton Delegate
    func toolBarButtonPressed(position: Position) {
        self.view.endEditing(true)
    }
    
    //MARK:- UITextFieldDelegates
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        debugPrint("Open Picker")
        currentJobTitleTextField.layer.borderColor = Constants.Color.textFieldColorSelected.cgColor
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        currentJobTitleTextField.layer.borderColor = Constants.Color.textFieldBorderColor.cgColor
        return true
    }
}

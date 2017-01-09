//
//  DMJobTitleSelectionVC.swift
//  DentaMatch
//
//  Created by Rajan Maheshwari on 30/12/16.
//  Copyright © 2016 Appster. All rights reserved.
//

import UIKit

class DMJobTitleSelectionVC: DMBaseVC,UITextFieldDelegate,ToolBarButtonDelegate {

    @IBOutlet weak var addPhotoButton: UIButton!
    @IBOutlet weak var profileButton: ProfileImageButton!
    @IBOutlet weak var notNowButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var currentJobTitleTextField: AnimatedPHTextField!
    @IBOutlet weak var profileHeaderView: UIView!
    
    var profileImage:UIImage?
    var jobSelectionPickerTextField:UITextField!
    var jobSelectionPickerView:JobSelectionPickerView!
    
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
    
    //MARK:- Private Methods
    func setup() {
        self.addJobSelectionPickerView()
        currentJobTitleTextField.isUserInteractionEnabled = false
        let jobSelectionView = UIView(frame: self.currentJobTitleTextField.frame)
        self.view.addSubview(jobSelectionView)
        jobSelectionView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(openJobSelectionPicker))
        jobSelectionView.addGestureRecognizer(tap)
        self.profileButton.isUserInteractionEnabled = false
        UIView.makeTip(view: profileHeaderView, size: 8, x: profileHeaderView.frame.midX/2, y: profileHeaderView.frame.midY)
    }
    
    func openJobSelectionPicker() {
        self.jobSelectionPickerTextField.becomeFirstResponder()
    }
    
    func addJobSelectionPickerView(){
        if(jobSelectionPickerTextField != nil){
            jobSelectionPickerTextField.removeFromSuperview()
        }
        jobSelectionPickerTextField = UITextField(frame: CGRect.zero)
        self.view.addSubview(jobSelectionPickerTextField)
        jobSelectionPickerView = JobSelectionPickerView(frame: CGRect(x: 0, y: 0, width: 0, height: 200))
        jobSelectionPickerView.selectionDelegate = self
        jobSelectionPickerTextField.inputView = jobSelectionPickerView
        jobSelectionPickerTextField.spellCheckingType = .no
        jobSelectionPickerTextField.autocorrectionType = .no
        jobSelectionPickerTextField.delegate = self
        jobSelectionPickerView.backgroundColor = UIColor.white
        jobSelectionPickerTextField.addRightToolBarButton(title: "Done")
        jobSelectionPickerView.reloadAllComponents()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    func addPhoto() {
        self.cameraGalleryOptionActionSheet(title: "", message: "Please select", leftButtonText: "Camera", rightButtonText: "Gallery") { (isCameraButtonPressed, isGalleryButtonPressed, isCancelButtonPressed) in
            if isCancelButtonPressed {
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
    }
    
    @IBAction func nextButtonPressed(_ sender: Any) {
        let licenceSelectionVC = UIStoryboard.profileStoryBoard().instantiateViewController(type: DMLicenseSelectionVC.self)!
        self.navigationController?.pushViewController(licenceSelectionVC, animated: true)
    }
    
    @IBAction func notNowButtonPressed(_ sender: Any) {
        self.alertMessage(title: "", message: Constants.AlertMessage.skipProfile, leftButtonText: "Cancel", rightButtonText: kOkButtonTitle) { (isLeftButtonPressed:Bool) in
            if !isLeftButtonPressed {
                print("Skip Profile")
            }
        }
    }
    
    func toolBarButtonPressed(position: Position) {
        self.view.endEditing(true)
    }
    
    //MARK:- UITextFieldDelegates
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        debugPrint("Open Picker")
        return true
    }
}

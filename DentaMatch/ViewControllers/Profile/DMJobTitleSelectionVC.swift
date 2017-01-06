//
//  DMJobTitleSelectionVC.swift
//  DentaMatch
//
//  Created by Rajan Maheshwari on 30/12/16.
//  Copyright © 2016 Appster. All rights reserved.
//

import UIKit

class DMJobTitleSelectionVC: DMBaseVC,UITextFieldDelegate {

    @IBOutlet weak var addPhotoButton: UIButton!
    @IBOutlet weak var profileButton: ProfileImageButton!
    @IBOutlet weak var notNowButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var currentJobTitleTextField: AnimatedPHTextField!
    @IBOutlet weak var profileHeaderView: UIView!
    
    var profileImage:UIImage?
    
    //MARK:- View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    //MARK:- Private Methods
    func setup() {
        self.profileButton.isUserInteractionEnabled = false
        UIView.makeTip(view: profileHeaderView, size: 8, x: profileHeaderView.frame.midX/2, y: profileHeaderView.frame.midY)
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
        self.alertMessage(title: "", message: Constants.AlertMessages.skipProfile, leftButtonText: "Cancel", rightButtonText: kOkButtonTitle) { (isLeftButtonPressed:Bool) in
            if !isLeftButtonPressed {
                print("Skip Profile")
            }
        }
    }
    
    //MARK:- UITextFieldDelegates
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        // TODO: Picker
        debugPrint("Open Picker")
        return false
    }
}

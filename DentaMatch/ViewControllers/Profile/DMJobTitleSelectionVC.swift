//
//  DMJobTitleSelectionVC.swift
//  DentaMatch
//
//  Created by Rajan Maheshwari on 30/12/16.
//  Copyright © 2016 Appster. All rights reserved.
//

import UIKit

class DMJobTitleSelectionVC: DMBaseVC,UITextFieldDelegate {

    @IBOutlet weak var profileButton: UIButton!
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
    
    //MARK:- Private Methods
    func setup() {
        UIView.makeTip(view: profileHeaderView, size: 8, x: profileHeaderView.frame.midX/2, y: profileHeaderView.frame.midY)
        let leftView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: self.currentJobTitleTextField.frame.size.height))
        currentJobTitleTextField.leftView = leftView
        self.profileButton.layer.cornerRadius = self.profileButton.frame.size.width/2
        self.profileButton.clipsToBounds = true
        self.profileButton.imageView?.contentMode = .scaleAspectFill
    }
    
    //MARK:- IBActions
    @IBAction func profileButtonPressed(_ sender: Any) {
        self.cameraGalleryOptionActionSheet(title: "", message: "Please select", leftButtonText: "Camera", rightButtonText: "Gallery") { (isCameraButtonPressed, isGalleryButtonPressed, isCancelButtonPressed) in
            if isCancelButtonPressed {
            } else if isCameraButtonPressed {
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
            } else {
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
        }
    }
    
    @IBAction func nextButtonPressed(_ sender: Any) {
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

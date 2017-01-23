//
//  DMEditDentalStateBoardVC.swift
//  DentaMatch
//
//  Created by Rajan Maheshwari on 24/01/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

class DMEditDentalStateBoardVC: DMBaseVC {

    @IBOutlet weak var dentalStateBoardImageButton: UIButton!
    var dentalStateBoardImage:UIImage?
    var dentalStateBoardImageURL = ""
    var isEditMode = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }

    func setup() {
        self.title = "EDIT PROFILE"
        self.changeNavBarAppearanceForDefault()
        self.navigationItem.leftBarButtonItem = self.backBarButton()
        self.dentalStateBoardImageButton.imageView?.contentMode = .scaleAspectFill
        dentalStateBoardImageButton.layer.cornerRadius = self.dentalStateBoardImageButton.frame.size.width/2
        dentalStateBoardImageButton.clipsToBounds = true
        dentalStateBoardImageButton.sd_setImage(with: URL(string:self.dentalStateBoardImageURL)!, for: .normal)
    }
    
    @IBAction func dentalStateBoardImageButtonPressed(_ sender: Any) {
        addPhoto()
    }
    @IBAction func saveButtonPressed(_ sender: Any) {
        self.uploadDentalStateboardImage()
    }
    
    func updateProfileScreen() {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateProfileScreen"), object: nil, userInfo: ["dentalStateBoardImageURL":dentalStateBoardImageURL])
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
            self.dentalStateBoardImage = image
            DispatchQueue.main.async {
                self.dentalStateBoardImageButton.setImage(self.dentalStateBoardImage, for: .normal)
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
            self.dentalStateBoardImage = image
            
            DispatchQueue.main.async {
                self.dentalStateBoardImageButton.setImage(self.dentalStateBoardImage, for: .normal)
            }
        })
    }
    
}

//
//  DMEditDentalStateBoardVC.swift
//  DentaMatch
//
//  Created by Rajan Maheshwari on 24/01/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

class DMEditDentalStateBoardVC: DMBaseVC {
    @IBOutlet var dentalStateBoardImageButton: UIButton!
    var dentalStateBoardImage: UIImage?
    var dentalStateBoardImageURL = ""
    var isEditMode = false

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }

    func setup() {
        title = "EDIT PROFILE"
        changeNavBarAppearanceForDefault()
        navigationItem.leftBarButtonItem = backBarButton()
        dentalStateBoardImageButton.imageView?.contentMode = .scaleAspectFill
        dentalStateBoardImageButton.layer.cornerRadius = dentalStateBoardImageButton.frame.size.height / 2
        dentalStateBoardImageButton.clipsToBounds = true
        if let imageUrl = URL(string: dentalStateBoardImageURL) {
            dentalStateBoardImageButton.setTitle("", for: .normal)
            dentalStateBoardImageButton.setImage(for: .normal, url: imageUrl, placeholder: kPlaceHolderImage)
            dentalStateBoardImageButton.layoutIfNeeded()
        }
    }

    @IBAction func dentalStateBoardImageButtonPressed(_: Any) {
        addPhoto()
    }

    @IBAction func saveButtonPressed(_: Any) {
        uploadDentalStateboardImage()
    }

    func updateProfileScreen() {
        NotificationCenter.default.post(name: .updateProfileScreen, object: nil, userInfo: ["dentalStateBoardImageURL": dentalStateBoardImageURL])
    }

    func addPhoto() {
        cameraGalleryOptionActionSheet(title: "", message: "Please select", leftButtonText: "Take a Photo", rightButtonText: "Choose from Library") { [weak self] isCameraButtonPressed, _, isCancelButtonPressed in
            if isCancelButtonPressed {
                // cancel action
            } else if isCameraButtonPressed {
                self?.getPhotoFromCamera()
            } else {
                self?.getPhotoFromGallery()
            }
        }
    }

    func getPhotoFromCamera() {
        CameraGalleryManager.shared.openCamera(viewController: self, allowsEditing: false, completionHandler: {[weak self] (image: UIImage?, error: NSError?) in
            if error != nil {
                DispatchQueue.main.async { [weak self] in
                    self?.makeToast(toastString: (error?.localizedDescription)!)
                }
                return
            }
            self?.dentalStateBoardImage = image
            DispatchQueue.main.async { [weak self] in
                self?.dentalStateBoardImageButton.setImage(self?.dentalStateBoardImage, for: .normal)
            }
        })
    }

    func getPhotoFromGallery() {
        CameraGalleryManager.shared.openGallery(viewController: self, allowsEditing: false, completionHandler: { [weak self] (image: UIImage?, error: NSError?) in
            if error != nil {
                DispatchQueue.main.async { [weak self] in
                    self?.makeToast(toastString: (error?.localizedDescription)!)
                }
                return
            }
            self?.dentalStateBoardImage = image

            DispatchQueue.main.async { [weak self] in
                self?.dentalStateBoardImageButton.setImage(self?.dentalStateBoardImage, for: .normal)
            }
        })
    }
}

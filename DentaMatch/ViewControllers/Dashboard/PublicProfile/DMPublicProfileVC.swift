//
//  DMPublicProfileVC.swift
//  DentaMatch
//
//  Created by Rajan Maheshwari on 19/01/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

class DMPublicProfileVC: DMBaseVC {

    @IBOutlet weak var publicProfileTableView: UITableView!
    
    var profileImage:UIImage?
    var jobSelectionPickerView:JobSelectionPickerView!
    var jobTitles = [JobTitle]()
    var selectedJobTitleId = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        // Do any additional setup after loading the view.
    }

    func setup() {
        selectedJobTitleId = UserManager.shared().activeUser.jobTitleId!
        jobSelectionPickerView = JobSelectionPickerView.loadJobSelectionView(withJobTitles: jobTitles)
        jobSelectionPickerView.delegate = self
        jobSelectionPickerView.pickerView.reloadAllComponents()

        self.title = "EDIT PROFILE"
        self.navigationItem.leftBarButtonItem = self.backBarButton()
        self.publicProfileTableView.register(UINib(nibName: "EditPublicProfileTableCell", bundle: nil), forCellReuseIdentifier: "EditPublicProfileTableCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        NotificationCenter.default.removeObserver(self)
    }
    
    //MARK:- Keyboard Show Hide Observers
    func keyboardWillShow(note: NSNotification) {
        if let keyboardSize = (note.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            publicProfileTableView.contentInset =  UIEdgeInsetsMake(0, 0, keyboardSize.height+1, 0)
        }
    }
    
    func keyboardWillHide(note: NSNotification) {
        publicProfileTableView.contentInset =  UIEdgeInsetsMake(0, 0, 0, 0)
    }


    @IBAction func saveButtonPressed(_ sender: Any) {
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
            self.uploadProfileImageAPI()
            self.publicProfileTableView.reloadData()
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
            self.uploadProfileImageAPI()
            self.publicProfileTableView.reloadData()
        })
        
    }
}

extension DMPublicProfileVC : JobSelectionPickerViewDelegate {
    
    func jobPickerDoneButtonAction(job: JobTitle?) {
        if let cell = self.publicProfileTableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? EditPublicProfileTableCell {
            cell.jobTitleTextField.text = job?.jobTitle
            selectedJobTitleId = "\(job?.jobId)"
        }
        self.view.endEditing(true)
    }
    
    func jobPickerCancelButtonAction() {
        self.view.endEditing(true)
    }
}

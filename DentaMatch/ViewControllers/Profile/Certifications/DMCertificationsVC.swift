//
//  DMCertificationsVC.swift
//  DentaMatch
//
//  Created by Rajan Maheshwari on 10/01/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

class DMCertificationsVC: DMBaseVC,DatePickerViewDelegate {

    enum Certifications:Int {
        case profileHeader
        case certifications
    }
    
    @IBOutlet weak var certificationsTableView: UITableView!
    
    let profileProgress:CGFloat = 0.90
    var certicates = [Certification]()
    var dateView:DatePickerView?
    
    //MARK:- View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        self.getCertificationListAPI()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)

        self.dateView = DatePickerView.loadExperiencePickerView(withText:"" , tag: 0)
        self.dateView?.delegate = self

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.changeNavBarAppearanceForWithoutHeader()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        

    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.main.async {
            UIMenuController.shared.setMenuVisible(true, animated: false)
        }
    }
    //MARK:- Keyboard Show Hide Observers
    @objc func keyboardWillShow(note: NSNotification) {
        if let keyboardSize = (note.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            certificationsTableView.contentInset =  UIEdgeInsetsMake(0, 0, keyboardSize.height+1, 0)
        }
    }
    @objc func keyboardWillHide(note: NSNotification) {
        certificationsTableView.contentInset =  UIEdgeInsetsMake(0, 0, 0, 0)
    }

    //MARK:- Private Methods
    func setup() {
        self.certificationsTableView.separatorColor = UIColor.clear
        self.certificationsTableView.register(UINib(nibName: "PhotoNameCell", bundle: nil), forCellReuseIdentifier: "PhotoNameCell")
        self.certificationsTableView.register(UINib(nibName: "CertificationsCell", bundle: nil), forCellReuseIdentifier: "CertificationsCell")
        self.navigationItem.leftBarButtonItem = self.backBarButton()

    }
    
    //MARK:- IBActions
    @IBAction func nextButtonClicked(_ sender: Any) {
        if checkAllCertitficates() {
            
            self.uploadAllValidityDates( completionHandler: { (response, error) in
                self.performSegue(withIdentifier: Constants.StoryBoard.SegueIdentifier.goToExecutiveSummaryVC, sender: self)

            })
        }
    }
    
    
    
    @objc func certificationImageButtonPressed(_ sender: Any) {
        let button = sender as? UIButton
        
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
//                    self.stateBoardImage = image!
                     let certObj = self.certicates[button!.tag]
                    certObj.certificateImage = image!
//                    self.certicates[button!.tag] = certObj
                    DispatchQueue.main.async {
                        //                        self.profileButton.setImage(image, for: .normal)
//                        self.certificationsTableView.reloadData()
                        self.uploadCetificatsImage(certObj:certObj, completionHandler: { (response, error) in
                            
                            if let response = response {
                                if response[Constants.ServerKey.status].boolValue {
                                    certObj.certificateImageURL = response[Constants.ServerKey.result][Constants.ServerKey.imageURLForPostResponse].stringValue
                                    self.certicates[button!.tag] = certObj
                                    self.certificationsTableView.reloadData()

                                    
                                } else {
//                                    self.makeToast(toastString: response[Constants.ServerKey.message].stringValue)
                                }
                            }

                        })

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
                    let certObj = self.certicates[button!.tag]
                    certObj.certificateImage = image!
//                    self.certicates[button!.tag] = certObj
                    DispatchQueue.main.async {
                        self.uploadCetificatsImage(certObj:certObj, completionHandler: { (response, error) in
                            
                            if let response = response {
                                if response[Constants.ServerKey.status].boolValue {
                                    certObj.certificateImageURL = response[Constants.ServerKey.result][Constants.ServerKey.imageURLForPostResponse].stringValue
                                    self.certicates[button!.tag] = certObj
                                    self.certificationsTableView.reloadData()
                                    
                                    
                                } else {
                                    //                                    self.makeToast(toastString: response[Constants.ServerKey.message].stringValue)
                                }
                            }
                            
                        })
                    }
                })
            }
        }
    }
    
    // MARK:- Validations
    func checkAllCertitficates()-> Bool {
        var atLeastOneCheck = false

        for index in  0..<self.certicates.count{
            
            let certObj = certicates[index]
            
            if !(certObj.certificateImageURL?.isEmptyField)! {
                if (certObj.validityDate.isEmptyField) {
                    self.makeToast(toastString: "Please select  \(certObj.certificationName) validity date")
                    return false
                }
                atLeastOneCheck = true
            }
            
            
            if !(certObj.validityDate.isEmptyField) {
                if (certObj.certificateImageURL?.isEmptyField)! {
                    self.makeToast(toastString: "Please select certificate for \(certObj.certificationName)")
                    return false
                }
            }
            
            

            
        }
        if atLeastOneCheck == false {
            self.makeToast(toastString: "Please upload at least one certificate")

            return false
        }
        return true
    }
    // MARK :- DatePicker Delegate
    func canceButtonAction() {
        self.view.endEditing(true)
    }
    func doneButtonAction(date: String, tag: Int) {
        debugPrint("get Tag =\(tag)")
        self.view.endEditing(true)
        certicates[tag].validityDate = date
        self.certificationsTableView.reloadData()
    }

}

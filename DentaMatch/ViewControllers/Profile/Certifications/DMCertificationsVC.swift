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
    func keyboardWillShow(note: NSNotification) {
        if let keyboardSize = (note.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            certificationsTableView.contentInset =  UIEdgeInsetsMake(0, 0, keyboardSize.height+1, 0)
        }
    }
    func keyboardWillHide(note: NSNotification) {
        certificationsTableView.contentInset =  UIEdgeInsetsMake(0, 0, 0, 0)
    }

    
    func setup() {
        self.certificationsTableView.separatorColor = UIColor.clear
        self.certificationsTableView.register(UINib(nibName: "PhotoNameCell", bundle: nil), forCellReuseIdentifier: "PhotoNameCell")
        self.certificationsTableView.register(UINib(nibName: "CertificationsCell", bundle: nil), forCellReuseIdentifier: "CertificationsCell")
        self.navigationItem.leftBarButtonItem = self.backBarButton()

    }
    
    @IBAction func nextButtonClicked(_ sender: Any) {
        if checkAllCertitficates() {
            self.uploadAllValidityDates( completionHandler: { (response, error) in
                self.performSegue(withIdentifier: Constants.StoryBoard.SegueIdentifier.goToExecutiveSummaryVC, sender: self)

            })
        }
    }
    
    
    
    func certificationImageButtonPressed(_ sender: Any) {
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
    


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK:- Validations
    func checkAllCertitficates()-> Bool {
        for index in  0..<self.certicates.count{
            let certObj = certicates[index]
            if (certObj.certificateImageURL?.isEmptyField)! {
                self.makeToast(toastString: "Please upload \(certObj.certificationName) first")
                return false
            }else if (certObj.validityDate.isEmptyField) {
                self.makeToast(toastString: "Please select  \(certObj.certificationName) validity date")
                return false
            }
            
        }
        return true
    }
    // MARK :- DaatePicker Delegate
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

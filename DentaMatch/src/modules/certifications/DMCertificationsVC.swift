//
//  DMCertificationsVC.swift
//  DentaMatch
//
//  Created by Rajan Maheshwari on 10/01/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

class DMCertificationsVC: DMBaseVC, DatePickerViewDelegate {
    enum Certifications: Int {
        case profileHeader
        case certifications
    }

    @IBOutlet var certificationsTableView: UITableView!

    let profileProgress: CGFloat = 0.90
    var certicates = [Certification]()
    var dateView: DatePickerView?

    // MARK: - View LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        getCertificationListAPI()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)

        dateView = DatePickerView.loadExperiencePickerView(withText: "", tag: 0)
        dateView?.delegate = self

        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        changeNavBarAppearanceForWithoutHeader()
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.setNavigationBarHidden(false, animated: true)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.main.async {
            UIMenuController.shared.setMenuVisible(true, animated: false)
        }
    }

    // MARK: - Keyboard Show Hide Observers

    @objc func keyboardWillShow(note: NSNotification) {
        if let keyboardSize = (note.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            certificationsTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height + 1, right: 0)
        }
    }

    @objc func keyboardWillHide(note _: NSNotification) {
        certificationsTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }

    // MARK: - Private Methods

    func setup() {
        certificationsTableView.separatorColor = UIColor.clear
        certificationsTableView.register(UINib(nibName: "PhotoNameCell", bundle: nil), forCellReuseIdentifier: "PhotoNameCell")
        certificationsTableView.register(UINib(nibName: "CertificationsCell", bundle: nil), forCellReuseIdentifier: "CertificationsCell")
        navigationItem.leftBarButtonItem = backBarButton()
    }

    // MARK: - IBActions

    @IBAction func nextButtonClicked(_: Any) {
        if checkAllCertitficates() {
            uploadAllValidityDates(completionHandler: { _, _ in
                
                assertionFailure("Implement")
//                guard let vc = DMExecutiveSummaryInitializer.initialize() as? DMExecutiveSummaryVC else { return }
//                self.navigationController?.pushViewController(vc, animated: true)
            })
        }
    }

    @objc func certificationImageButtonPressed(_ sender: Any) {
        let button = sender as? UIButton

        cameraGalleryOptionActionSheet(title: "", message: "Please select", leftButtonText: "Take a Photo", rightButtonText: "Choose from Library") { isCameraButtonPressed, _, isCancelButtonPressed in
            if isCancelButtonPressed {
            } else if isCameraButtonPressed {
                CameraGalleryManager.shared.openCamera(viewController: self, allowsEditing: false, completionHandler: {[weak self] (image: UIImage?, error: NSError?) in
                    if error != nil {
                        DispatchQueue.main.async {
                            self?.makeToast(toastString: (error?.localizedDescription)!)
                        }
                        return
                    }

                    guard let certObj = self?.certicates[button!.tag] else {
                       return
                    }
                   certObj.certificateImage = image!
                    DispatchQueue.main.async {
     
                        self?.uploadCetificatsImage(certObj: certObj, completionHandler: { response, _ in
                            if let response = response {
                                if response[Constants.ServerKey.status].boolValue {
                                    certObj.certificateImageURL = response[Constants.ServerKey.result][Constants.ServerKey.imageURLForPostResponse].stringValue
                                    self?.certicates[button!.tag] = certObj
                                    self?.certificationsTableView.reloadData()

                                } else {
//                                    self.makeToast(toastString: response[Constants.ServerKey.message].stringValue)
                                }
                            }

                        })
                    }
                })
            } else {
                CameraGalleryManager.shared.openGallery(viewController: self, allowsEditing: false, completionHandler: { [weak self] (image: UIImage?, error: NSError?) in
                    if error != nil {
                        DispatchQueue.main.async {
                            self?.makeToast(toastString: (error?.localizedDescription)!)
                        }
                        return
                    }
                    guard let certObj = self?.certicates[button!.tag] else {
                        return
                    }
                    certObj.certificateImage = image!
//                    self.certicates[button!.tag] = certObj
                    DispatchQueue.main.async {
                        self?.uploadCetificatsImage(certObj: certObj, completionHandler: { response, _ in

                            if let response = response {
                                if response[Constants.ServerKey.status].boolValue {
                                    certObj.certificateImageURL = response[Constants.ServerKey.result][Constants.ServerKey.imageURLForPostResponse].stringValue
                                    self?.certicates[button!.tag] = certObj
                                    self?.certificationsTableView.reloadData()

                                } else {
                                    // DO Nothing
                                }
                            }

                        })
                    }
                })
            }
        }
    }

    // MARK: - Validations

    func checkAllCertitficates() -> Bool {
        var atLeastOneCheck = false
        for index in 0 ..< certicates.count {
            let certObj = certicates[index]
            if !(certObj.certificateImageURL?.isEmptyField)! {
                if certObj.validityDate.isEmptyField {
                    makeToast(toastString: "Please select  \(certObj.certificationName) validity date")
                    return false
                }
                atLeastOneCheck = true
            }
            if !(certObj.validityDate.isEmptyField) {
                if (certObj.certificateImageURL?.isEmptyField)! {
                    makeToast(toastString: "Please select certificate for \(certObj.certificationName)")
                    return false
                }
            }
        }
        if atLeastOneCheck == false {
            makeToast(toastString: "Please upload at least one certificate")
            return false
        }
        return true
    }

    // MARK: - DatePicker Delegate

    func canceButtonAction() {
        view.endEditing(true)
    }

    func doneButtonAction(date: String, tag: Int) {
        // debugPrint("get Tag =\(tag)")
        view.endEditing(true)
        certicates[tag].validityDate = date
        certificationsTableView.reloadData()
    }
}
//
//  DMPublicProfileVC.swift
//  DentaMatch
//
//  Created by Rajan Maheshwari on 19/01/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit
import CoreLocation

class DMPublicProfileVC: DMBaseVC {

    enum ProfileOptions:Int {
        case firstName = 1
        case lastName
        case jobTitle
        case preferredJobLocation
    }
    
    @IBOutlet weak var publicProfileTableView: UITableView!
    
    var originalParams = [String:String]()
    
    var editProfileParams = [
        Constants.ServerKey.firstName:"",
        Constants.ServerKey.lastName:"",
        //"zipcode":"",
        Constants.ServerKey.latitude:"",
        Constants.ServerKey.longitude:"",
        Constants.ServerKey.preferredJobLocation:"",
        Constants.ServerKey.jobTitileId:"",
        Constants.ServerKey.aboutMe:""
    ]
    
    var profileImage:UIImage?
    var jobSelectionPickerView:JobSelectionPickerView!
    var jobTitles = [JobTitle]()
    var selectedJobTitleId = ""
    var selectedLocationCoordinate:CLLocationCoordinate2D?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        // Do any additional setup after loading the view.
    }

    func setup() {
        selectedJobTitleId = UserManager.shared().activeUser.jobTitleId!
        editProfileParams[Constants.ServerKey.firstName] = UserManager.shared().activeUser.firstName
        editProfileParams[Constants.ServerKey.lastName] = UserManager.shared().activeUser.lastName
        editProfileParams[Constants.ServerKey.jobTitileId] = selectedJobTitleId
        editProfileParams[Constants.ServerKey.latitude] = UserManager.shared().activeUser.latitude
        editProfileParams[Constants.ServerKey.longitude] = UserManager.shared().activeUser.longitude
        editProfileParams[Constants.ServerKey.preferredJobLocation] = UserManager.shared().activeUser.preferredJobLocation
        editProfileParams["zipcode"] = UserManager.shared().activeUser.zipCode
        editProfileParams[Constants.ServerKey.aboutMe] = UserManager.shared().activeUser.aboutMe

        selectedLocationCoordinate = CLLocationCoordinate2D(latitude: Double(UserManager.shared().activeUser.latitude!)!, longitude: Double(UserManager.shared().activeUser.longitude!)!)
        jobSelectionPickerView = JobSelectionPickerView.loadJobSelectionView(withJobTitles: jobTitles)
        jobSelectionPickerView.delegate = self
        jobSelectionPickerView.pickerView.reloadAllComponents()

        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.publicProfileTableView.addGestureRecognizer(tap)
        
        self.title = "EDIT PROFILE"
        self.navigationItem.leftBarButtonItem = self.backBarButton()
        self.publicProfileTableView.register(UINib(nibName: "EditPublicProfileTableCell", bundle: nil), forCellReuseIdentifier: "EditPublicProfileTableCell")
        
        originalParams = editProfileParams
    }
    
   /* func backButtonAction() {
        if editProfileParams == originalParams {
            print("same")
        } else {
            print("Different")
        }
    }*/
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)

    }
    
    func dismissKeyboard() {
        self.view.endEditing(true)
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
    
    func validateFields() -> Bool {
        if editProfileParams[Constants.ServerKey.firstName]!.isEmptyField {
            self.makeToast(toastString: Constants.AlertMessage.emptyFirstName)
            return false
        }
        
        if editProfileParams[Constants.ServerKey.lastName]!.isEmptyField {
            self.makeToast(toastString: Constants.AlertMessage.emptyLastName)
            return false
        }
        if editProfileParams[Constants.ServerKey.jobTitileId]!.isEmptyField {
            self.makeToast(toastString: Constants.AlertMessage.emptyCurrentJobTitle)
            return false
        }

        if editProfileParams[Constants.ServerKey.aboutMe]!.isEmptyField {
            self.makeToast(toastString: Constants.AlertMessage.emptyAboutMe)
            return false
        }
        
        if editProfileParams[Constants.ServerKey.jobTitileId]!.isEmptyField || editProfileParams[Constants.ServerKey.jobTitileId]! == "0" {
            self.makeToast(toastString: Constants.AlertMessage.emptyJobTitle)
            return false
        }
        
        if editProfileParams[Constants.ServerKey.zipcode]!.isEmptyField {
            self.makeToast(toastString: Constants.AlertMessage.emptyPinCode)
            return false
        }        
        return true
    }


    @IBAction func saveButtonPressed(_ sender: Any) {
        self.view.endEditing(true)
        if validateFields() {
            debugPrint("Edit Profile Params\n\(editProfileParams)")
            self.updatePublicProfileAPI(params: editProfileParams)
        }
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
        })
        
    }
    
    func openMapsScreen() {
        let mapVC = UIStoryboard.registrationStoryBoard().instantiateViewController(type: DMRegisterMapsVC.self)!
        mapVC.delegate = self
        mapVC.userSelectedCoordinate = selectedLocationCoordinate
        mapVC.addressSelectedFromProfile = editProfileParams[Constants.ServerKey.preferredJobLocation]!
        mapVC.fromEditProfile = true
        self.navigationController?.pushViewController(mapVC, animated: true)
        self.view.endEditing(true)
    }
    
    func updateProfileScreen() {
        NotificationCenter.default.post(name: .updateProfileScreen, object: nil, userInfo: nil)
    }
}

extension DMPublicProfileVC:UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard string.characters.count > 0 else {
            return true
        }

        let profileOptions = ProfileOptions(rawValue: textField.tag)!
        switch profileOptions {
        case .firstName:
            let characterset = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLKMNOPQRSTUVWXYZ")
            if string.rangeOfCharacter(from: characterset.inverted) != nil {
                debugPrint("string contains special characters")
                return false
            }
            if textField.text!.characters.count >= Constants.Limit.commonMaxLimit {
                return false
            }
            return true
        case .lastName:
            let characterset = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLKMNOPQRSTUVWXYZ")
            if string.rangeOfCharacter(from: characterset.inverted) != nil {
                debugPrint("string contains special characters")
                return false
            }
            if textField.text!.characters.count >= Constants.Limit.commonMaxLimit {
                return false
            }
            return true
        default:
            return true
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let profileOptions = ProfileOptions(rawValue: textField.tag)!
        switch profileOptions {
        case .firstName:
            if let cell = self.publicProfileTableView.cellForRow(at: IndexPath(row: 0, section: 0)) as?
                EditPublicProfileTableCell {
                cell.lastNameTextField.becomeFirstResponder()
            }
        case .lastName:
            textField.resignFirstResponder()
        default:
            self.view.endEditing(true)
        }
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        if let cell = self.publicProfileTableView.cellForRow(at: IndexPath(row: 0, section: 0)) as?
            EditPublicProfileTableCell {
            if textField == cell.locationTextField {
                openMapsScreen()
                return false
            }
        }
        
        if let textField = textField as? AnimatedPHTextField {
            textField.layer.borderColor = Constants.Color.textFieldColorSelected.cgColor
        }
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        textField.text = textField.text!.trim()
        if let textField = textField as? AnimatedPHTextField {
            textField.layer.borderColor = Constants.Color.textFieldBorderColor.cgColor
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        let profileOptions = ProfileOptions(rawValue: textField.tag)!
        
        switch profileOptions {
        case .firstName:
            editProfileParams[Constants.ServerKey.firstName] = textField.text!
        case .lastName:
            editProfileParams[Constants.ServerKey.lastName] = textField.text!
        case .preferredJobLocation:
            editProfileParams[Constants.ServerKey.preferredJobLocation] = textField.text!
        default:
            break
        }
    }
}

extension DMPublicProfileVC : JobSelectionPickerViewDelegate {
    
    func jobPickerDoneButtonAction(job: JobTitle?) {
        if let cell = self.publicProfileTableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? EditPublicProfileTableCell {
            cell.jobTitleTextField.text = job?.jobTitle
            selectedJobTitleId = "\(job!.jobId)"
            editProfileParams[Constants.ServerKey.jobTitileId] = selectedJobTitleId
        }
        self.view.endEditing(true)
    }
    
    func jobPickerCancelButtonAction() {
        self.view.endEditing(true)
    }
}

//MARK:- LocationAddress Delegate
extension DMPublicProfileVC:LocationAddressDelegate {
    func locationAddress(location: Location) {
        //coordinateSelected = location.coordinateSelected
        if let address = location.address {
            if let cell = self.publicProfileTableView.cellForRow(at: IndexPath(row: 0, section: 0)) as?
                EditPublicProfileTableCell {
                cell.locationTextField.text = address
                selectedLocationCoordinate = location.coordinateSelected
                editProfileParams[Constants.ServerKey.latitude] = "\(location.coordinateSelected!.latitude)"
                editProfileParams[Constants.ServerKey.longitude] = "\(location.coordinateSelected!.longitude)"
                editProfileParams[Constants.ServerKey.preferredJobLocation] = address
                editProfileParams["zipcode"] = location.postalCode
            }
            debugPrint(address)
        } else {
            debugPrint("Address is empty")
        }
    }
}

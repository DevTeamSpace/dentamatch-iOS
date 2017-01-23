//
//  DMLicenseSelectionVC.swift
//  DentaMatch
//
//  Created by Sanjay Kumar Yadav on 30/12/16.
//  Copyright © 2016 Appster. All rights reserved.
//

import UIKit

class DMLicenseSelectionVC: DMBaseVC,UITextFieldDelegate {
    @IBOutlet var licenseTableView: UITableView!
    let profileProgress:CGFloat = 0.10
    var stateBoardImage:UIImage? = nil
    var licenseArray:NSMutableArray?
    var jobTitles = [JobTitle]()
    var selectedJobTitle:JobTitle!

    override func viewDidLoad() {
        super.viewDidLoad()
        licenseArray = NSMutableArray()
        self.navigationController?.setNavigationBarHidden(false, animated: true)

        licenseArray?.addObjects(from: ["",""])
        setUp()
    }
    override func viewDidLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.licenseTableView.contentInset =  UIEdgeInsetsMake(0, 0, 0, 0)

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.changeNavBarAppearanceForWithoutHeader()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        self.licenseTableView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    //MARK:- Keyboard Show Hide Observers
    func keyboardWillShow(note: NSNotification) {
        if let keyboardSize = (note.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            licenseTableView.contentInset =  UIEdgeInsetsMake(0, 0, keyboardSize.height+1, 0)
        }
    }
    func keyboardWillHide(note: NSNotification) {
        licenseTableView.contentInset =  UIEdgeInsetsMake(0, 0, 0, 0)
    }
    
    func setUp() {
        self.licenseTableView.register(UINib(nibName: "AnimatedPHTableCell", bundle: nil), forCellReuseIdentifier: "AnimatedPHTableCell")
        self.licenseTableView.register(UINib(nibName: "PhotoNameCell", bundle: nil), forCellReuseIdentifier: "PhotoNameCell")
        self.licenseTableView.register(UINib(nibName: "PhotoCell", bundle: nil), forCellReuseIdentifier: "PhotoCell")
        self.licenseTableView.register(UINib(nibName: "SectionHeadingTableCell", bundle: nil), forCellReuseIdentifier: "SectionHeadingTableCell")

        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.licenseTableView.addGestureRecognizer(tap)
        self.licenseTableView.separatorStyle = .none
        self.licenseTableView.reloadData()
        self.navigationItem.leftBarButtonItem = self.backBarButton()

    }
    func dismissKeyboard() {
        self.view.endEditing(true)
    }
    @IBAction func nextButtonClikced(_ sender: Any) {
        
        if self.stateBoardImage == nil{
            self.makeToast(toastString: Constants.AlertMessage.stateCertificate)
            return
        }
        for i in 0..<(self.licenseArray?.count)! {
            let text = self.licenseArray?[i] as! String
            if i == 0 {
                if text.isEmptyField {
                    self.makeToast(toastString: Constants.AlertMessage.emptyLicenseNumber)
                    return
                }else
                {
                    let newChar = text.characters.first
                    if newChar == "-" {
                        self.makeToast(toastString: Constants.AlertMessage.lienseNoStartError)
                        return
                    }
                }
            }else{
                if text.isEmptyField {
                    self.makeToast(toastString: Constants.AlertMessage.emptyState)
                    return
                }else{
                    
                    let newChar = text.characters.first
                    if newChar == "-" {
                        self.makeToast(toastString: Constants.AlertMessage.stateStartError)
                        return
                    }
                }
            }
        }
        

        let  params = ["license":self.licenseArray![0],"state":self.licenseArray![1],"jobTitleId":"\(self.selectedJobTitle.jobId)"]
        updateLicenseAndStateAPI(params: params as! [String : String])
        
        
//        //for testing 
//        openExperienceFirstScreen()
    }
    
//    func checkValidationForFirstLetter(text:String, tag:Int) -> Bool {
//        //tag 0 for license and 1 for state
//        let check = true
//        let newChar = text.characters.first
//        if newChar == "-" {
//        }
//
//        if tag == 0 {
//            
//        }else{
//            
//        }
//        return check
//    
//    }
//    
//    func checkValidationForLastLetter(text:String, tag:Int) -> Bool {
//        //tag 0 for license and 1 for state
//        let check = true
//        let newChar = text.characters.last
//        if newChar == "-" {
//        }
//        
//        if tag == 0 {
//            
//        }else{
//            
//        }
//        return check
//
//        
//    }

    func openExperienceFirstScreen() {
        self.performSegue(withIdentifier: "goToWorkExperience", sender: self)
    }
    func stateBoardButtonPressed(_ sender: Any) {
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
                    self.stateBoardImage = image!
                    self.uploadDentalStateboardImage()
                    DispatchQueue.main.async {
                        self.licenseTableView.reloadData()
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
                    self.stateBoardImage = image
                    self.uploadDentalStateboardImage()
                    DispatchQueue.main.async {
                        self.licenseTableView.reloadData()
                    }
                })
            }
        }
    }

    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "goToWorkExperience"
        {
            let destinationVC:DMWorkExperienceStart = segue.destination as! DMWorkExperienceStart
            destinationVC.selectedJobTitle = self.selectedJobTitle
            destinationVC.jobTitles = self.jobTitles
        }

    }

    


    

}


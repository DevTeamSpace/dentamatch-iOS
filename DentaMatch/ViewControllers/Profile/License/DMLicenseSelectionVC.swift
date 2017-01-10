//
//  DMLicenseSelectionVC.swift
//  DentaMatch
//
//  Created by Sanjay Kumar Yadav on 30/12/16.
//  Copyright © 2016 Appster. All rights reserved.
//

import UIKit

class DMLicenseSelectionVC: DMBaseVC,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate {
    @IBOutlet var licenseTableView: UITableView!
    
    var stateBoardImage:UIImage? = nil
    var licenseArray:NSMutableArray?
    var jobTitles = [JobTitle]()

    override func viewDidLoad() {
        super.viewDidLoad()
        licenseArray = NSMutableArray()

        licenseArray?.addObjects(from: ["",""])
        setUp()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.changeNavBarAppearanceForWithoutHeader()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true

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
        
//        if self.stateBoardImage == nil{
//            self.makeToast(toastString: "Please select state board certificate")
//            return
//        }
//        for i in 0..<(self.licenseArray?.count)! {
//            let text = self.licenseArray?[i] as! String
//            if i == 0 {
//                if text.isEmptyField {
//                    self.makeToast(toastString: "Please enter license no")
//                    return
//                }
//            }else{
//                if text.isEmptyField {
//                    self.makeToast(toastString: "Please enter state")
//                    return
//                }
//
//            }
//        }
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
                    DispatchQueue.main.async {
//                        self.profileButton.setImage(image, for: .normal)
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
            destinationVC.jobTitles = self.jobTitles
        }

    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 || section == 1
        {
            return 1
        }
        return 2
    }
     func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 45))
        let headerLabel = UILabel(frame: headerView.frame)
        headerLabel.frame.origin.x = 20
        headerLabel.backgroundColor = UIColor.clear
        headerLabel.font = UIFont.fontMedium(fontSize: 14)
        headerView.addSubview(headerLabel)
        headerView.backgroundColor = UIColor(red: 248.0/255.0, green: 248.0/255.0, blue: 248.0/255.0, alpha: 1.0)
        if section == 1
        {
            headerLabel.text = "ADD DENTAL STATE BOARD"
        }else{
            headerLabel.text = "LICENSE"
        }
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section == 0
        {
            return 226
 
        }else if indexPath.section == 1        {
            return 203
            
        }
        return 109

    }
     func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        if section == 0
        {
            return 0
        }
        return 45
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "PhotoNameCell") as! PhotoNameCell
            cell.selectionStyle = .none

            return cell

        case 1:
            print("section 1")
            let cell = tableView.dequeueReusableCell(withIdentifier: "PhotoCell") as! PhotoCell
            
            cell.stateBoardPhotoButton.addTarget(self, action: #selector(DMLicenseSelectionVC.stateBoardButtonPressed(_:)), for: .touchUpInside)
            if self.stateBoardImage == nil{
                cell.stateBoardPhotoButton .setTitle("h", for: .normal)
            }else{
                cell.stateBoardPhotoButton .setTitle("", for: .normal)
                cell.stateBoardPhotoButton.alpha = 1.0
                cell.stateBoardPhotoButton.backgroundColor = UIColor.clear
                cell.stateBoardPhotoButton.setImage(self.stateBoardImage!, for: .normal)
            }

            cell.selectionStyle = .none
            return cell

            
        case 2:
            print("section 2")
            let cell = tableView.dequeueReusableCell(withIdentifier: "AnimatedPHTableCell") as! AnimatedPHTableCell
            cell.selectionStyle = .none

            cell.commonTextFiled.delegate = self
            cell.commonTextFiled.tag = indexPath.row
            
            if indexPath.row == 0
            {
                cell.cellTopSpace.constant = 43.5
                cell.cellBottomSpace.constant = 10.5
                cell.commonTextFiled.placeholder = "License Number"
                cell.layoutIfNeeded()
            }else if indexPath.row == 1
            {
                cell.commonTextFiled.placeholder = "State"
                cell.cellTopSpace.constant = 10.5
                cell.cellBottomSpace.constant = 41.5
                cell.layoutIfNeeded()
            }
            return cell

        case 3:
            print("section 3")


            
        default:
            print("Default")
            
        }
        
       return UITableViewCell()
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if let textField = textField as? AnimatedPHTextField {
            textField.layer.borderColor = Constants.Color.textFieldColorSelected.cgColor
        }
        return true
    }
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if let textField = textField as? AnimatedPHTextField {
            textField.layer.borderColor = Constants.Color.textFieldBorderColor.cgColor
        }
        return true
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
    
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard string.characters.count > 0 else {
            return true
        }
        
        if textField.tag == 0 {
            if (textField.text?.characters.count)! > Constants.TextFieldMaxLenght.licenseNumber {
                return false
            }

        }else{
            if (textField.text?.characters.count)! > Constants.TextFieldMaxLenght.commonMaxLenght {
                return false
            }

        }

        let characterset = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLKMNOPQRSTUVWXYZ0123456789-")
        if string.rangeOfCharacter(from: characterset.inverted) != nil {
            print("string contains special characters")
            return false
        }
        return true

    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.tag == 0
        {
            self.licenseArray?.replaceObject(at: 0, with: textField.text!)
        }else{
            self.licenseArray?.replaceObject(at: 1, with: textField.text!)

        }
        
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    

    

}


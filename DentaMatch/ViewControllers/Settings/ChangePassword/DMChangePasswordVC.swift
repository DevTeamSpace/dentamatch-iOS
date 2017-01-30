//
//  DMChangePasswordVC.swift
//  DentaMatch
//
//  Created by Sanjay Kumar Yadav on 21/01/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

class DMChangePasswordVC: DMBaseVC {
    @IBOutlet weak var changePasswordTableView: UITableView!
    var passwordArray:[String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        passwordArray = ["","",""]
        // Do any additional setup after loading the view.
        setup()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.changePasswordTableView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setup() {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.changeNavBarAppearanceForDefault()
        self.navigationItem.leftBarButtonItem = self.backBarButton()

        self.changePasswordTableView.register(UINib(nibName: "ChangePasswordTableCell", bundle: nil), forCellReuseIdentifier: "ChangePasswordTableCell")
        self.changePasswordTableView.separatorStyle = .none
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.changePasswordTableView.addGestureRecognizer(tap)
        self.title = Constants.ScreenTitleNames.resetPassword

        
    }
    func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    
    //MARK:- Keyboard Show Hide Observers
    func keyboardWillShow(note: NSNotification) {
        if let keyboardSize = (note.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            self.changePasswordTableView.contentInset =  UIEdgeInsetsMake(0, 0, keyboardSize.height+1, 0)
        }
    }
    
    func keyboardWillHide(note: NSNotification) {
        self.changePasswordTableView.contentInset =  UIEdgeInsetsMake(0, 0, 0, 0)
    }
    
    
    @IBAction func saveButtonClicked(_ sender: Any) {
        if !checkValidation() {
           //some error
            return
        }
        if  !matchPassword()
        {
            //some error
            return
        }
        //do next 
        self.changePasswordAPI()
    }
    func gobackToSetting() {
    
        _=self.navigationController?.popViewController(animated: true)
    }
    
    func checkValidation() -> Bool {
        
        for index in 0..<self.passwordArray.count {
            let text = self.passwordArray[index]
            
            switch index {
            case 0:
                if text.isEmptyField {
                    self.makeToast(toastString: Constants.AlertMessage.emptyOldPassword)
                    return false
                }
            case 1:
                if text.isEmptyField {
                    self.makeToast(toastString: Constants.AlertMessage.emptyNewPassword)
                    return false
                }
            case 2:
                if text.isEmptyField {
                    self.makeToast(toastString: Constants.AlertMessage.emptyConfirmPassword)
                    return false
                }

            default:
                break
            }
        }
        return true
    }
    
    func matchPassword() -> Bool {
        let newPassword = self.passwordArray[1]
        let ConfirmPassword = self.passwordArray[2]
        if newPassword == ConfirmPassword {
            return true
        }else {
            self.makeToast(toastString: Constants.AlertMessage.matchPassword)
        }
        return false
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

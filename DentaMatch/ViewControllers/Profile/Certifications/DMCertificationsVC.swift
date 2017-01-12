//
//  DMCertificationsVC.swift
//  DentaMatch
//
//  Created by Rajan Maheshwari on 10/01/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

class DMCertificationsVC: DMBaseVC,datePickerViewDelegate {

    enum Certifications:Int {
        case profileHeader
        case certifications
    }
    
    @IBOutlet weak var certificationsTableView: UITableView!
    
    let profileProgress:CGFloat = 0.90
    var certificateArray:Array = Array(arrayLiteral: "","","","","")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)

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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func nextButtonClicked(_ sender: Any) {
        self.performSegue(withIdentifier: Constants.StoryBoard.SegueIdentifier.goToExecutiveSummaryVC, sender: self)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    func canceButtonAction() {
        self.view.endEditing(true)

//        self.certificationsTableView.contentInset =  UIEdgeInsetsMake(0, 0, 0, 0)
//        self.view.layoutIfNeeded()

    }
    func doneButtonAction(date: String, tag: Int) {
        self.view.endEditing(true)
        self.certificateArray[tag] = date
        self.certificationsTableView.reloadData()
//        self.certificationsTableView.contentInset =  UIEdgeInsetsMake(0, 0, 0, 0)
//        self.view.layoutIfNeeded()

    }

}


//extension UITextField {
//    var readonly: Bool {
//        get {
//            return self.getAdditions().readonly
//        }
//        set {
//            self.getAdditions().readonly = newValue
//        }
//    }
//    
//    private func getAdditions() -> UITextFieldAdditions {
//        var additions = objc_getAssociatedObject(self, &key) as? UITextFieldAdditions
//        if additions == nil {
//            additions = UITextFieldAdditions()
//            objc_setAssociatedObject(self, &key, additions!, objc_AssociationPolicy(OBJC_ASSOCIATION_RETAIN_NONATOMIC))
//        }
//        return additions!
//    }
//    
//    public override func targetForAction(action: Selector, withSender sender: AnyObject?) -> AnyObject? {
//        if ((action == Selector("paste:") || (action == Selector("cut:"))) && self.readonly) {
//            return nil
//        }
//        return super.targetForAction(action, withSender: sender)
//    }
//    
//}

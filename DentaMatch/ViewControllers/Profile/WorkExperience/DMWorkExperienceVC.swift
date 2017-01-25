//
//  DMWorkExperienceVC.swift
//  DentaMatch
//
//  Created by Sanjay Kumar Yadav on 03/01/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

enum FieldType: Int,CustomStringConvertible{
    
    case CurrentJobTitle = 1
    case YearOfExperience = 2
    case OfficeName = 3
    case OfficeAddress = 4
    case CityName = 5
    case ReferenceName = 6
    case ReferenceMobileNo = 7
    case ReferenceEmail = 8
    
    var description: String{
        switch self {
        case .CurrentJobTitle:
            return "Current Job Title"
        case .YearOfExperience:
            return "Year Of Experience"
        case .OfficeName:
            return "Office Name"
        case .OfficeAddress:
            return "Office Address"
        case .CityName:
            return "City Name"
        case .ReferenceName:
            return "Reference Name (Optional)"
        case .ReferenceMobileNo:
            return "Reference Mobile No. (Optional)"
        case .ReferenceEmail:
            return "Reference Email (Optional)"
        }
    }
    
}

class DMWorkExperienceVC: DMBaseVC,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,ExperiencePickerViewDelegate,ToolBarButtonDelegate {


    let NAVBAR_CHANGE_POINT:CGFloat = 64
    var exprienceArray = [ExperienceModel]()
    var exprienceDetailArray:NSMutableArray?
    var currentExperience:ExperienceModel? = ExperienceModel(empty: "")
    var phoneFormatter = PhoneNumberFormatter()
    var jobTitles = [JobTitle]()
    var selectedIndex:Int = 0
    var isHiddenExperienceTable :Bool = false


    @IBOutlet weak var mainScrollView: UIScrollView!
    @IBOutlet weak var workExperienceTable: UITableView!
    @IBOutlet weak var workExperienceDetailTable: UITableView!
    @IBOutlet weak var hightOfExperienceTable: NSLayoutConstraint!
    @IBOutlet weak var hightOfExperienceDetailTable: NSLayoutConstraint!
    @IBOutlet weak var heightOfScrollView: NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        initialDataSetup()
        getExperienceAPI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)

        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.changeNavBarAppearanceForProfiles()
        self.navigationController?.navigationBar.setBackgroundImage(nil, for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = nil
        self.navigationController?.navigationBar.isTranslucent = false

    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
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
        self.title = "Work Experience"
        self.workExperienceDetailTable.register(UINib(nibName: "AnimatedPHTableCell", bundle: nil), forCellReuseIdentifier: "AnimatedPHTableCell")
        self.workExperienceDetailTable.register(UINib(nibName: "ReferenceTableCell", bundle: nil), forCellReuseIdentifier: "ReferenceTableCell")
        self.workExperienceDetailTable.register(UINib(nibName: "AddDeleteExperienceCell", bundle: nil), forCellReuseIdentifier: "AddDeleteExperienceCell")
        self.navigationItem.leftBarButtonItem = self.backBarButton()
        self.workExperienceTable.separatorStyle = .none
        self.workExperienceDetailTable.separatorStyle = .none
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.workExperienceDetailTable.addGestureRecognizer(tap)
//        self.mainScrollView.isExclusiveTouch = true

        self.workExperienceDetailTable.reloadData()
        self.changeNavBarAppearanceForProfiles()
    }
    
    func dismissKeyboard() {
        self.view.endEditing(true)
    }

    
    @IBAction func nextButtonClicked(_ sender: Any) {
        
        if self.exprienceArray.count > 0
        {
            self.performSegue(withIdentifier: Constants.StoryBoard.SegueIdentifier.goToStudyVC, sender: self)

        }else{
            self.makeToast(toastString: Constants.AlertMessage.atleastOneExperience)
        }
        
//        self.performSegue(withIdentifier: Constants.StoryBoard.SegueIdentifier.goToStudyVC, sender: self)

    }
    
    //MARK:- Keyboard Show Hide Observers
    func keyboardWillShow(note: NSNotification) {
        if let keyboardSize = (note.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            self.mainScrollView.contentInset =  UIEdgeInsetsMake(0, 0, keyboardSize.height+10, 0)
        }
    }
    
    func keyboardWillHide(note: NSNotification) {
        self.mainScrollView.contentInset =  UIEdgeInsetsMake(0, 0, 0, 0)
    }
    
    func initialDataSetup(){
        let exp = ExperienceModel(empty: "")
        self.exprienceDetailArray?.add(exp)
        self.currentExperience?.references.append(EmployeeReferenceModel(empty: ""))
        self.workExperienceDetailTable.reloadData()
        reSizeTableViewsAndScrollView()
    }
    
    func reSizeTableViewsAndScrollView()  {
        
        if self.isHiddenExperienceTable == true {
            self.hightOfExperienceTable.constant = 0
            

        }else{
            self.hightOfExperienceTable.constant = self.workExperienceTable.contentSize.height

        }
        self.hightOfExperienceDetailTable.constant = self.workExperienceDetailTable.contentSize.height
        self.workExperienceTable.layoutIfNeeded()
        self.workExperienceDetailTable.layoutIfNeeded()
        self.mainScrollView.contentSize = CGSize(width: self.view.bounds.size.width, height: self.hightOfExperienceTable.constant + self.hightOfExperienceDetailTable.constant)
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    

    
}


extension DMWorkExperienceVC:JobSelectionPickerViewDelegate {
    
    func jobPickerDoneButtonAction(job: JobTitle?) {
        if let jobTitle = job {
            self.currentExperience?.jobTitle = jobTitle.jobTitle
            self.currentExperience?.jobTitleID = jobTitle.jobId
            self.workExperienceDetailTable.reloadData()
            
        }
        self.view.endEditing(true)
    }
    
    func jobPickerCancelButtonAction() {
        self.view.endEditing(true)
    }
}

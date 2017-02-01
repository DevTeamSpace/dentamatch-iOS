//
//  DMStudyVC.swift
//  DentaMatch
//
//  Created by Rajan Maheshwari on 10/01/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

class DMStudyVC: DMBaseVC {

    enum Study:Int {
        case profileHeader
        case school
    }
    
    @IBOutlet weak var studyTableView: UITableView!
    
    var isFilledFromAutoComplete = false
    let profileProgress:CGFloat = 0.50
    var school = [[String:AnyObject]()]
    var autoCompleteTable:AutoCompleteTable!
    let autoCompleteBackView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height))

    var schoolCategories = [SchoolCategory]()
    
    var selectedData = NSMutableArray()
    var yearPicker:YearPickerView?

    //MARK:- View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    
        self.getSchoolListAPI()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    //MARK:- Private Methods
    func setup() {
        
        self.yearPicker = YearPickerView.loadYearPickerView(withText: "", withTag: 0)
        self.yearPicker?.delegate = self

        self.navigationItem.leftBarButtonItem = self.backBarButton()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.studyTableView.addGestureRecognizer(tap)
        
        self.studyTableView.separatorColor = UIColor.clear
        self.studyTableView.register(UINib(nibName: "PhotoNameCell", bundle: nil), forCellReuseIdentifier: "PhotoNameCell")
        self.studyTableView.register(UINib(nibName: "SectionHeadingTableCell", bundle: nil), forCellReuseIdentifier: "SectionHeadingTableCell")
        self.studyTableView.register(UINib(nibName: "StudyCell", bundle: nil), forCellReuseIdentifier: "StudyCell")
        self.changeNavBarAppearanceForWithoutHeader()
        self.changeNavBarToTransparent()
        
        autoCompleteTable = UIView.instanceFromNib(type: AutoCompleteTable.self)!
        autoCompleteTable.delegate = self
        autoCompleteBackView.backgroundColor = UIColor.clear
        autoCompleteBackView.isHidden = true
        autoCompleteTable.isHidden = true
        autoCompleteTable.layer.cornerRadius = 8.0
        autoCompleteTable.clipsToBounds = true
        self.view.addSubview(autoCompleteBackView)
        autoCompleteBackView.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        autoCompleteBackView.addGestureRecognizer(tapGesture)
        self.view.addSubview(autoCompleteTable)        
    }
    
    func dismissKeyboard() {
        self.view.endEditing(true)
        hideAutoCompleteView()
    }
    
    func hideAutoCompleteView() {
        autoCompleteBackView.isHidden = true
        autoCompleteTable.isHidden = true
    }
    
    //MARK:- Keyboard Show Hide Observers
    func keyboardWillShow(note: NSNotification) {
        if let keyboardSize = (note.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            studyTableView.contentInset =  UIEdgeInsetsMake(0, 0, keyboardSize.height+200, 0)
        }
    }
    
    func keyboardWillHide(note: NSNotification) {
        studyTableView.contentInset =  UIEdgeInsetsMake(0, 0, 0, 0)
    }

    //MARK:- IBActions
    @IBAction func nextButtonClicked(_ sender: Any) {
        if selectedData.count == 0 {
            self.makeToast(toastString: "Please fill atleast one school")
            return
        }
        self.preparePostSchoolData(schoolsSelected: selectedData)
    }
    
    func openSkillsScreen() {
        let skillsVC = UIStoryboard.profileStoryBoard().instantiateViewController(type: DMSkillsVC.self)!
        
        let selectSkillsVC = UIStoryboard.profileStoryBoard().instantiateViewController(type: DMSelectSkillsVC.self)!
        
        let sideMenu = SSASideMenu(contentViewController: skillsVC, rightMenuViewController: selectSkillsVC)
        sideMenu.panGestureEnabled = false
        sideMenu.delegate = skillsVC
        self.navigationController?.pushViewController(sideMenu, animated: true)
    }
}

extension DMStudyVC:AutoCompleteSelectedDelegate {

    //MARK:- AutoComplete List Delegates
    func didSelect(schoolCategoryId: String, university: University) {
        hideAutoCompleteView()
        let school = schoolCategories.filter({$0.schoolCategoryId == schoolCategoryId}).first
        
        isFilledFromAutoComplete = true
        var flag = 0
        
        if selectedData.count == 0 {
            let dict = NSMutableDictionary()
            dict["parentId"] = "\(schoolCategoryId)"
            dict["schoolId"] = "\(university.universityId)"
            dict["other"] = university.universityName
            dict["parentName"] = school?.schoolCategoryName
            
            selectedData.add(dict)
            flag = 1
        } else {
            for category in selectedData {
                let dict = category as! NSMutableDictionary
                if dict["parentId"] as! String == "\(schoolCategoryId)" {
                    dict["other"] = university.universityName
                    dict["parentName"] = school?.schoolCategoryName
                    flag = 1
                }
            }
        }
        
        //Array is > 0 but dict doesnt exists
        if flag == 0 {
            let dict = NSMutableDictionary()
            dict["parentId"] = schoolCategoryId as AnyObject?
            dict["schoolId"] = university.universityId as AnyObject?
            dict["other"] = university.universityName
            dict["parentName"] = school?.schoolCategoryName
            dict["yearOfGraduation"] = ""
            selectedData.add(dict)
        }
        
        print(selectedData)
        
        self.studyTableView.reloadData()
    }
}

extension DMStudyVC : YearPickerViewDelegate {
    
    func canceButtonAction() {
        self.view.endEditing(true)
    }
    
    func doneButtonAction(year: Int, tag: Int) {
        var flag = 0
        
        if selectedData.count == 0 {
            let dict = NSMutableDictionary()
            dict["parentId"] = "\(tag)"
            dict["schoolId"] = "\(tag)"
            dict["yearOfGraduation"] = "\(year)"
            if let _ = dict["other"] {
            } else {
                self.makeToast(toastString: "Please enter school name first")
                dict["other"] = ""
            }
            selectedData.add(dict)
            flag = 1
        } else {
            for category in selectedData {
                let dict = category as! NSMutableDictionary
                if dict["parentId"] as! String == "\(tag)" {
                    dict["yearOfGraduation"] = "\(year)"
                    if let _ = dict["other"] {
                    } else {
                        self.makeToast(toastString: "Please enter school name first")
                        dict["other"] = ""
                    }
                    flag = 1
                }
            }
        }
        
        //Array is > 0 but dict doesnt exists
        if flag == 0 {
            let dict = NSMutableDictionary()
            dict["parentId"] = "\(tag)"
            dict["schoolId"] = "\(tag)"
            dict["yearOfGraduation"] = "\(year)"
            if let _ = dict["other"] {
            } else {
                self.makeToast(toastString: "Please enter school name first")
                dict["other"] = ""
            }
            selectedData.add(dict)
        }
        print(selectedData)
        self.studyTableView.reloadData()
    }
}

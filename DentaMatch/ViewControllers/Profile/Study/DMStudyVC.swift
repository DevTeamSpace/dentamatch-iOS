//
//  DMStudyVC.swift
//  DentaMatch
//
//  Created by Rajan Maheshwari on 10/01/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

class DMStudyVC: DMBaseVC {
    enum Study: Int {
        case profileHeader
        case school
    }
    
    @IBOutlet var studyTableView: UITableView!
    
    var isFilledFromAutoComplete = false
    let profileProgress: CGFloat = 0.50
    var school = [[String: AnyObject]()]
    var autoCompleteTable: AutoCompleteTable!
    let autoCompleteBackView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height))
    
    var schoolCategories = [SchoolCategory]()
    
    var selectedData = NSMutableArray()
    var yearPicker: YearPickerView?
    
    // MARK: - View LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        
        getSchoolListAPI()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Private Methods
    
    func setup() {
        yearPicker = YearPickerView.loadYearPickerView(withText: "", withTag: 0)
        yearPicker?.delegate = self
        
        navigationItem.leftBarButtonItem = backBarButton()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        studyTableView.addGestureRecognizer(tap)
        
        studyTableView.separatorColor = UIColor.clear
        studyTableView.register(UINib(nibName: "PhotoNameCell", bundle: nil), forCellReuseIdentifier: "PhotoNameCell")
        studyTableView.register(UINib(nibName: "SectionHeadingTableCell", bundle: nil), forCellReuseIdentifier: "SectionHeadingTableCell")
        studyTableView.register(UINib(nibName: "StudyCell", bundle: nil), forCellReuseIdentifier: "StudyCell")
        changeNavBarAppearanceForWithoutHeader()
        changeNavBarToTransparent()
        
        autoCompleteTable = UIView.instanceFromNib(type: AutoCompleteTable.self)!
        autoCompleteTable.delegate = self
        autoCompleteBackView.backgroundColor = UIColor.clear
        autoCompleteBackView.isHidden = true
        autoCompleteTable.isHidden = true
        autoCompleteTable.layer.cornerRadius = 8.0
        autoCompleteTable.clipsToBounds = true
        view.addSubview(autoCompleteBackView)
        autoCompleteBackView.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        autoCompleteBackView.addGestureRecognizer(tapGesture)
        view.addSubview(autoCompleteTable)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
        hideAutoCompleteView()
    }
    
    func hideAutoCompleteView() {
        autoCompleteBackView.isHidden = true
        autoCompleteTable.isHidden = true
    }
    
    // MARK: - Keyboard Show Hide Observers
    
    @objc func keyboardWillShow(note: NSNotification) {
        if let keyboardSize = (note.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            studyTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height + 200, right: 0)
        }
    }
    
    @objc func keyboardWillHide(note _: NSNotification) {
        studyTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    // MARK: - IBActions
    
    @IBAction func nextButtonClicked(_: Any) {
        if selectedData.count == 0 {
            makeToast(toastString: "Please fill atleast one school")
            return
        }
        preparePostSchoolData(schoolsSelected: selectedData)
    }
    
    func openSkillsScreen() {
        let skillsVC = UIStoryboard.profileStoryBoard().instantiateViewController(type: DMSkillsVC.self)!
        
        let selectSkillsVC = UIStoryboard.profileStoryBoard().instantiateViewController(type: DMSelectSkillsVC.self)!
        
        let sideMenu = SSASideMenu(contentViewController: skillsVC, rightMenuViewController: selectSkillsVC)
        sideMenu.panGestureEnabled = false
        sideMenu.delegate = skillsVC
        navigationController?.pushViewController(sideMenu, animated: true)
    }
}

extension DMStudyVC: AutoCompleteSelectedDelegate {
    
    // MARK: - AutoComplete List Delegates
    
    func didSelect(schoolCategoryId: String, university: University) {
        hideAutoCompleteView()
        let school = schoolCategories.filter({ $0.schoolCategoryId == schoolCategoryId }).first
        
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
                if let dict = category as? NSMutableDictionary,let parentId = dict["parentId"] as? String, parentId == "\(schoolCategoryId)" {
                    dict["other"] = university.universityName
                    dict["parentName"] = school?.schoolCategoryName
                    flag = 1
                }
            }
            
            // Array is > 0 but dict doesnt exists
            if flag == 0 {
                let dict = NSMutableDictionary()
                dict["parentId"] = schoolCategoryId as AnyObject?
                dict["schoolId"] = university.universityId as AnyObject?
                dict["other"] = university.universityName
                dict["parentName"] = school?.schoolCategoryName
                dict["yearOfGraduation"] = ""
                selectedData.add(dict)
            }
            
            // debugPrint(selectedData)
            
            studyTableView.reloadData()
        }
    }
    
}

extension DMStudyVC: YearPickerViewDelegate {
    func canceButtonAction() {
        view.endEditing(true)
    }
    
    func doneButtonAction(year: Int, tag: Int) {
        var flag = 0
        if year == -1 {
        }
        if selectedData.count == 0 {
            let dict = NSMutableDictionary()
            dict["parentId"] = "\(tag)"
            dict["schoolId"] = "\(tag)"
            if year == -1 {
                dict["yearOfGraduation"] = ""
            } else {
                dict["yearOfGraduation"] = "\(year)"
            }
            
            if let _ = dict["other"] {
                // debugPrint("handle other")
            } else {
                dict["other"] = ""
            }
            selectedData.add(dict)
            flag = 1
        } else {
            for category in selectedData {
                if let dict = category as? NSMutableDictionary,let parentId = dict["parentId"] as? String, parentId == "\(tag)" {
                    if year == -1 {
                        dict["yearOfGraduation"] = ""
                    } else {
                        dict["yearOfGraduation"] = "\(year)"
                    }
                    
                    if let _ = dict["other"] {
                        // debugPrint("handle other")
                    } else {
                        dict["other"] = ""
                    }
                    flag = 1
                }
            }
        }
        
        // Array is > 0 but dict doesnt exists
        if flag == 0 {
            let dict = NSMutableDictionary()
            dict["parentId"] = "\(tag)"
            dict["schoolId"] = "\(tag)"
            //            dict["yearOfGraduation"] = "\(year)"
            if year == -1 {
                dict["yearOfGraduation"] = ""
            } else {
                dict["yearOfGraduation"] = "\(year)"
            }
            
            if let _ = dict["other"] {
                // debugPrint("handle other")
            } else {
                makeToast(toastString: "Please enter school name first")
                dict["other"] = ""
            }
            selectedData.add(dict)
        }
        // debugPrint(selectedData)
        studyTableView.reloadData()
    }
}

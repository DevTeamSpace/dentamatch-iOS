//
//  DMEditStudyVC.swift
//  DentaMatch
//
//  Created by Rajan Maheshwari on 27/01/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

class DMEditStudyVC: DMBaseVC {
    @IBOutlet var studyTableView: UITableView!

    var isFilledFromAutoComplete = false
    var schoolCategories = [SchoolCategory]()
    var selectedSchoolCategories = [SelectedSchool]()
    var autoCompleteTable: AutoCompleteTable!
    var selectedData = NSMutableArray()
    let autoCompleteBackView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height))
    var yearPicker: YearPickerView?

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        getSchoolListAPI()
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: - Keyboard Show Hide Observers

    @objc func keyboardWillShow(note: NSNotification) {
        if let keyboardSize = (note.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            studyTableView.contentInset = UIEdgeInsetsMake(0, 0, keyboardSize.height + 200, 0)
        }
    }

    @objc func keyboardWillHide(note _: NSNotification) {
        studyTableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
    }

    func setup() {
        yearPicker = YearPickerView.loadYearPickerView(withText: "", withTag: 0)
        yearPicker?.delegate = self
        studyTableView.register(UINib(nibName: "StudyCell", bundle: nil), forCellReuseIdentifier: "StudyCell")
        title = "EDIT PROFILE"
        changeNavBarAppearanceForDefault()
        navigationItem.leftBarButtonItem = backBarButton()

        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        studyTableView.addGestureRecognizer(tap)

        studyTableView.separatorColor = UIColor.clear
        studyTableView.register(UINib(nibName: "PhotoNameCell", bundle: nil), forCellReuseIdentifier: "PhotoNameCell")
        studyTableView.register(UINib(nibName: "SectionHeadingTableCell", bundle: nil), forCellReuseIdentifier: "SectionHeadingTableCell")
        studyTableView.register(UINib(nibName: "StudyCell", bundle: nil), forCellReuseIdentifier: "StudyCell")

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

    func updateProfileScreen() {
        selectedSchoolCategories.removeAll()
        for school in selectedData {
            if let dict = school as? NSMutableDictionary {
                let selectedSchool = SelectedSchool()
                selectedSchool.schoolCategoryId = (dict["parentId"] as? String) ?? ""
                selectedSchool.universityId = (dict["schoolId"]  as? String) ?? ""
                selectedSchool.universityName = (dict["other"]  as? String) ?? ""
                selectedSchool.yearOfGraduation = dict["yearOfGraduation"] as? String ?? ""
                selectedSchool.schoolCategoryName = dict["parentName"] as? String ?? ""
                selectedSchoolCategories.append(selectedSchool)
            }
            
        }
        NotificationCenter.default.post(name: .updateProfileScreen, object: nil, userInfo: ["schools": self.selectedSchoolCategories])
    }

    @IBAction func saveButtonPressed(_: Any) {
        if selectedData.count == 0 {
            makeToast(toastString: "Please fill atleast one school")
            return
        }
       var isSchoolEmpty = false
       var isYearEmpty = false
        for category in selectedData {
            if let dict = category as? NSMutableDictionary {
                // Both school name and year of graduation are empty ...
                if ((dict["other"] as? String) ?? "").isEmptyField && ((dict["yearOfGraduation"] as? String) ?? "").isEmptyField {
                    dict["schoolId"] = ""
                    dict["yearOfGraduation"] = ""
                } else if ((dict["other"] as? String) ?? "").isEmptyField && !((dict["yearOfGraduation"] as? String) ?? "").isEmptyField {
                    //  school name is empty and year of graduation are non- empty ...
                    isSchoolEmpty = true
                    dict["schoolId"] = ""
                }else if !((dict["other"] as? String) ?? "").isEmptyField && ((dict["yearOfGraduation"] as? String) ?? "").isEmptyField {
                    //  school name is empty and year of graduation are non- empty ...
                    isYearEmpty = true
                    dict["yearOfGraduation"] = ""
                }
            }
        }
        debugPrint(selectedData.description)
        if isSchoolEmpty {
            makeToast(toastString: "Please enter school name first")
            return
        }
        if isYearEmpty {
            makeToast(toastString: "Please enter graduation year.")
            return
        }
        preparePostSchoolData(schoolsSelected: selectedData)
    }
}

extension DMEditStudyVC: AutoCompleteSelectedDelegate {
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
                if let dict = category as? NSMutableDictionary, let parentId = dict["parentId"] as? String {
                    if parentId == "\(schoolCategoryId)" {
                        dict["other"] = university.universityName
                        dict["parentName"] = school?.schoolCategoryName
                        flag = 1
                    }
                }
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

    func removeEmptyYear() {
        let emptyData = NSMutableArray()
        for category in selectedData {
            if let dict = category as? NSMutableDictionary {
                if ((dict["other"] as? String) ?? "").isEmptyField {
                    emptyData.add(dict)
                }
            }
        }
        // debugPrint(selectedData.description)
        selectedData.removeObjects(in: emptyData as [AnyObject])
        studyTableView.reloadData()
    }
}

extension DMEditStudyVC: YearPickerViewDelegate {
    func canceButtonAction() {
        view.endEditing(true)
    }

    func doneButtonAction(year: Int, tag: Int) {
        var flag = 0
        if selectedData.count == 0 {
            let dict = NSMutableDictionary()
            dict["parentId"] = "\(tag)"
            dict["schoolId"] = "\(tag)"
            if year == -1 {
                dict["yearOfGraduation"] = ""
                removeEmptyYear()
            } else {
                dict["yearOfGraduation"] = "\(year)"
            }

            if let _ = dict["other"] {
                // debugPrint("Other dict")
            } else {
                dict["other"] = ""
            }
            selectedData.add(dict)
            flag = 1
        } else {
            for category in selectedData {
                if let dict = category as? NSMutableDictionary, let parentId = dict["parentId"] as? String {
                    if parentId == "\(tag)" {
                        if year == -1 {
                            dict["yearOfGraduation"] = ""
                        } else {
                            dict["yearOfGraduation"] = "\(year)"
                        }
                        if let _ = dict["other"] {
                            // debugPrint("Other dict")
                        } else {
                            dict["other"] = ""
                        }
                        flag = 1
                    }
                }
            }
        }

        // Array is > 0 but dict doesnt exists
        if flag == 0 {
            let dict = NSMutableDictionary()
            dict["parentId"] = "\(tag)"
            dict["schoolId"] = "\(tag)"
            if year == -1 {
                dict["yearOfGraduation"] = ""
                removeEmptyYear()
            } else {
                dict["yearOfGraduation"] = "\(year)"
            }

            if let _ = dict["other"] {
                // debugPrint("Other dict")
            } else {
                dict["other"] = ""
            }
            selectedData.add(dict)
        }
        // debugPrint(selectedData)
        studyTableView.reloadData()
    }
}

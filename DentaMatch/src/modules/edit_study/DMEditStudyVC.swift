import UIKit

class DMEditStudyVC: DMBaseVC {
    @IBOutlet weak var studyTableView: UITableView!
    @IBOutlet weak var overlayView: UIView!
    
    var autoCompleteTable: AutoCompleteTable!
    let autoCompleteBackView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height))
    var yearPicker: YearPickerView?
    
    var viewOutput: DMEditStudyViewOutput?
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        
        viewOutput?.getSchoolList()
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

    // MARK: - Keyboard Show Hide Observers

    @objc func keyboardWillShow(note: NSNotification) {
        if let keyboardSize = (note.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            studyTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height + 140, right: 0)
        }
    }

    @objc func keyboardWillHide(note _: NSNotification) {
        studyTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
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

    

    @IBAction func saveButtonPressed(_: Any) {
        if viewOutput?.selectedData.count == 0 {
            makeToast(toastString: "Please fill atleast one school")
            return
        }
        
       var isSchoolEmpty = false
       var isYearEmpty = false
        for category in viewOutput?.selectedData ?? NSMutableArray() {
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
        
        if isSchoolEmpty {
            makeToast(toastString: "Please enter school name first")
            return
        }
        if isYearEmpty {
            makeToast(toastString: "Please enter graduation year.")
            return
        }
        
        viewOutput?.addSchool()
    }
}

extension DMEditStudyVC: DMEditStudyViewInput {
    
    func reloadData() {
        studyTableView.reloadData()
    }
}

extension DMEditStudyVC: AutoCompleteSelectedDelegate {
    func didSelect(schoolCategoryId: String, university: University) {
        hideAutoCompleteView()

        viewOutput?.didSelect(schoolCategoryId: schoolCategoryId, university: university)
    }
}

extension DMEditStudyVC: YearPickerViewDelegate {
    func canceButtonAction() {
        view.endEditing(true)
    }

    func doneButtonAction(year: Int, tag: Int) {
        viewOutput?.onDoneButtonTap(year: year, tag: tag)
    }
}

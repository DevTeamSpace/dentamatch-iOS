//
//  DMWorkExperienceVC.swift
//  DentaMatch
//
//  Created by Sanjay Kumar Yadav on 03/01/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

enum FieldType: Int, CustomStringConvertible {
    case CurrentJobTitle = 1
    case YearOfExperience = 2
    case OfficeName = 3
    case OfficeAddress = 4
    case CityName = 5
    case StateName = 6
    case ReferenceName = 7
    case ReferenceMobileNo = 8
    case ReferenceEmail = 9

    var description: String {
        switch self {
        case .CurrentJobTitle:
            return "Job Title"
        case .YearOfExperience:
            return "Time at This Job"
        case .OfficeName:
            return "Office Name"
        case .OfficeAddress:
            return "Office Address"
        case .CityName:
            return "City"
        case .StateName:
            return "State"
        case .ReferenceName:
            return "Reference Name (Optional)"
        case .ReferenceMobileNo:
            return "Reference Phone Number (Optional)"
        case .ReferenceEmail:
            return "Reference Email (Optional)"
        }
    }
}

class DMWorkExperienceVC: DMBaseVC, ExperiencePickerViewDelegate, ToolBarButtonDelegate {
    let NAVBAR_CHANGE_POINT: CGFloat = 64
    var exprienceArray = [ExperienceModel]()
    var exprienceDetailArray: NSMutableArray?
    var currentExperience: ExperienceModel? = ExperienceModel(empty: "")
    var phoneFormatter = PhoneNumberFormatter()
    var jobTitles = [JobTitle]()
    var selectedIndex: Int = 0
    var isHiddenExperienceTable: Bool = false
    var isEditMode = false

    @IBOutlet var viewForTopHeader: UIView!
    @IBOutlet var nextButton: UIButton!

    @IBOutlet var mainScrollView: UIScrollView!
    @IBOutlet var workExperienceTable: UITableView!
    @IBOutlet var workExperienceDetailTable: UITableView!
    @IBOutlet var hightOfExperienceTable: NSLayoutConstraint!
    @IBOutlet var hightOfExperienceDetailTable: NSLayoutConstraint!
    @IBOutlet var heightOfScrollView: NSLayoutConstraint!
    @IBOutlet var topHeaderViewHeight: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        initialDataSetup()
        getExperienceAPI()

        if isEditMode != true {
//            getExperienceAPI()
        } else {
            nextButton.setTitle("SAVE", for: .normal)
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if isEditMode != true {
            topHeaderViewHeight.constant = 0
        } else {
        }
        view.layoutIfNeeded()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)

        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.navigationBar.setBackgroundImage(nil, for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = nil
        navigationController?.navigationBar.isTranslucent = false
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
        workExperienceDetailTable.register(UINib(nibName: "AnimatedPHTableCell", bundle: nil), forCellReuseIdentifier: "AnimatedPHTableCell")
        workExperienceDetailTable.register(UINib(nibName: "ReferenceTableCell", bundle: nil), forCellReuseIdentifier: "ReferenceTableCell")
        workExperienceDetailTable.register(UINib(nibName: "AddDeleteExperienceCell", bundle: nil), forCellReuseIdentifier: "AddDeleteExperienceCell")
        navigationItem.leftBarButtonItem = backBarButton()
        workExperienceTable.separatorStyle = .none
        workExperienceDetailTable.separatorStyle = .none
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        workExperienceDetailTable.addGestureRecognizer(tap)
//        self.mainScrollView.isExclusiveTouch = true

        workExperienceDetailTable.reloadData()
        if isEditMode {
            title = "EDIT PROFILE"
            changeNavBarAppearanceForDefault()
        } else {
            changeNavBarAppearanceForProfiles()
            title = Constants.ScreenTitleNames.workExperience
        }
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

    @IBAction func nextButtonClicked(_: Any) {
        if !checkAllFieldIsEmpty() {
            saveDataOnNextButton()
        } else if exprienceArray.count > 0 && checkAllFieldIsEmpty() {
            navigateAction()
        } else {
            // alert here for
            let alert = UIAlertController(title: "WORK EXPERIENCE", message: Constants.AlertMessage.partialFill, preferredStyle: .alert)
            let leftButtonAction = UIAlertAction(title: "DISCARD", style: .default) { (_: UIAlertAction) in
                alert.dismiss(animated: true, completion: nil)
                self.navigateAction()
            }

            let rightButtonAction = UIAlertAction(title: "SAVE", style: .default) { (_: UIAlertAction) in
                alert.dismiss(animated: true, completion: nil)

                self.saveDataOnNextButton()
            }

            alert.addAction(leftButtonAction)
            alert.addAction(rightButtonAction)

            present(alert, animated: true, completion: nil)
        }

//        if self.exprienceArray.count > 0
//        {
//            if checkAllFieldIsEmpty() {
//                if isEditMode == true {
//                    _ = self.navigationController?.popViewController(animated: true)
//                }else {
//                    self.performSegue(withIdentifier: Constants.StoryBoard.SegueIdentifier.goToStudyVC, sender: self)
//                }
//            }else {
//                saveDataOnNextButton()
//            }
//        }else {
//            self.makeToast(toastString: Constants.AlertMessage.atleastOneExperience)
//        }
    }

    func navigateAction() {
        if isEditMode == true {
            _ = navigationController?.popViewController(animated: true)
        } else {
            guard let vc = DMStudyInitializer.initialize() as? DMStudyVC else { return }
            navigationController?.pushViewController(vc, animated: true)
        }
    }

    // MARK: - Keyboard Show Hide Observers

    @objc func keyboardWillShow(note: NSNotification) {
        if let keyboardSize = (note.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            mainScrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height + 10, right: 0)
        }
    }

    @objc func keyboardWillHide(note _: NSNotification) {
        mainScrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }

    func initialDataSetup() {
        let exp = ExperienceModel(empty: "")
        exprienceDetailArray?.add(exp)
        if exprienceArray.count > 0 {
            currentExperience?.isFirstExperience = false
        }
        currentExperience?.references.append(EmployeeReferenceModel(empty: ""))
        workExperienceTable.reloadData()
        workExperienceDetailTable.reloadData()
        reSizeTableViewsAndScrollView()
    }

    func reSizeTableViewsAndScrollView() {
        if isHiddenExperienceTable == true {
            hightOfExperienceTable.constant = 0

        } else {
            hightOfExperienceTable.constant = workExperienceTable.contentSize.height
        }
        hightOfExperienceDetailTable.constant = workExperienceDetailTable.contentSize.height
        workExperienceTable.layoutIfNeeded()
        workExperienceDetailTable.layoutIfNeeded()
        mainScrollView.contentSize = CGSize(width: view.bounds.size.width, height: hightOfExperienceTable.constant + hightOfExperienceDetailTable.constant)
    }

    func saveDataOnNextButton() {
        view.endEditing(true)
        if !checkValidations() {
            return
        }
        var param = [String: AnyObject]()
        if currentExperience?.isEditMode == true {
            param = getParamsForSaveAndUpdate(isEdit: true)
        } else {
            param = getParamsForSaveAndUpdate(isEdit: false)
        }
        saveUpdateExperience(params: param, completionHandler: { response, _ in

            if response![Constants.ServerKey.status].boolValue {
                let resultArray = response![Constants.ServerKey.result][Constants.ServerKey.list].array
                if (resultArray?.count)! > 0 {
                    let dict = resultArray?[0].dictionary
                    self.currentExperience?.experienceID = (dict?[Constants.ServerKey.experienceId]?.intValue)!
                }
                if self.currentExperience?.isEditMode == true {
                    self.exprienceArray[self.selectedIndex] = self.currentExperience!

                } else {
                    self.exprienceArray.append(self.currentExperience!)
                }
                self.isHiddenExperienceTable = false

                self.currentExperience = nil
                self.currentExperience = ExperienceModel(empty: "")
                self.currentExperience?.isFirstExperience = false
                self.currentExperience?.references.append(EmployeeReferenceModel(empty: ""))
                self.workExperienceTable.reloadData()
                self.workExperienceDetailTable.reloadData()
                self.reSizeTableViewsAndScrollView()

                self.updateProfileScreen()
                if self.isEditMode == true {
                    _ = self.navigationController?.popViewController(animated: true)
                } else {
                    guard let vc = DMStudyInitializer.initialize() as? DMStudyVC else { return }
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        })
        workExperienceTable.reloadData()
        workExperienceDetailTable.reloadData()
        //        self.makeToast(toastString: "Experience Added")
        reSizeTableViewsAndScrollView()
    }

    func updateProfileScreen() {
        NotificationCenter.default.post(name: .updateProfileScreen, object: nil, userInfo: ["workExperiences": self.exprienceArray])
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    
    func goToStates(_ text: String?) {
        guard let searchVc = SearchStateInitializer.initialize() as? SearchStateViewController else { return }
        searchVc.delegate = self
        searchVc.preSelectedState = currentExperience?.stateName
        self.navigationController?.pushViewController(searchVc, animated: true)
    }
}

extension DMWorkExperienceVC: JobSelectionPickerViewDelegate {
    func jobPickerDoneButtonAction(job: JobTitle?) {
        if let jobTitle = job {
            currentExperience?.jobTitle = jobTitle.jobTitle
            currentExperience?.jobTitleID = jobTitle.jobId
            workExperienceDetailTable.reloadData()
        }
        view.endEditing(true)
    }

    func jobPickerCancelButtonAction() {
        view.endEditing(true)
    }
}
//MARK: SearchStateView Delegates
extension DMWorkExperienceVC: SearchStateViewControllerDelegate {
    func selectedState(state: String?) {
         currentExperience?.stateName = state
        //editProfileParams[Constants.ServerKey.state] = state
        self.workExperienceDetailTable.reloadData()
    }
}

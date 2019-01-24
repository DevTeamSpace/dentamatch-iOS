//
//  DMWorkExperienceStart.swift
//  DentaMatch
//
//  Created by Sanjay Kumar Yadav on 04/01/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

class DMWorkExperienceStart: DMBaseVC, ExperiencePickerViewDelegate {
    @IBOutlet var workExperienceTable: UITableView!
    let profileProgress: CGFloat = 0.25

    var selectedJobTitle: JobTitle!
    var experienceArray = NSMutableArray()
    var jobTitles = [JobTitle]()
    var totalExperience = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        experienceArray.addObjects(from: [selectedJobTitle.jobTitle, "", ""])
        title = Constants.ScreenTitleNames.workExperience
        setUp()

        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        changeNavBarAppearanceForProfiles()
        navigationController?.navigationBar.setBackgroundImage(nil, for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = nil
        navigationController?.navigationBar.isTranslucent = false
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        workExperienceTable.reloadData()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: - Keyboard Show Hide Observers

    @objc func keyboardWillShow(note: NSNotification) {
        if let keyboardSize = (note.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            workExperienceTable.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height + 1, right: 0)
        }
    }

    @objc func keyboardWillHide(note _: NSNotification) {
        workExperienceTable.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }

    func setUp() {
        workExperienceTable.register(UINib(nibName: "AnimatedPHTableCell", bundle: nil), forCellReuseIdentifier: "AnimatedPHTableCell")
        workExperienceTable.register(UINib(nibName: "PhotoNameCell", bundle: nil), forCellReuseIdentifier: "PhotoNameCell")
        workExperienceTable.separatorStyle = .none
        workExperienceTable.register(UINib(nibName: "SectionHeadingTableCell", bundle: nil), forCellReuseIdentifier: "SectionHeadingTableCell")

        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        workExperienceTable.addGestureRecognizer(tap)

        workExperienceTable.reloadData()
        navigationItem.leftBarButtonItem = backBarButton()
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // goToExperienceDetail
    @IBAction func nextButtonClicked(_: Any) {
        for i in 0 ..< experienceArray.count {
            let text = experienceArray[i] as? String ?? ""
            if i == 0 {
                if text.isEmptyField {
                    makeToast(toastString: Constants.AlertMessage.emptyCurrentJobTitle)
                    return
                }
            } else if i == 1 {
                if text.isEmptyField {
                    makeToast(toastString: Constants.AlertMessage.emptyYearOfExperience)
                    return
                }
            } else if i == 2 {
                if text.isEmptyField {
                    makeToast(toastString: Constants.AlertMessage.emptyOfficeName)
                    return
                }
            }
        }

        performSegue(withIdentifier: "goToExperienceDetail", sender: self)
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender _: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "goToExperienceDetail" {
            guard let destinationVC: DMWorkExperienceVC = segue.destination as? DMWorkExperienceVC else { return }
            destinationVC.currentExperience?.jobTitleID = selectedJobTitle.jobId
            destinationVC.currentExperience?.jobTitle = experienceArray[0] as? String
            destinationVC.currentExperience?.yearOfExperience = experienceArray[1] as? String
            destinationVC.jobTitles = jobTitles
            destinationVC.currentExperience?.experienceInMonth = totalExperience
            destinationVC.currentExperience?.officeName = experienceArray[2] as? String
        }
    }
}

extension DMWorkExperienceStart: JobSelectionPickerViewDelegate {
    func jobPickerDoneButtonAction(job: JobTitle?) {
        if let jobTitle = job {
            selectedJobTitle = jobTitle
            experienceArray.replaceObject(at: 0, with: jobTitle.jobTitle)
            workExperienceTable.reloadData()
        }
        view.endEditing(true)
    }

    func jobPickerCancelButtonAction() {
        view.endEditing(true)
    }
}

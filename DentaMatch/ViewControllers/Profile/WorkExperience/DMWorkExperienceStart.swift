//
//  DMWorkExperienceStart.swift
//  DentaMatch
//
//  Created by Sanjay Kumar Yadav on 04/01/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

class DMWorkExperienceStart: DMBaseVC,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,ExperiencePickerViewDelegate {
    @IBOutlet weak var workExperienceTable: UITableView!
    let profileProgress:CGFloat = 0.25

    var selectedJobTitle:JobTitle!
    var experienceArray = NSMutableArray()
    var jobTitles = [JobTitle]()
    var totalExperience = 0

    
    override func viewDidLoad() {
        super.viewDidLoad()
        experienceArray.addObjects(from: [selectedJobTitle.jobTitle,"",""])
        self.title = "Work Experience"
        setUp()
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        self.changeNavBarAppearanceForProfiles()
        self.navigationController?.navigationBar.setBackgroundImage(nil, for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = nil
        self.navigationController?.navigationBar.isTranslucent = false

    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        self.workExperienceTable.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    //MARK:- Keyboard Show Hide Observers
    func keyboardWillShow(note: NSNotification) {
        if let keyboardSize = (note.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            self.workExperienceTable.contentInset =  UIEdgeInsetsMake(0, 0, keyboardSize.height+1, 0)
        }
    }
    func keyboardWillHide(note: NSNotification) {
        self.workExperienceTable.contentInset =  UIEdgeInsetsMake(0, 0, 0, 0)
    }
    

    func setUp() {
        self.workExperienceTable.register(UINib(nibName: "AnimatedPHTableCell", bundle: nil), forCellReuseIdentifier: "AnimatedPHTableCell")
        self.workExperienceTable.register(UINib(nibName: "PhotoNameCell", bundle: nil), forCellReuseIdentifier: "PhotoNameCell")
        workExperienceTable.separatorStyle = .none
        self.workExperienceTable.register(UINib(nibName: "SectionHeadingTableCell", bundle: nil), forCellReuseIdentifier: "SectionHeadingTableCell")

        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.workExperienceTable.addGestureRecognizer(tap)

        self.workExperienceTable.reloadData()
        self.navigationItem.leftBarButtonItem = self.backBarButton()

    }

    func dismissKeyboard() {
        self.view.endEditing(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //goToExperienceDetail
    @IBAction func nextButtonClicked(_ sender: Any) {
        
        for i in 0..<self.experienceArray.count {
            let text = self.experienceArray[i] as! String
            if i == 0 {
                if text.isEmptyField {
                    self.makeToast(toastString: Constants.AlertMessage.emptyCurrentJobTitle)
                    return
                }
            }else if i == 1{
                if text.isEmptyField {
                    self.makeToast(toastString: Constants.AlertMessage.emptyYearOfExperience)
                    return
                }
            }else if i == 2 {
                if text.isEmptyField {
                    self.makeToast(toastString: Constants.AlertMessage.emptyOfficeName)
                    return
                }
            }
        }

        self.performSegue(withIdentifier: "goToExperienceDetail", sender: self)

    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "goToExperienceDetail"
        {
            let destinationVC:DMWorkExperienceVC = segue.destination as! DMWorkExperienceVC
            destinationVC.currentExperience?.jobTitleID = self.selectedJobTitle.jobId
            destinationVC.currentExperience?.jobTitle = self.experienceArray[0] as? String
            destinationVC.currentExperience?.yearOfExperience = self.experienceArray[1] as? String
            destinationVC.jobTitles = self.jobTitles
            destinationVC.currentExperience?.experienceInMonth = self.totalExperience
            destinationVC.currentExperience?.officeName = self.experienceArray[2] as? String
        }
    }


}

extension DMWorkExperienceStart:JobSelectionPickerViewDelegate {
    
    func jobPickerDoneButtonAction(job: JobTitle?) {
        if let jobTitle = job {
            self.selectedJobTitle = jobTitle
            self.experienceArray.replaceObject(at: 0, with: jobTitle.jobTitle)
            self.workExperienceTable.reloadData()
        }
        self.view.endEditing(true)
    }
    
    func jobPickerCancelButtonAction() {
        self.view.endEditing(true)
    }
}

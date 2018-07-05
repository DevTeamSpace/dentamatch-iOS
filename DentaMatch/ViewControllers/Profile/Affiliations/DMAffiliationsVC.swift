//
//  DMAffiliationsVC.swift
//  DentaMatch
//
//  Created by Rajan Maheshwari on 10/01/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

class DMAffiliationsVC: DMBaseVC {
    enum Affiliations: Int {
        case profileHeader
        case affiliation
        case affiliationOther
    }

    @IBOutlet var headerViewForEditProfileHeight: NSLayoutConstraint!
    @IBOutlet var headerViewForEditProfile: UIView!
    @IBOutlet var nextButton: UIButton!
    @IBOutlet var affiliationsTableView: UITableView!

    let profileProgress: CGFloat = 0.80
    var isOtherSelected = false
    var otherText = ""
    var selectedAffiliationsFromProfile = [Affiliation]()
    var affiliations = [Affiliation]()
    var isEditMode = false

    // MARK: - View LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        getAffiliationListAPI()
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: - Keyboard Show Hide Observers

    @objc func keyboardWillShow(note: NSNotification) {
        if let keyboardSize = (note.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            affiliationsTableView.contentInset = UIEdgeInsetsMake(0, 0, keyboardSize.height + 10, 0)
//            DispatchQueue.main.async {
//                self.affiliationsTableView.scrollToRow(at: IndexPath(row: 0, section: 1), at: .top, animated: true)
//            }
        }
    }

    @objc func keyboardWillHide(note _: NSNotification) {
        affiliationsTableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
    }

    // MARK: - Private Methods

    func setup() {
        navigationItem.leftBarButtonItem = backBarButton()
        affiliationsTableView.separatorColor = UIColor.clear
        affiliationsTableView.register(UINib(nibName: "PhotoNameCell", bundle: nil), forCellReuseIdentifier: "PhotoNameCell")
        affiliationsTableView.register(UINib(nibName: "SectionHeadingTableCell", bundle: nil), forCellReuseIdentifier: "SectionHeadingTableCell")
        affiliationsTableView.register(UINib(nibName: "AffiliationsCell", bundle: nil), forCellReuseIdentifier: "AffiliationsCell")
        affiliationsTableView.register(UINib(nibName: "AffliliationsOthersCell", bundle: nil), forCellReuseIdentifier: "AffliliationsOthersCell")
        if isEditMode {
            title = "EDIT PROFILE"
            nextButton.setTitle("SAVE", for: .normal)
            headerViewForEditProfile.isHidden = false
        } else {
            headerViewForEditProfileHeight.constant = 0
            view.layoutIfNeeded()
        }
    }

    func addToolBarOnTextView() -> UIToolbar {
        let keyboardDoneButtonView = UIToolbar()
        keyboardDoneButtonView.sizeToFit()
        keyboardDoneButtonView.barTintColor = Constants.Color.toolBarColor
        // Setup the buttons to be put in the system.
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: self, action: nil)

        let item = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(toolBarButtonPressed))
        item.tag = 2
        item.setTitleTextAttributes([NSAttributedStringKey.font: UIFont.fontRegular(fontSize: 20.0)!], for: UIControlState.normal)

        item.tintColor = UIColor.white

        let toolbarButtons = [flexibleSpace, item]

        // Put the buttons into the ToolBar and display the tool bar
        keyboardDoneButtonView.setItems(toolbarButtons, animated: false)

        return keyboardDoneButtonView
    }

    func openCertificationScreen() {
        performSegue(withIdentifier: Constants.StoryBoard.SegueIdentifier.goToCertificationsVC, sender: self)
    }

    @objc func toolBarButtonPressed() {
        view.endEditing(true)
    }

    // MARK: - IBActions

    @IBAction func nextButtonClicked(_: Any) {
        makeAffiliationData()
    }

    // Making the post data for affiliation post API
    func makeAffiliationData() {
        view.endEditing(true)
        var params = [String: AnyObject]()
        var other = [[String: String]]()
        var otherObject = [String: String]()
        var selectedAffiliationIds = [String]()
        for affiliation in affiliations {
            if affiliation.isSelected {
                if !affiliation.isOther {
                    selectedAffiliationIds.append(affiliation.affiliationId)
                }
            }
        }

        // For other affiliation
        let affiliationArray = affiliations.filter { (obj) -> Bool in
            obj.affiliationId == "9"
        } // affiliations[affiliations.count - 1]
        if affiliationArray.count > 0 {
            let affiliation = affiliationArray[0]
            if affiliation.isSelected {
                if let otherAffiliation = affiliation.otherAffiliation {
                    if otherAffiliation.trim().isEmpty {
                        makeToast(toastString: "Other Affiliation can't be empty")
                        return
                    }
                    otherObject[Constants.ServerKey.affiliationId] = affiliation.affiliationId
                    otherObject[Constants.ServerKey.otherAffiliation] = otherText
                    other.append(otherObject)
                }
            }
            if !affiliation.isSelected {
                if selectedAffiliationIds.count == 0 {
                    makeToast(toastString: "Please select atleast one affiliation")
                    return
                }
            }
        }

        params[Constants.ServerKey.affiliationDataArray] = selectedAffiliationIds as AnyObject?
        params[Constants.ServerKey.other] = other as AnyObject?
        saveAffiliationData(params: params)
    }

    // For edit mode from Edit Profile
    func manageSelectedAffiliations() {
        NotificationCenter.default.post(name: .updateProfileScreen, object: nil, userInfo: ["affiliations": affiliations.filter({ $0.isSelected == true })])
    }
}

extension DMAffiliationsVC: UITextViewDelegate {
    func textViewShouldBeginEditing(_: UITextView) -> Bool {
//        self.affiliationsTableView.contentInset =  UIEdgeInsetsMake(0, 0, 200, 0)
//        DispatchQueue.main.async {
//            self.affiliationsTableView.scrollToRow(at: IndexPath(row: 0, section: 1), at: .middle, animated: true)
//        }
        return true
    }

    func textViewShouldEndEditing(_: UITextView) -> Bool {
        affiliationsTableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)

        return true
    }

    func textViewDidChange(_ textView: UITextView) {
        let affiliation = affiliations.filter { (obj) -> Bool in
            obj.affiliationId == "9"
        } // affiliations[affiliations.count - 1]
        if affiliation.count > 0 {
            affiliation[0].otherAffiliation = textView.text!
        }
        otherText = textView.text
    }
}

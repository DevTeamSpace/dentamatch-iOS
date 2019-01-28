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
    var activeView: UITextView?
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
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: - Keyboard Show Hide Observers

    @objc func keyboardWillShow(note: NSNotification) {
        if let kbSize = (note.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: kbSize.height, right: 0.0)
            affiliationsTableView.contentInset = contentInsets
            affiliationsTableView.scrollIndicatorInsets = contentInsets;
            
            // If active text field is hidden by keyboard, scroll it so it's visible
            // Your app might not need or want this behavior.
            var aRect = self.affiliationsTableView.frame
            if activeView != nil {
                var reducingFactor : CGFloat = 300.0
                if UIDevice.current.screenType == .iPhone5{
                    reducingFactor = 220.0
                } else if UIDevice.current.screenType == .iPhone6Plus{
                    reducingFactor = 380.0
                } else if UIDevice.current.screenType == .iPhoneX{
                    reducingFactor = 500.0
                }
                aRect.size.height += kbSize.height - reducingFactor
                //if (!aRect.contains((activeView?.frame.origin)!) ) {
                self.affiliationsTableView.scrollRectToVisible(aRect, animated: true)
                //}
            }
            
        }
    }

    @objc func keyboardWillHide(note _: NSNotification) {
        affiliationsTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
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
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: self, action: nil)

        let item = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(toolBarButtonPressed))
        item.tag = 2
        item.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.fontRegular(fontSize: 20.0)], for: UIControl.State.normal)

        item.tintColor = UIColor.white

        let toolbarButtons = [flexibleSpace, item]

        // Put the buttons into the ToolBar and display the tool bar
        keyboardDoneButtonView.setItems(toolbarButtons, animated: false)

        return keyboardDoneButtonView
    }

    func openCertificationScreen() {
        guard let vc = DMCertificationsInitializer.initialize() as? DMCertificationsVC else { return }
        navigationController?.pushViewController(vc, animated: true)
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
                        makeToast(toastString: "Other affiliation can't be empty")
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
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        activeView = textView
        return true
    }

    func textViewShouldEndEditing(_: UITextView) -> Bool {
        return true
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        activeView = nil
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

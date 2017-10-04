//
//  DMAffiliationsVC.swift
//  DentaMatch
//
//  Created by Rajan Maheshwari on 10/01/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

class DMAffiliationsVC: DMBaseVC {

    enum Affiliations:Int {
        case profileHeader
        case affiliation
        case affiliationOther
    }
    
    @IBOutlet weak var headerViewForEditProfileHeight: NSLayoutConstraint!
    @IBOutlet weak var headerViewForEditProfile: UIView!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var affiliationsTableView: UITableView!
    
    let profileProgress:CGFloat = 0.80
    var isOtherSelected = false
    var otherText = ""
    var selectedAffiliationsFromProfile = [Affiliation]()
    var affiliations = [Affiliation]()
    var isEditMode = false
    
    //MARK:- View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        self.getAffiliationListAPI()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }

    //MARK:- Private Methods
    func setup() {
        self.navigationItem.leftBarButtonItem = self.backBarButton()
        self.affiliationsTableView.separatorColor = UIColor.clear
        self.affiliationsTableView.register(UINib(nibName: "PhotoNameCell", bundle: nil), forCellReuseIdentifier: "PhotoNameCell")
        self.affiliationsTableView.register(UINib(nibName: "SectionHeadingTableCell", bundle: nil), forCellReuseIdentifier: "SectionHeadingTableCell")
        self.affiliationsTableView.register(UINib(nibName: "AffiliationsCell", bundle: nil), forCellReuseIdentifier: "AffiliationsCell")
        self.affiliationsTableView.register(UINib(nibName: "AffliliationsOthersCell", bundle: nil), forCellReuseIdentifier: "AffliliationsOthersCell")
        if isEditMode {
            self.title = "EDIT PROFILE"
            self.nextButton.setTitle("SAVE", for: .normal)
            self.headerViewForEditProfile.isHidden = false
        } else {
            self.headerViewForEditProfileHeight.constant = 0
            self.view.layoutIfNeeded()
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
        
        let toolbarButtons = [flexibleSpace,item]
        
        //Put the buttons into the ToolBar and display the tool bar
        keyboardDoneButtonView.setItems(toolbarButtons, animated: false)
        
        return keyboardDoneButtonView
    }
    
    func openCertificationScreen() {
        self.performSegue(withIdentifier: Constants.StoryBoard.SegueIdentifier.goToCertificationsVC, sender: self)
    }
    
    @objc func toolBarButtonPressed() {
        self.view.endEditing(true)
    }
    
    //MARK:- IBActions
    @IBAction func nextButtonClicked(_ sender: Any) {
        makeAffiliationData()
    }
    
    //Making the post data for affiliation post API
    func makeAffiliationData() {
        self.view.endEditing(true)
        var params = [String:AnyObject]()
        var other = [[String:String]]()
        var otherObject = [String:String]()
        var selectedAffiliationIds = [String]()
        for affiliation in affiliations {
            if affiliation.isSelected {
                if !affiliation.isOther {
                    selectedAffiliationIds.append(affiliation.affiliationId)
                }
            }
        }
        
        //For other affiliation
        let affiliation = affiliations[affiliations.count - 1]
        if affiliation.isSelected {
            if let otherAffiliation = affiliation.otherAffiliation {
                if otherAffiliation.trim().isEmpty {
                    self.makeToast(toastString: "Other Affiliation can't be empty")
                    return
                }
            otherObject[Constants.ServerKey.affiliationId] = affiliation.affiliationId
            otherObject[Constants.ServerKey.otherAffiliation] = otherText
            other.append(otherObject)
            }
        }
        
        if !affiliation.isSelected {
            if selectedAffiliationIds.count == 0 {
                self.makeToast(toastString: "Please select atleast one affiliation")
                return
            }
        }
        
        params[Constants.ServerKey.affiliationDataArray] = selectedAffiliationIds as AnyObject?
        params[Constants.ServerKey.other] = other as AnyObject?
        self.saveAffiliationData(params: params)
    }
    
    //For edit mode from Edit Profile
    func manageSelectedAffiliations() {
        NotificationCenter.default.post(name: .updateProfileScreen, object: nil, userInfo: ["affiliations":affiliations.filter({$0.isSelected == true})])
    }
}


extension DMAffiliationsVC: UITextViewDelegate {
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        
        self.affiliationsTableView.contentInset =  UIEdgeInsetsMake(0, 0, 200, 0)
        DispatchQueue.main.async {
            self.affiliationsTableView.scrollToRow(at: IndexPath(row: 0, section: 2), at: .bottom, animated: true)
        }
        return true
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        self.affiliationsTableView.contentInset =  UIEdgeInsetsMake(0, 0, 0, 0)
        
        return true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        let affiliation = affiliations[affiliations.count - 1]
        affiliation.otherAffiliation = textView.text!
        otherText = textView.text
    }
}

//
//  DMExecutiveSummaryVC.swift
//  DentaMatch
//
//  Created by Rajan Maheshwari on 10/01/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

class DMExecutiveSummaryVC: DMBaseVC {

    enum ExecutiveSummary:Int {
        case profileHeader
        case aboutMe
    }
    
    
    @IBOutlet weak var executiveSummaryTableView: UITableView!
    
    let profileProgress:CGFloat = 1.0
    var aboutMe = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        // Do any additional setup after loading the view.
    }

    func setup() {
        self.navigationItem.leftBarButtonItem = self.backBarButton()
        self.executiveSummaryTableView.separatorColor = UIColor.clear
        self.executiveSummaryTableView.register(UINib(nibName: "PhotoNameCell", bundle: nil), forCellReuseIdentifier: "PhotoNameCell")
        self.executiveSummaryTableView.register(UINib(nibName: "AboutMeCell", bundle: nil), forCellReuseIdentifier: "AboutMeCell")
    }
    
    func openDashboard() {
        let dashboardVC = UIStoryboard.dashBoardStoryBoard().instantiateViewController(type: TabBarVC.self)!
        kAppDelegate.window?.rootViewController = dashboardVC
        
//        UIView.transition(with: self.view.window!, duration: 0.5, options: .curveEaseInOut, animations: {
//            kAppDelegate.window?.rootViewController = dashboardVC
//        }) { (bool:Bool) in
//            
//        }
    }
    
    func addToolBarOnTextView() -> UIToolbar {
        let keyboardDoneButtonView = UIToolbar()
        keyboardDoneButtonView.sizeToFit()
        keyboardDoneButtonView.barTintColor = Constants.Color.toolBarColor
        // Setup the buttons to be put in the system.
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: self, action: nil)
        
        let item = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(toolBarButtonPressed))
        item.tag = 2
        item.setTitleTextAttributes([NSFontAttributeName: UIFont.fontRegular(fontSize: 20.0)!], for: UIControlState.normal)
        
        item.tintColor = UIColor.white
        
        let toolbarButtons = [flexibleSpace,item]
        
        //Put the buttons into the ToolBar and display the tool bar
        keyboardDoneButtonView.setItems(toolbarButtons, animated: false)
        
        return keyboardDoneButtonView
    }
    
    func toolBarButtonPressed() {
        self.view.endEditing(true)
    }
    
    @IBAction func completeProfileButtonClicked(_ sender: Any) {
        self.updateAboutMeAPI()
    }
}

extension DMExecutiveSummaryVC : UITextViewDelegate {
    // MARK: - TextView Delegates
    
    func textViewDidChange(_ textView: UITextView) {
        if let cell = self.executiveSummaryTableView.cellForRow(at: IndexPath(row: 0, section: 1)) as? AboutMeCell {
            aboutMe = textView.text
            if !textView.text.isEmpty {
                cell.placeHolderLabel.isHidden = true
            } else {
                cell.placeHolderLabel.isHidden = false
            }
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        guard text.characters.count > 0 else {
            return true
        }
        if textView.text.characters.count >= Constants.Limit.aboutMeLimit && range.length == 0 {
            return false
        }
        if textView.text.characters.count + text.characters.count > Constants.Limit.aboutMeLimit && range.length == 0 {
            let remainingTextCount = Constants.Limit.aboutMeLimit - textView.text.characters.count
            textView.text = textView.text + text.stringFrom(0, to: remainingTextCount)
            return false
        }
        
        return true        
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        self.executiveSummaryTableView.contentInset =  UIEdgeInsetsMake(0, 0, 200, 0)
        DispatchQueue.main.async {
            self.executiveSummaryTableView.scrollToRow(at: IndexPath(row: 0, section: 1), at: .bottom, animated: true)
        }
        
        if let cell = self.executiveSummaryTableView.cellForRow(at: IndexPath(row: 0, section: 1)) as? AboutMeCell {
            if !textView.text.isEmpty {
                cell.placeHolderLabel.isHidden = true
            } else {
                cell.placeHolderLabel.isHidden = false
            }
        }
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        self.executiveSummaryTableView.contentInset =  UIEdgeInsetsMake(0, 0, 0, 0)
        return true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        if let cell = self.executiveSummaryTableView.cellForRow(at: IndexPath(row: 0, section: 1)) as? AboutMeCell {
            if !textView.text.isEmpty {
                cell.placeHolderLabel.isHidden = true
            } else {
                cell.placeHolderLabel.isHidden = false
            }
        }
    }
}

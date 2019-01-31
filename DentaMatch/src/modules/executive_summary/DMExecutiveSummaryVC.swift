//
//  DMExecutiveSummaryVC.swift
//  DentaMatch
//
//  Created by Rajan Maheshwari on 10/01/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

class DMExecutiveSummaryVC: DMBaseVC {
    enum ExecutiveSummary: Int {
        case profileHeader
        case aboutMe
    }

    @IBOutlet var executiveSummaryTableView: UITableView!

    let profileProgress: CGFloat = 1.0
    var aboutMe = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        // Do any additional setup after loading the view.
    }

    func setup() {
        navigationItem.leftBarButtonItem = backBarButton()
        executiveSummaryTableView.separatorColor = UIColor.clear
        executiveSummaryTableView.register(UINib(nibName: "PhotoNameCell", bundle: nil), forCellReuseIdentifier: "PhotoNameCell")
        executiveSummaryTableView.register(UINib(nibName: "AboutMeCell", bundle: nil), forCellReuseIdentifier: "AboutMeCell")
    }

    func openDashboard() {
        assertionFailure("Implement")
        //kAppDelegate?.goToSearch()

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

    @objc func toolBarButtonPressed() {
        view.endEditing(true)
    }

    @IBAction func completeProfileButtonClicked(_: Any) {
        updateAboutMeAPI()
    }
}

extension DMExecutiveSummaryVC: UITextViewDelegate {

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
        guard text.count > 0 else {
            return true
        }
        if textView.text.count >= Constants.Limit.aboutMeLimit && range.length == 0 {
            return false
        }
        if textView.text.count + text.count > Constants.Limit.aboutMeLimit && range.length == 0 {
            let remainingTextCount = Constants.Limit.aboutMeLimit - textView.text.count
            textView.text = textView.text + text.stringFrom(0, to: remainingTextCount)
            return false
        }

        return true
    }

    func textViewDidBeginEditing(_ textView: UITextView) {
        executiveSummaryTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 200, right: 0)
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

    func textViewShouldEndEditing(_: UITextView) -> Bool {
        executiveSummaryTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
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
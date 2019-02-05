//
//  DMCancelJobVC.swift
//  DentaMatch
//
//  Created by Rajan Maheshwari on 31/01/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

@objc protocol CancelledJobDelegate {
    func cancelledJob(job: Job, fromApplied: Bool)
}

class DMCancelJobVC: DMBaseVC {
    @IBOutlet var reasonTextView: UITextView!

    var viewOutput: DMCancelJobViewOutput?

    var placeHolderLabel: UILabel!

    // MARK: - View LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }

    func setup() {
        title = "CANCEL JOB"
        changeNavBarAppearanceForDefault()
        reasonTextView.inputAccessoryView = addToolBarOnTextView()
        reasonTextView.layer.cornerRadius = 5.0
        reasonTextView.layer.borderWidth = 1.0
        reasonTextView.layer.borderColor = Constants.Color.textFieldBorderColor.cgColor
        reasonTextView.textContainer.lineFragmentPadding = 12.0
        navigationItem.leftBarButtonItem = backBarButton()
        placeHolderLabel = UILabel(frame: CGRect(x: 10, y: 8, width: 230, height: 20))
        placeHolderLabel.font = UIFont.fontRegular(fontSize: 14.0)
        placeHolderLabel.textColor = UIColor.color(withHexCode: "939393")
        placeHolderLabel.text = "Please write a short description"
        reasonTextView.addSubview(placeHolderLabel)
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

    override func touchesBegan(_: Set<UITouch>, with _: UIEvent?) {
        view.endEditing(true)
    }

    @IBAction func submitButtonPressed(_: Any) {
        view.endEditing(true)
        if reasonTextView.text!.isEmptyField {
            makeToast(toastString: Constants.AlertMessage.emptyCancelReason)
        } else {
            alertMessage(title: "Confirm your cancellation", message: "\nAre you sure you want to cancel the job? (Multiple cancellations can result in suspension of your account)", leftButtonText: "Cancel", rightButtonText: "Ok", completionHandler: { (isLeftButton: Bool) in
                if !isLeftButton {
                    self.viewOutput?.cancelJob(reason: self.reasonTextView.text)
                }
            })
        }
    }
}

extension DMCancelJobVC: DMCancelJobViewInput {
    
    
}

extension DMCancelJobVC: UITextViewDelegate {

    // MARK: - TextView Delegates

    func textViewDidChange(_ textView: UITextView) {
        if !textView.text.isEmpty {
            placeHolderLabel.isHidden = true
        } else {
            placeHolderLabel.isHidden = false
        }
    }

    func textView(_: UITextView, shouldChangeTextIn _: NSRange, replacementText _: String) -> Bool {
        return true
    }

    func textViewDidBeginEditing(_ textView: UITextView) {
        if !textView.text.isEmpty {
            placeHolderLabel.isHidden = true
        } else {
            placeHolderLabel.isHidden = false
        }
    }

    func textViewShouldEndEditing(_: UITextView) -> Bool {
        return true
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if !textView.text.isEmpty {
            placeHolderLabel.isHidden = true
        } else {
            placeHolderLabel.isHidden = false
        }
    }
}

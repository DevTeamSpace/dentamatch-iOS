//
//  DMCancelJobVC.swift
//  DentaMatch
//
//  Created by Rajan Maheshwari on 31/01/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

protocol CancelledJobDelegate {
    func cancelledJob(job:Job,fromApplied:Bool)
}

class DMCancelJobVC: DMBaseVC {
    @IBOutlet weak var reasonTextView: UITextView!
 
    var job:Job?
    var placeHolderLabel:UILabel!
    var delegate:CancelledJobDelegate?
    var fromApplied = false
    
    //MARK:- View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    func setup() {
        self.title = "CANCEL JOB"
        self.changeNavBarAppearanceForDefault()
        self.reasonTextView.inputAccessoryView = self.addToolBarOnTextView()
        self.reasonTextView.layer.cornerRadius = 5.0
        self.reasonTextView.layer.borderWidth = 1.0
        self.reasonTextView.layer.borderColor = Constants.Color.textFieldBorderColor.cgColor
        self.reasonTextView.textContainer.lineFragmentPadding = 12.0
        self.navigationItem.leftBarButtonItem = self.backBarButton()
        placeHolderLabel = UILabel(frame: CGRect(x: 10, y: 8, width: 230, height: 20))
        placeHolderLabel.font = UIFont.fontRegular(fontSize: 14.0)
        placeHolderLabel.textColor = UIColor.color(withHexCode: "939393")
        placeHolderLabel.text = "Please write a short description"
        self.reasonTextView.addSubview(placeHolderLabel)
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

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    @IBAction func submitButtonPressed(_ sender: Any) {
        self.view.endEditing(true)
        if self.reasonTextView.text!.isEmptyField {
            self.makeToast(toastString: Constants.AlertMessage.emptyCancelReason)
        } else {
            self.alertMessage(title: "Confirm your cancellation", message: "Are you sure you want to cancel the job?", leftButtonText: "Cancel", rightButtonText: "Ok", completionHandler: { (isLeftButton:Bool) in
                if !isLeftButton {
                    self.cancelJobAPI()
                }
            })
        }
    }
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
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        return true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if !textView.text.isEmpty {
            placeHolderLabel.isHidden = true
        } else {
            placeHolderLabel.isHidden = false
        }
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
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

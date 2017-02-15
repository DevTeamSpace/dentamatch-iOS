//
//  DMChatVC.swift
//  DentaMatch
//
//  Created by Rajan Maheshwari on 06/02/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit
import CoreData
import SwiftyJSON

class DMChatVC: DMBaseVC {
    @IBOutlet weak var chatTableView: UITableView!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!

    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var unblockButton: UIButton!
    @IBOutlet weak var chatTextView: UITextView!
    @IBOutlet weak var textContainerViewHeight: NSLayoutConstraint!
    
    var placeHolderLabelForView:UILabel!
    var placeHolderLabel:UILabel!
    var chatList:ChatList?
    var messages = [String]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        self.getChats()
        SocketManager.sharedInstance.getHistory(pageNo: 1)
        // Do any additional setup after loading the view.
        receiveMessagesEvent()
        receiveChatMessageEvent()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        self.navigationItem.title = chatList?.officeName
        self.navigationItem.leftBarButtonItem = self.backBarButton()
        SocketManager.sharedInstance.recruiterId = (chatList?.recruiterId)!
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    //MARK:- Keyboard Show Hide Observers
    func keyboardWillShow(note: NSNotification) {
        if let keyboardSize = (note.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            UIView.animate(withDuration: 0.25, animations: {
                self.bottomConstraint.constant = keyboardSize.height
                self.view.layoutIfNeeded()
            }) { (bool:Bool) in
            }
            
            //chatTableView.contentInset =  UIEdgeInsetsMake(0, 0, keyboardSize.height+1, 0)
            self.scrollTableToBottom()
            
        }
    }
    
    func keyboardWillHide(note: NSNotification) {
        UIView.animate(withDuration: 0.25, animations: {
            self.bottomConstraint.constant = 0
            self.view.layoutIfNeeded()
        }) { (bool:Bool) in
        }
        chatTableView.contentInset =  UIEdgeInsetsMake(0, 0, 0, 0)
    }

    
    func setup() {
        self.chatTextView.text = ""
        self.chatTextView.textContainer.lineFragmentPadding = 10.0
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.chatTableView.addGestureRecognizer(tap)
        self.chatTextView.delegate = self
        self.chatTextView.layer.cornerRadius = 5.0
        self.chatTableView.register(UINib(nibName: "MessageSenderTableCell", bundle: nil), forCellReuseIdentifier: "MessageSenderTableCell")
        self.chatTableView.register(UINib(nibName: "MessageReceiverTableCell", bundle: nil), forCellReuseIdentifier: "MessageReceiverTableCell")
        
        placeHolderLabel = UILabel(frame: CGRect(x: 10, y: 8, width: 100, height: 16))
        placeHolderLabel.font = UIFont.fontRegular(fontSize: 14.0)
        placeHolderLabel.text = "Text Message"
        placeHolderLabel.textColor = Constants.Color.textFieldPlaceHolderColor
        self.chatTextView.addSubview(placeHolderLabel)
        
        placeHolderLabelForView = UILabel(frame: CGRect(x: 0, y: 0, width: 300, height: 40))
        placeHolderLabelForView.font = UIFont.fontRegular(fontSize: 15.0)!
        placeHolderLabelForView.textColor = UIColor.color(withHexCode: "aaafb8")
        placeHolderLabelForView.textAlignment = .center
        placeHolderLabelForView.numberOfLines = 2
        placeHolderLabelForView.text = "Start your conversation with\n \((chatList?.officeName)!)"
        placeHolderLabelForView.center = self.view.center
        var frame = placeHolderLabelForView.frame
        frame = CGRect(x: frame.origin.x, y: frame.origin.y - 44, width: frame.size.width, height: frame.size.height)
        placeHolderLabelForView.frame = frame
        placeHolderLabelForView.isHidden = true
        self.view.addSubview(placeHolderLabelForView)

        
        if (chatList?.isBlockedFromSeeker)! {
            self.chatTextView.isHidden = true
            self.sendButton.isHidden = true
            self.unblockButton.isHidden = false
        } else {
            self.chatTextView.isHidden = false
            self.sendButton.isHidden = false
            self.unblockButton.isHidden = true
        }
    }
    
    func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    func receiveMessagesEvent() {
        SocketManager.sharedInstance.receiveMessages { (info:[Any]) in
            print(info)
        }
    }
    
    func receiveChatMessageEvent() {
        SocketManager.sharedInstance.getChatMessage { (object:[String : AnyObject]) in
            print(object)
            let chatObj = JSON(rawValue: object)
            self.addUpdateChatToDB(chatObj: chatObj)
            self.chatTextView.text = ""
            self.placeHolderLabel.isHidden = false
        }
    }
    
    @IBAction func sendMessageButtonPressed(_ sender: Any) {
        //Send Message
        if SocketManager.sharedInstance.socket.status == .connected {
            SocketManager.sharedInstance.sendTextMessage(message: self.chatTextView.text)
        } else {
            debugPrint("Socket not connected")
        }
    }
    @IBAction func unblockButtonPressed(_ sender: Any) {
        self.unBlockRecruiter(chatList: chatList!)
    }

}

extension DMChatVC:UITextViewDelegate {
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        return true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if !textView.text.isEmpty {
            placeHolderLabel.isHidden = true
        } else {
            placeHolderLabel.isHidden = false
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        textView.text = textView.text.trim()
        if !textView.text.isEmpty {
            placeHolderLabel.isHidden = true
        } else {
            placeHolderLabel.isHidden = false
        }
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        return true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if !textView.text.isEmpty {
            placeHolderLabel.isHidden = true
        } else {
            placeHolderLabel.isHidden = false
        }

        let cSize = textView.sizeThatFits(CGSize(width: textView.frame.width, height: 99999))
        if cSize.height >= 150 {
            textContainerViewHeight.constant = 150
            self.view.layoutIfNeeded()
        } else if cSize.height > 48 {
            textContainerViewHeight.constant = cSize.height
            self.view.layoutIfNeeded()
        } else {
            textContainerViewHeight.constant = 48
        }
    }
}

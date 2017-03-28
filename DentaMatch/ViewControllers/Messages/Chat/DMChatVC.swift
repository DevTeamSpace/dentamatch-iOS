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

@objc protocol ChatTapNotificationDelegate {
    @objc optional func notificationTapped(recruiterId:String)
}

class DMChatVC: DMBaseVC {
    @IBOutlet weak var chatTableView: UITableView!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!

    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var unblockButton: UIButton!
    @IBOutlet weak var chatTextView: UITextView!
    @IBOutlet weak var textContainerViewHeight: NSLayoutConstraint!
    
    var delegate:ChatTapNotificationDelegate?
    var placeHolderLabelForView:UILabel!
    var placeHolderLabel:UILabel!
    var chatList:ChatList?
    var messages = [String]()
    var shouldFetchFromBeginning = false
    
    let context = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.showLoader(text: "Loading Chats")
        setup()
        receiveChatMessageEvent()
        sendButton.isUserInteractionEnabled = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(refreshUnblockList), name: .refreshUnblockList, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(refreshChat), name: .refreshChat, object: nil)
        self.navigationItem.title = chatList?.officeName
        self.navigationItem.leftBarButtonItem = self.backBarButton()
        SocketManager.sharedInstance.recruiterId = (chatList?.recruiterId)!
        SocketManager.sharedInstance.updateMessageRead()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.getHistory()
        self.hideLoader()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
        SocketManager.sharedInstance.notOnChat()
    }
    
    //MARK:- Keyboard Show Hide Observers
    func keyboardWillShow(note: NSNotification) {
        if let keyboardSize = (note.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            UIView.animate(withDuration: 0.25, animations: {
                self.bottomConstraint.constant = keyboardSize.height
                self.chatTableView.layoutIfNeeded()
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
    
    func receiveChatMessageEvent() {
        
        SocketManager.sharedInstance.getChatMessage { (object:[String : AnyObject], isMine:Bool) in
            debugPrint(object)
            let chatObj = JSON(rawValue: object)
            if let chatObj = chatObj {
                if chatObj["blocked"].exists() {
                    if isMine {
                        self.view.endEditing(true)
                        self.makeToast(toastString: "Recruiter has blocked you from messaging")
                        return
                    }
                }
            }
            self.addUpdateChatToDB(chatObj: chatObj)
            if isMine {
                self.sendButton.isUserInteractionEnabled = false
                self.chatTextView.text = ""
                self.placeHolderLabel.isHidden = false
            }
        }
    }
    
    func getHistory() {
        if SocketManager.sharedInstance.socket.status == .connected {
            if shouldFetchFromBeginning {
                SocketManager.sharedInstance.getHistory(recruiterId: (chatList?.recruiterId)!) { (params:[Any]) in
                    debugPrint("History from Beginning")
                    //debugPrint(params)
                    let chatObj = JSON(rawValue: params)
                    DatabaseManager.insertChats(chats: chatObj?[0].array)
                    self.getChats()
                }
            } else {
                self.getChats()
                if let chat = getLastChat() {
                    getLeftMessages(lastMessageId: chat.chatId!)
                }
            }
        } else {
            self.getChats()
        }
    }
    
    func getLeftMessages(lastMessageId:String) {
        //self.showLoader(text: "Loading Chats")
        SocketManager.sharedInstance.getLeftMessages(recruiterId: (chatList?.recruiterId)!, messageId: lastMessageId, completionHandler: { (params:[Any]) in
            //self.hideLoader()
            debugPrint(params)
            let chatObj = JSON(rawValue: params)
            DatabaseManager.insertChats(chats: chatObj?[0].array)
        })

    }
    
    func refreshChat() {
        if let chat = getLastChat() {
            getLeftMessages(lastMessageId: chat.chatId!)
        }
    }
    
    func getLastChat() -> Chat? {
        if let fetchedResultsController = fetchedResultsController {
            if let section = fetchedResultsController.sections {
                if section.count > 0 {
                    let lastRow = section[section.count - 1].numberOfObjects - 1
                    let indexPath = IndexPath(row: lastRow, section: section.count - 1)
                    return fetchedResultsController.object(at: indexPath) as? Chat
                }
            }
        }
        return nil
    }
    
    @IBAction func sendMessageButtonPressed(_ sender: Any) {
        if self.chatTextView.text.isEmptyField {
            self.chatTextView.text = ""
            self.placeHolderLabel.isHidden = false
            return
        }
        //Send Message
        if SocketManager.sharedInstance.socket.status == .connected {
//        let encodedMessage = self.chatTextView.text!.convertToUTF8()
            
            SocketManager.sharedInstance.sendTextMessage(message: self.chatTextView.text, recruiterId: (chatList?.recruiterId)!)
            self.chatTextView.text = ""
            self.placeHolderLabel.isHidden = false
        } else {
            self.alertMessage(title: "Connection Problem", message: "Unable to connect to server. Please try again later.", buttonText: "Ok", completionHandler: nil)
            debugPrint("Socket not connected")
        }
    }
    @IBAction func unblockButtonPressed(_ sender: Any) {
        //self.unBlockRecruiter(chatList: chatList!)
        SocketManager.sharedInstance.handleBlockUnblock(chatList: chatList!, blockStatus: "0")
    }
    
    func refreshUnblockList(notification:Notification) {
        self.chatTextView.isHidden = false
        self.sendButton.isHidden = false
        self.unblockButton.isHidden = true
        self.makeToast(toastString: "Recruiter Unblocked")
    }
    
    func notificationTapHandling(recruiterId:String) {
        if let delegate = delegate {
            delegate.notificationTapped!(recruiterId: recruiterId)
        }
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
            sendButton.isUserInteractionEnabled = true
        } else {
            placeHolderLabel.isHidden = false
            sendButton.isUserInteractionEnabled = false
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

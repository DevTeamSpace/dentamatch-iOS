//
//  DMChatVC.swift
//  DentaMatch
//
//  Created by Rajan Maheshwari on 06/02/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import CoreData
import SwiftyJSON
import UIKit

@objc protocol ChatTapNotificationDelegate {
    @objc optional func notificationTapped(recruiterId: String)
}

class DMChatVC: DMBaseVC {
    @IBOutlet var chatTableView: UITableView!
    @IBOutlet var bottomConstraint: NSLayoutConstraint!

    @IBOutlet var sendButton: UIButton!
    @IBOutlet var unblockButton: UIButton!
    @IBOutlet var chatTextView: UITextView!
    @IBOutlet var textContainerViewHeight: NSLayoutConstraint!

    weak var delegate: ChatTapNotificationDelegate?
    weak var moduleOutput: DMChatModuleOutput?
    var placeHolderLabelForView: UILabel!
    var placeHolderLabel: UILabel!
    var chatList: ChatList?
    var messages = [String]()
    var shouldFetchFromBeginning = false
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    let context = ((UIApplication.shared.delegate as? AppDelegate)?.managedObjectContext)!
    
    var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>!

    var printData = true

    override func viewDidLoad() {
        super.viewDidLoad()
        showLoader(text: "Loading Chats")
        setup()
        receiveChatMessageEvent()
        sendButton.isUserInteractionEnabled = false
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(refreshUnblockList), name: .refreshUnblockList, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(refreshChat), name: .refreshChat, object: nil)
        navigationItem.title = chatList?.officeName
        navigationItem.leftBarButtonItem = backBarButton()
        SocketManager.sharedInstance.recruiterId = (chatList?.recruiterId)!
        SocketManager.sharedInstance.updateMessageRead()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getHistory()
        hideLoader()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
        SocketManager.sharedInstance.notOnChat()
    }

    // MARK: - Keyboard Show Hide Observers

    @objc func keyboardWillShow(note: NSNotification) {
        if let keyboardSize = (note.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            UIView.animate(withDuration: 0.25, animations: {
                self.bottomConstraint.constant = keyboardSize.height
                self.chatTableView.layoutIfNeeded()
                self.view.layoutIfNeeded()
            }) { (_: Bool) in
            }
            scrollTableToBottom()
        }
    }

    @objc func keyboardWillHide(note _: NSNotification) {
        UIView.animate(withDuration: 0.25, animations: {
            self.bottomConstraint.constant = 0
            self.view.layoutIfNeeded()
        }) { (_: Bool) in
        }
        chatTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }

    func setup() {
        chatTextView.text = ""
        chatTextView.textContainer.lineFragmentPadding = 10.0
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        chatTableView.addGestureRecognizer(tap)
        chatTextView.delegate = self
        chatTextView.layer.cornerRadius = 5.0
        chatTableView.register(UINib(nibName: "MessageSenderTableCell", bundle: nil), forCellReuseIdentifier: "MessageSenderTableCell")
        chatTableView.register(UINib(nibName: "MessageReceiverTableCell", bundle: nil), forCellReuseIdentifier: "MessageReceiverTableCell")

        placeHolderLabel = UILabel(frame: CGRect(x: 10, y: 8, width: 100, height: 16))
        placeHolderLabel.font = UIFont.fontRegular(fontSize: 14.0)
        placeHolderLabel.text = "Text Message"
        placeHolderLabel.textColor = Constants.Color.textFieldPlaceHolderColor
        chatTextView.addSubview(placeHolderLabel)

        placeHolderLabelForView = UILabel(frame: CGRect(x: 0, y: 0, width: 300, height: 40))
        placeHolderLabelForView.font = UIFont.fontRegular(fontSize: 15.0)
        placeHolderLabelForView.textColor = UIColor.color(withHexCode: "aaafb8")
        placeHolderLabelForView.textAlignment = .center
        placeHolderLabelForView.numberOfLines = 2
        placeHolderLabelForView.text = "Start your conversation with\n \((chatList?.officeName) ?? "")"
        placeHolderLabelForView.center = view.center
        var frame = placeHolderLabelForView.frame
        frame = CGRect(x: frame.origin.x, y: frame.origin.y - 44, width: frame.size.width, height: frame.size.height)
        placeHolderLabelForView.frame = frame
        placeHolderLabelForView.isHidden = true
        view.addSubview(placeHolderLabelForView)

        if (chatList?.isBlockedFromSeeker)! {
            chatTextView.isHidden = true
            sendButton.isHidden = true
            unblockButton.isHidden = false
        } else {
            chatTextView.isHidden = false
            sendButton.isHidden = false
            unblockButton.isHidden = true
        }
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

    func receiveChatMessageEvent() {
        SocketManager.sharedInstance.getChatMessage { (object: [String: AnyObject], isMine: Bool) in
            // debugPrint(object)
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
                SocketManager.sharedInstance.getHistory(recruiterId: (chatList?.recruiterId)!) { (params: [Any]) in
                    let chatObj = JSON(rawValue: params)
                    DatabaseManager.insertChats(chats: chatObj?[0].array)
                    self.getChats()
                }
            } else {
                getChats()
                if let chat = getLastChat() {
                    getLeftMessages(lastMessageId: chat.chatId)
                }
            }
        } else {
            getChats()
        }
    }

    func getLeftMessages(lastMessageId: Int64) {
        SocketManager.sharedInstance.getLeftMessages(recruiterId: (chatList?.recruiterId)!, messageId: lastMessageId, completionHandler: { (params: [Any]) in
            // debugPrint(params)
            let chatObj = JSON(rawValue: params)
            DatabaseManager.insertChats(chats: chatObj?[0].array)
        })
    }

    @objc func refreshChat() {
        if let chat = getLastChat() {
            getLeftMessages(lastMessageId: chat.chatId)
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

    @IBAction func sendMessageButtonPressed(_: Any) {
        if chatTextView.text.isEmptyField {
            chatTextView.text = ""
            placeHolderLabel.isHidden = false
            return
        }
        // Send Message
        if SocketManager.sharedInstance.socket.status == .connected {
         //  let encodedMessage = self.chatTextView.text!.convertToUTF8()

            SocketManager.sharedInstance.sendTextMessage(message: chatTextView.text, recruiterId: (chatList?.recruiterId)!)
            chatTextView.text = ""
            placeHolderLabel.isHidden = false
        } else {
            alertMessage(title: "Connection Problem", message: "Unable to connect to server. Please try again later.", buttonText: "Ok", completionHandler: nil)
            // debugPrint("Socket not connected")
        }
    }

    @IBAction func unblockButtonPressed(_: Any) {
        // self.unBlockRecruiter(chatList: chatList!)
        SocketManager.sharedInstance.handleBlockUnblock(chatList: chatList!, blockStatus: "0")
    }

    @objc func refreshUnblockList(notification _: Notification) {
        chatTextView.isHidden = false
        sendButton.isHidden = false
        unblockButton.isHidden = true
        makeToast(toastString: "Recruiter Unblocked")
    }

    func notificationTapHandling(recruiterId: String) {
        if let delegate = delegate {
            delegate.notificationTapped!(recruiterId: recruiterId)
        }
    }
}

extension DMChatVC: UITextViewDelegate {
    func textViewShouldBeginEditing(_: UITextView) -> Bool {
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

    func textViewShouldEndEditing(_: UITextView) -> Bool {
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
            view.layoutIfNeeded()
        } else if cSize.height > 48 {
            textContainerViewHeight.constant = cSize.height
            view.layoutIfNeeded()
        } else {
            textContainerViewHeight.constant = 48
        }
    }
}

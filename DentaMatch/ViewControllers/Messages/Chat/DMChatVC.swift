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

    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var unblockButton: UIButton!
    @IBOutlet weak var chatTextView: UITextView!
    @IBOutlet weak var textContainerViewHeight: NSLayoutConstraint!
    
    var placeHolderLabelForView:UILabel!
    
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
        self.navigationItem.title = chatList?.officeName
        self.navigationItem.leftBarButtonItem = self.backBarButton()
    }
    
    func setup() {
        self.chatTextView.delegate = self
        self.chatTextView.layer.cornerRadius = 5.0
        self.chatTableView.register(UINib(nibName: "MessageSenderTableCell", bundle: nil), forCellReuseIdentifier: "MessageSenderTableCell")
        self.chatTableView.register(UINib(nibName: "MessageReceiverTableCell", bundle: nil), forCellReuseIdentifier: "MessageReceiverTableCell")
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
    
    func receiveMessagesEvent() {
        SocketManager.sharedInstance.receiveMessages { (info:[Any]) in
            print(info)
        }
    }
    
    func receiveChatMessageEvent() {
        SocketManager.sharedInstance.getChatMessage { (object:[String : AnyObject]) in
            print(object)
            let json = JSON(rawValue: object)
            self.addUpdateChatToDB(chatObj: json)
            self.chatTextView.text = ""
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
    func textViewDidChange(_ textView: UITextView) {
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
//        print(cSize.height)
    }
}

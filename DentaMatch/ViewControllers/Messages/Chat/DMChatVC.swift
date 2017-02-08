//
//  DMChatVC.swift
//  DentaMatch
//
//  Created by Rajan Maheshwari on 06/02/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit
import CoreData

class DMChatVC: DMBaseVC {
    @IBOutlet weak var chatTableView: UITableView!

    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var unblockButton: UIButton!
    @IBOutlet weak var chatTextView: UITextView!
    @IBOutlet weak var textContainerViewHeight: NSLayoutConstraint!
    
    var placeholderLabel:UILabel!
    
    var chatList:ChatList?
    var array = [
        "asdhg sadjhg sadjh asdgf sadghfsad ghfsad gfasd asdgfghasdfhgasdfhgasdfh adsfhgas",
        "Yes, I’m comfortable working part time",
        "Hi",
        "asdhg sagdhsdg trhr wgh asd jha  atsudfjasdjasdf sadjg sadj asdgfsadgasd ghfasd hgasdf hgasd asfghd asdghf asdfhadgs"
    ]
    
    let context = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        SocketManager.sharedInstance.initServer()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = chatList?.officeName
        self.navigationItem.leftBarButtonItem = self.backBarButton()
        SocketManager.sharedInstance.getChatMessage { (object:[String : AnyObject]) in
            print(object)
        }
    }
    
    func setup() {
        self.chatTextView.delegate = self
        self.chatTextView.layer.cornerRadius = 5.0
        self.chatTableView.register(UINib(nibName: "MessageSenderTableCell", bundle: nil), forCellReuseIdentifier: "MessageSenderTableCell")
        self.chatTableView.register(UINib(nibName: "MessageReceiverTableCell", bundle: nil), forCellReuseIdentifier: "MessageReceiverTableCell")
        placeholderLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 300, height: 40))
        placeholderLabel.font = UIFont.fontRegular(fontSize: 15.0)!
        placeholderLabel.textColor = UIColor.color(withHexCode: "aaafb8")
        placeholderLabel.textAlignment = .center
        placeholderLabel.numberOfLines = 2
        placeholderLabel.center = self.view.center
        placeholderLabel.text = "Start your conversation with\n \(chatList?.officeName!)"
        self.view.addSubview(placeholderLabel)
        
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
    
    @IBAction func sendMessageButtonPressed(_ sender: Any) {
        //Send Message
        SocketManager.sharedInstance.sendTextMessage(message: "")
    }
    @IBAction func unblockButtonPressed(_ sender: Any) {
        self.unBlockRecruiter(chatList: chatList!)
    }

}

extension DMChatVC:UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        
        let cSize = textView.sizeThatFits(CGSize(width: textView.frame.width, height: 99999))
//        let attrS = NSMutableAttributedString(string: textView.text!, attributes: [NSFontAttributeName:UIFont.fontRegular(fontSize: 14.0)!])
//        
//        let cSize = CGSize(width: textView.frame.width, height: 99999)
//        let reqH = attrS.boundingRect(with: cSize, options: .usesLineFragmentOrigin, context: nil)
        
        if cSize.height > 48 {
            textContainerViewHeight.constant = cSize.height
            self.view.layoutIfNeeded()
        } else {
            textContainerViewHeight.constant = 48
        }
        print(cSize.height)
        
    }
}

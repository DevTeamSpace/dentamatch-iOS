import SwiftyJSON
import UIKit
import RealmSwift

protocol ChatTapNotificationDelegate: class {
    func notificationTapped(recruiterId: String)
}

class DMChatVC: DMBaseVC {
    @IBOutlet var chatTableView: UITableView!
    @IBOutlet var bottomConstraint: NSLayoutConstraint!

    @IBOutlet var sendButton: UIButton!
    @IBOutlet var unblockButton: UIButton!
    @IBOutlet var chatTextView: UITextView!
    @IBOutlet var textContainerViewHeight: NSLayoutConstraint!
    
    var placeHolderLabelForView: UILabel!
    var placeHolderLabel: UILabel!
    
    var viewOutput: DMChatViewOutput?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(refreshUnblockList), name: .refreshUnblockList, object: nil)
        
        setup()
        
        viewOutput?.didLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        viewOutput?.willAppear()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        viewOutput?.willDisappear()
    }

    
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
        
        placeHolderLabelForView.center = view.center
        var frame = placeHolderLabelForView.frame
        frame = CGRect(x: frame.origin.x, y: frame.origin.y - 44, width: frame.size.width, height: frame.size.height)
        placeHolderLabelForView.frame = frame
        placeHolderLabelForView.isHidden = true
        view.addSubview(placeHolderLabelForView)
        
        navigationItem.leftBarButtonItem = backBarButton()
        sendButton.isUserInteractionEnabled = false
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

    

    @IBAction func sendMessageButtonPressed(_: Any) {
        if chatTextView.text.isEmptyField {
            chatTextView.text = ""
            placeHolderLabel.isHidden = false
            return
        }

        if SocketIOManager.sharedInstance.isConnected {
         
            viewOutput?.sendMessage(text: chatTextView.text)
            chatTextView.text = ""
            placeHolderLabel.isHidden = false
            
        } else {
            alertMessage(title: "Connection Problem", message: "Unable to connect to server. Please try again later.", buttonText: "Ok", completionHandler: nil)
        }
    }

    @IBAction func unblockButtonPressed(_: Any) {
        viewOutput?.onUblockButtonTap()
    }

    @objc func refreshUnblockList(notification _: Notification) {
        chatTextView.isHidden = false
        sendButton.isHidden = false
        unblockButton.isHidden = true
        makeToast(toastString: "Recruiter Unblocked")
    }

    func notificationTapHandling(recruiterId: String) {
        viewOutput?.onNotificationTap(recruiterId: recruiterId)
    }
    
    func scrollTableToBottom() {
        if let chatsArray = viewOutput?.chatsArray, chatsArray.count > 0,
            let innerDateChats = chatsArray.first, innerDateChats.count > 0 {
            
            chatTableView.scrollToRow(at: IndexPath(row: chatsArray[chatsArray.count - 1].count - 1, section: chatsArray.count - 1), at: .bottom, animated: false)
        }
    }
}

extension DMChatVC: DMChatViewInput {
    
    func reloadData() {
        chatTableView.reloadData()
    }
    
    func scrollToBottom() {
        scrollTableToBottom()
    }
    
    func configureMessageReceive() {
        sendButton.isUserInteractionEnabled = false
        chatTextView.text = ""
        placeHolderLabel.isHidden = false
    }
    
    func configureView(title: String?, isBlockFromSeeker: Bool) {
        
        navigationItem.title = title
        placeHolderLabelForView.text = "Start your conversation with\n \((title) ?? "")"
        
        if isBlockFromSeeker {
            chatTextView.isHidden = true
            sendButton.isHidden = true
            unblockButton.isHidden = false
        } else {
            chatTextView.isHidden = false
            sendButton.isHidden = false
            unblockButton.isHidden = true
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

import Foundation
import SwiftyJSON
import RealmSwift

class DMChatPresenter: DMChatPresenterProtocol {
    
    unowned let viewInput: DMChatViewInput
    unowned let moduleOutput: DMChatModuleOutput
    
    let chatListId: String
    let fromBegin: Bool
    weak var delegate: ChatTapNotificationDelegate?
    
    init(chatListId: String, fromBegin: Bool, delegate: ChatTapNotificationDelegate, viewInput: DMChatViewInput, moduleOutput: DMChatModuleOutput) {
        self.chatListId  = chatListId
        self.fromBegin = fromBegin
        self.delegate = delegate
        self.viewInput = viewInput
        self.moduleOutput = moduleOutput
    }
    
    var chatList: ChatListModel?
    var chatsArray: [[ChatModel]] = []
    var messages = [String]()
    
    var notificationToken: NotificationToken?
    
    deinit {
        notificationToken?.invalidate()
    }
    
    var printData = true
}

extension DMChatPresenter: DMChatModuleInput {
    
    func viewController() -> UIViewController {
        return viewInput.viewController()
    }
}

extension DMChatPresenter: DMChatViewOutput {
    
    func didLoad() {
        
        let realm = try! Realm()
        chatList = realm.object(ofType: ChatListModel.self, forPrimaryKey: chatListId)
        
        notificationToken = realm.objects(ChatModel.self).observe({ [weak self] _ in
            self?.updateUI()
            SocketIOManager.sharedInstance.updateMessageRead()
        })
        
        SocketIOManager.sharedInstance.recruiterId = chatList?.recruiterId ?? "0"
        NotificationCenter.default.addObserver(self, selector: #selector(refreshChat), name: .refreshChat, object: nil)
        
        receiveChatMessageEvent()
        updateUI()
        getHistory()
    }
    
    func willAppear() {
        
        SocketIOManager.sharedInstance.updateMessageRead()
    }
    
    func willDisappear() {
        
        SocketIOManager.sharedInstance.notOnChat()
    }
    
    func sendMessage(text: String) {
        SocketIOManager.sharedInstance.sendTextMessage(message: text.trim(), recruiterId: chatList?.recruiterId ?? "0")
    }
    
    func onUblockButtonTap() {
        guard let chatList = chatList else { return }
        SocketIOManager.sharedInstance.handleBlockUnblock(chatList: chatList, blockStatus: "0")
    }
    
    func onNotificationTap(recruiterId: String) {
        delegate?.notificationTapped(recruiterId: recruiterId)
    }
}

extension DMChatPresenter {
    
    private func receiveChatMessageEvent() {
        SocketIOManager.sharedInstance.getChatMessage { [weak self] (object: [String: AnyObject], isMine: Bool) in
            
            let chatObj = JSON(rawValue: object)
            
            if let chatObj = chatObj {
                if chatObj["blocked"].exists() {
                    if isMine {
                        self?.viewInput.show(toastMessage: "Recruiter has blocked you from messaging")
                        return
                    }
                }
            }
            
            DatabaseManager.addUpdateChatToDB(chatObj: chatObj)
            
            if isMine {
                self?.viewInput.configureMessageReceive()
            }
        }
    }
    
    @objc func refreshChat() {
        if let chat = getLastChat() {
            getLeftMessages(lastMessageId: chat.id)
        }
    }

    private func getHistory() {
        if SocketIOManager.sharedInstance.isConnected {
            
            if fromBegin {
                SocketIOManager.sharedInstance.getHistory(recruiterId: chatList?.recruiterId ?? "0") { [weak self] (params: [Any]) in
                    
                    let chatObj = JSON(rawValue: params)
                    DatabaseManager.insertChats(chats: chatObj?[0].array)
                    self?.updateUI()
                }
            } else {
                
                if let chat = getLastChat() {
                    getLeftMessages(lastMessageId: chat.id)
                }
            }
        }
    }
    
    private func getLastChat() -> ChatModel? {
        return chatsArray.last?.last
    }
    
    func getLeftMessages(lastMessageId: Int) {
        SocketIOManager.sharedInstance.getLeftMessages(recruiterId: (chatList?.recruiterId)!, messageId: lastMessageId, completionHandler: { (params: [Any]) in
            
            let chatObj = JSON(rawValue: params)
            DatabaseManager.insertChats(chats: chatObj?[0].array)
        })
    }
    
    private func updateUI() {
        
        let realm = try! Realm()
        let userId = UserManager.shared().activeUser.userId
        
        guard let recruiterId = chatList?.recruiterId else { return }
        
        let chats = Array(realm.objects(ChatModel.self).filter({ ($0.fromId == userId && $0.toId == recruiterId) || ($0.fromId == recruiterId && $0.toId == userId) })).sorted(by: { $0.timeStamp < $1.timeStamp })

        let uniqueDateStrings = Array(NSOrderedSet(array: chats.map({ $0.dateString })))
        
        var final: [[ChatModel]] = Array(repeating: [], count: uniqueDateStrings.count)
        
        for (idx, dateString) in uniqueDateStrings.enumerated() {
            if let dateString = dateString as? String {
                let filteredChats = chats.filter({ $0.dateString == dateString })
                final[idx].append(contentsOf: filteredChats)
            }
        }

        chatsArray.removeAll()
        chatsArray = final
        
        viewInput.configureView(title: chatList?.officeName, isBlockFromSeeker: chatList?.isBlockedFromSeeker == true)
        viewInput.reloadData()
        viewInput.scrollToBottom()
    }
}

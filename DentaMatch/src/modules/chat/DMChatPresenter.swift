import Foundation
import SwiftyJSON
import RealmSwift

struct ChatObject {
    let recruiterId: String
    let officeName: String
}

class DMChatPresenter: DMChatPresenterProtocol {
    
    unowned let viewInput: DMChatViewInput
    unowned let moduleOutput: DMChatModuleOutput
    
    let recruiterId: String
    let officeName: String
    
    init(chatObject: ChatObject, viewInput: DMChatViewInput, moduleOutput: DMChatModuleOutput) {
        
        self.recruiterId = chatObject.recruiterId
        self.officeName = chatObject.officeName
        
        self.viewInput = viewInput
        self.moduleOutput = moduleOutput
    }
    
    var isBlockFromSeeker = false
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
        
        notificationToken = realm.objects(ChatModel.self).observe({ [weak self] _ in
            self?.updateUI()
            SocketIOManager.sharedInstance.updateMessageRead()
        })
        
        SocketIOManager.sharedInstance.recruiterId = recruiterId
        NotificationCenter.default.addObserver(self, selector: #selector(refreshChat), name: .refreshChat, object: nil)
        
        getChatList(recruiterId: recruiterId)
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
        SocketIOManager.sharedInstance.sendTextMessage(message: text.trim(), recruiterId: recruiterId)
    }
    
    func onUblockButtonTap() {
        SocketIOManager.sharedInstance.handleBlockUnblock(recruiterId: recruiterId, blockStatus: "0")
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
            
            DatabaseManager.addUpdateChatsToDB(chatObjs: [chatObj].compactMap({ $0 }))
            
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
    
    private func getChatList(recruiterId: String) {
        
        APIManager.apiPost(serviceName: Constants.API.getChatList, parameters: ["recruiterId": recruiterId]) { [weak self] (response, error) in
            
            self?.viewInput.hideLoading()
            if let error = error {
                self?.viewInput.show(toastMessage: error.localizedDescription)
                return
            }
            
            guard let response = response else {
                self?.viewInput.show(toastMessage: Constants.AlertMessage.somethingWentWrong)
                return
            }
            
            if response[Constants.ServerKey.status].boolValue {
                let result = response[Constants.ServerKey.result]
                
                let realm = try! Realm()
                try! realm.write {
                    let model = ChatListModel(chatListObj: result)
                    realm.add(model, update: true)
                }
                
            } else {
                self?.viewInput.show(toastMessage: response[Constants.ServerKey.message].stringValue)
            }
        }
    }

    private func getHistory() {
        if SocketIOManager.sharedInstance.isConnected {
            
            if DatabaseManager.getCountForChats(recruiterId: recruiterId) == 0 {
                viewInput.showLoading()
                SocketIOManager.sharedInstance.getHistory(recruiterId: recruiterId) { [weak self] (params: [Any]) in
                    
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
        SocketIOManager.sharedInstance.getLeftMessages(recruiterId: recruiterId, messageId: lastMessageId, completionHandler: { (params: [Any]) in
            
            let chatObj = JSON(rawValue: params)
            DatabaseManager.insertChats(chats: chatObj?[0].array)
        })
    }
    
    private func updateUI() {
        
        let realm = try! Realm()
        let userId = UserManager.shared().activeUser.userId
        
        isBlockFromSeeker = realm.objects(ChatListModel.self)
            .first(where: { $0.recruiterId == String(recruiterId) })?.isBlockedFromSeeker ?? false
        
        let chats = realm.objects(ChatModel.self)
            .filter("(fromId == %@ AND toId == %@) OR (fromId == %@ AND toId == %@)", userId, recruiterId, recruiterId, userId)
            .sorted(byKeyPath: "timeStamp")

        let uniqueDateStrings = Array(NSOrderedSet(array: chats.map({ $0.dateString })))
        
        var final: [[ChatModel]] = Array(repeating: [], count: uniqueDateStrings.count)
        
        for (idx, dateString) in uniqueDateStrings.enumerated() {
            if let dateString = dateString as? String {
                let filteredChats = chats.filter("dateString == %@", dateString)
                final[idx].append(contentsOf: filteredChats)
            }
        }

        chatsArray.removeAll()
        chatsArray = final
        
        viewInput.configureView(title: officeName, isBlockFromSeeker: isBlockFromSeeker)
        viewInput.reloadData()
        viewInput.scrollToBottom()
    }
}
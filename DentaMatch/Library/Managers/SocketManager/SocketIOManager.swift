import SwiftyJSON
import UIKit
import UserNotifications
import RealmSwift
import SocketIO

class SocketIOManager {
    
    static let sharedInstance = SocketIOManager()
    
    var isConnected: Bool {
        return manager.defaultSocket.status == .connected
    }
    
    private let manager = SocketManager(socketURL: URL(string: ConfigurationManager.sharedManager().socketEndPoint())!)

    typealias ReceiveMessageClosure = ((_ messageInfo: [String: AnyObject], _ isMine: Bool) -> Void)
    private var chatCompletionHandler: ReceiveMessageClosure?

    // To check whether the same recruiter is chatting
    var recruiterId = "0"

    typealias HistoryCallBackClosure = ((_ messageInfo: [Any]) -> Void)
    private var historyMessagesCompletionHandler: HistoryCallBackClosure?

    typealias GetLeftMessagesCallBackClosure = ((_ messageInfo: [Any]) -> Void)
    private var getLeftMessagesCompletionHandler: GetLeftMessagesCallBackClosure?

    init() {
        configureSocket()
    }
    
    private func configureSocket() {
        
        manager.defaultSocket.on(clientEvent: .connect) { [weak self] (data, ack) in
            
            if let _ = UserManager.shared().activeUser {
                
                self?.initServer()
                self?.eventForReceiveMessage()
                self?.eventForHistoryMessages()
                self?.eventForLogoutPreviousSession()
            }
        }
    }

    func establishConnection() {
        manager.defaultSocket.connect()
    }

    func closeConnection() {
        manager.defaultSocket.disconnect()
    }

    func initServer() {
        /*
         userType:
         1 is for jobseeker,
         2 is recruiter
         */

        let params = [
            "userId": UserManager.shared().activeUser.userId,
            "userName": UserManager.shared().activeUser.firstName!,
            "userType": 1,
        ] as [String: Any]
        
        manager.defaultSocket.emitWithAck("init", params).timingOut(after: 0) { (_: [Any]) in
            // debugPrint(params)
            NotificationCenter.default.post(name: .refreshMessageList, object: nil)
            NotificationCenter.default.post(name: .refreshChat, object: nil)
            // self.getChatHistory()
        }
    }

    func handleBlockUnblock(chatList: ChatListModel, blockStatus: String) {
        let params = [
            "fromId": UserManager.shared().activeUser.userId,
            "toId": chatList.recruiterId,
            "blockStatus": blockStatus,
        ]

        // debugPrint(params)

        manager.defaultSocket.emitWithAck("blockUnblock", params).timingOut(after: 0) { (params: [Any]) in
            // debugPrint(params)
            
            try! Realm().write {
                if blockStatus == "1" {
                    chatList.isBlockedFromSeeker = true
                    NotificationCenter.default.post(name: .refreshBlockList, object: params)
                } else {
                    chatList.isBlockedFromSeeker = false
                    NotificationCenter.default.post(name: .refreshUnblockList, object: params)
                }
            }
        }
    }

    func sendTextMessage(message: String, recruiterId: String) {
        let params = [
            "fromId": UserManager.shared().activeUser.userId,
            "toId": recruiterId,
            "message": message,
        ]

        manager.defaultSocket.emitWithAck("sendMessage", params).timingOut(after: 0) { (params: [Any]) in
            self.handleReceivedChatMessage(params: params, isMine: true)
        }
    }

    func updateMessageRead() {
        let params = [
            "toId": UserManager.shared().activeUser.userId,
            "fromId": recruiterId,
        ]

        manager.defaultSocket.emitWithAck("updateReadCount", params).timingOut(after: 0) { (params: [Any]) in
            self.handleUpdateUnreadCounter(params: params)
        }
    }

    func notOnChat() {
        let params = [
            "fromId": UserManager.shared().activeUser.userId,
        ]
        manager.defaultSocket.emitWithAck("notOnChat", params).timingOut(after: 0) { (_: [Any]) in
            // debugPrint(params)
        }
    }

    func getChatMessage(completionHandler: @escaping (_ messageInfo: [String: AnyObject], _ isMine: Bool) -> Void) {
        chatCompletionHandler = completionHandler
    }

    func getChatHistory() {
        if UserDefaultsManager.sharedInstance.isHistoryRetrieved {
            return
        }
        if manager.defaultSocket.status == .connected {
            let params = [
                "fromId": UserManager.shared().activeUser.userId,
            ]
            manager.defaultSocket.emitWithAck("getChatHistory", params).timingOut(after: 0) { (_: [Any]) in
                // debugPrint(params)
            }
        }
    }

    func getHistory(recruiterId: String, completionHandler: @escaping (_ messageInfo: [Any]) -> Void) {
        historyMessagesCompletionHandler = completionHandler
        let params = [
            "fromId": UserManager.shared().activeUser.userId,
            "toId": recruiterId,
        ] as [String: Any]
        manager.defaultSocket.emit("getHistory", params)
    }

    func getLeftMessages(recruiterId: String, messageId: Int, completionHandler: @escaping (_ messageInfo: [Any]) -> Void) {
        getLeftMessagesCompletionHandler = completionHandler
        let params = [
            "fromId": UserManager.shared().activeUser.userId,
            "toId": recruiterId,
            "messageId": messageId,
        ] as [String: Any]
        manager.defaultSocket.emitWithAck("getLeftMessages", params).timingOut(after: 0) { (params: [Any]) in
            self.getLeftMessagesCompletionHandler!(params)
        }
    }

    private func listenForOtherMessages() {
        manager.defaultSocket.on("userTypingUpdate") { (dataArray, _) -> Void in
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "userTypingNotification"), object: dataArray[0] as? [String: AnyObject])
        }
    }
    
    // MARK: - Events for On

    func eventForReceiveMessage() {
        manager.defaultSocket.off("receiveMessage")
        manager.defaultSocket.on("receiveMessage") { (dataArray, _) -> Void in
            self.handleReceivedChatMessage(params: dataArray, isMine: false)
        }
    }

    func eventForLogoutPreviousSession() {
        manager.defaultSocket.off("logoutPreviousSession")
        manager.defaultSocket.on("logoutPreviousSession") { (dataArray, _) -> Void in
            if let messageDictionary = dataArray[0] as? [String: AnyObject], let logout = messageDictionary["logout"] as? Bool {
                if logout == true {
                    Utilities.logOutOfInvalidToken()
                }
            }
            
            
        }
    }

    func eventForHistoryMessages() {
        manager.defaultSocket.off("getMessages")
        manager.defaultSocket.on("getMessages") { (dataArray, _) -> Void in
            let messageDictionary = dataArray
            if let _ = self.historyMessagesCompletionHandler {
                self.historyMessagesCompletionHandler?(messageDictionary)
            } else {
                // debugPrint("not on chat page")
            }
        }
    }

    func removeAllCompletionHandlers() {
        chatCompletionHandler = nil
        historyMessagesCompletionHandler = nil
        recruiterId = "0"
    }

    func makeNotificationData(chat: JSON?) {
        DatabaseManager.addUpdateChatToDB(chatObj: chat)
    }

    // MARK: - Handling

    func handleReceivedChatMessage(params: [Any], isMine: Bool) {
        guard let messageDictionary = params[0] as? [String: AnyObject] else {return}

        if let _ = self.chatCompletionHandler {
            chatCompletionHandler?(messageDictionary, isMine)
            let chatObj = JSON(rawValue: messageDictionary)
            if chatObj!["messageListId"].exists() {
                handleFirstTimeRecruiterMessage(chatObj: chatObj)
            }
        } else {
            // debugPrint("not on chat page")
            let chatObj = JSON(rawValue: messageDictionary)
            if chatObj!["messageListId"].exists() {
                handleFirstTimeRecruiterMessage(chatObj: chatObj)
            } else {
                makeNotificationData(chat: chatObj)
            }
        }
    }

    func handleUpdateUnreadCounter(params: [Any]) {
        guard let messageDictionary = params[0] as? [String: AnyObject] else {return}
        if let unreadCounterObject = JSON(rawValue: messageDictionary) {
            // debugPrint(unreadCounterObject)
            DatabaseManager.updateReadCount(recruiterId: unreadCounterObject["recruiterId"].stringValue)
        }
    }

    func handleFirstTimeRecruiterMessage(chatObj: JSON?) {
        if let chatObj = chatObj {
            // First time recruiter message
            DatabaseManager.insertNewMessageListObj(chatObj: chatObj)
        }
    }
}

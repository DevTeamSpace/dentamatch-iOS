import RealmSwift
import SwiftyJSON
import UIKit

class DatabaseManager: NSObject {

    class func clearDB() {
        clearChatList()
        clearChats()
    }

     class func clearChatList() {
        
        let realm = try! Realm()
        try! realm.write {
            realm.delete(realm.objects(ChatListModel.self))
        }
    }
    
    class func clearChatList(recruiterId: String) {
        
        let realm = try! Realm()
        try! realm.write {
            let chatLists = realm.objects(ChatListModel.self).filter("recruiterId == %@", recruiterId)
            realm.delete(chatLists)
        }
    }
    

    class func clearChats() {
        
        let realm = try! Realm()
        try! realm.write {
            realm.delete(realm.objects(ChatModel.self))
        }
    }
    
    class func clearChats(recruiterId: String) {
        
        let realm = try! Realm()
        try! realm.write {
            let chats = realm.objects(ChatModel.self).filter("toId == %@ OR fromId == %@", recruiterId, recruiterId)
            realm.delete(chats)
        }
    }
    
    class func makeNotificationData(chatObj: JSON?) {
        guard let chatObj = chatObj,
            let user = UserManager.shared().activeUser,
            chat(with: chatObj["messageId"].intValue) == nil else { return }
        
        let realm = try! Realm()
        try! realm.write {
            
            let isSenderChat = chatObj["fromId"].stringValue == user.userId
            if let chatList = chatListExists(recruiterId: isSenderChat ? chatObj["toId"].stringValue : chatObj["fromId"].stringValue) {
                
                chatList.lastMessage = chatObj["message"].stringValue
                chatList.lastMessageId = chatObj["messageId"].stringValue
                chatList.timeStamp = chatObj["sentTime"].doubleValue
                
                if !isSenderChat {
                    
                    chatList.unreadCount = chatList.unreadCount + 1
                    
                    ToastView.showNotificationToast(message: chatObj["message"].stringValue, name: chatObj["fromName"].stringValue, imageUrl: "", type: .white, onCompletion: {
                        kAppDelegate?.chatSocketNotificationTap(recruiterId: chatObj["fromId"].stringValue, officeName: chatObj["fromName"].stringValue)
                    })
                }
                
                realm.add(chatList, update: true)
            }
        }
        
        kAppDelegate?.rootFlowCoordinator?.updateMessagesBadgeValue(count: getUnreadedMessages())
    }

    class func addUpdateChatsToDB(chatObjs: [JSON]) {
        
        let chatModels = chatObjs.map({ (obj) -> ChatModel in
            let model = ChatModel(chatObj: obj)
            
            let filteredDateTime = DatabaseManager.getDate(timestamp: obj["sentTime"].doubleValue)
            model.timeString = filteredDateTime.time
            model.dateString = filteredDateTime.date
            
            return model
        })
        
        if let user = UserManager.shared().activeUser {
            
            let realm = try! Realm()
            try! realm.write {
                
                realm.add(chatModels, update: true)
                
                var chatLists = [ChatListModel]()
                
                for chatObj in chatObjs {
                    let isSenderChat = chatObj["fromId"].stringValue == user.userId
                    if let chatList = chatListExists(recruiterId: isSenderChat ? chatObj["toId"].stringValue : chatObj["fromId"].stringValue) {
                        
                        chatList.lastMessage = chatObj["message"].stringValue
                        chatList.lastMessageId = chatObj["messageId"].stringValue
                        chatList.timeStamp = chatObj["sentTime"].doubleValue
                        
                        if !isSenderChat {
                            chatList.unreadCount = chatList.unreadCount + 1
                        }
                        
                        chatLists.append(chatList)
                    }
                }
                
                realm.add(chatLists, update: true)
            }
            
            kAppDelegate?.rootFlowCoordinator?.updateMessagesBadgeValue(count: getUnreadedMessages())
        }
    }

    class func updateReadCount(recruiterId: String) {
        
        let realm = try! Realm()
        try! realm.write {
            
            if recruiterId != "0" {
                if let chatList = chatListExists(recruiterId: recruiterId) {
                    chatList.unreadCount = 0
                }
            }
        }
        
        kAppDelegate?.rootFlowCoordinator?.updateMessagesBadgeValue(count: getUnreadedMessages())
    }

    class func chat(with messageId: Int) -> ChatModel? {
        return try! Realm().object(ofType: ChatModel.self, forPrimaryKey: messageId)
    }

    class func chatListExists(recruiterId: String) -> ChatListModel? {
        return try! Realm().objects(ChatListModel.self).filter("recruiterId == %@", recruiterId).first
    }

    class func getCountForChats(recruiterId: String) -> Int {
        
        let realm = try! Realm()
        let userId = UserManager.shared().activeUser.userId
        let chatModel = realm.objects(ChatModel.self)
            .filter("(fromId == %@ AND toId == %@) OR (fromId == %@ AND toId == %@)", userId, recruiterId, recruiterId, userId)
        
        return chatModel.count
    }

    class func insertChats(chats: [JSON]?) {
        guard let chats = chats else { return }
        addUpdateChatsToDB(chatObjs: chats)
    }

    class func insertNewMessageListObj(chatObj: JSON) {
        let chatList = ChatListModel(chatListObj: chatObj)
        chatList.date = getMessageDate(timestamp: chatObj["timestamp"].stringValue)
        chatList.unreadCount = 1
        let realm = try! Realm()
        try! realm.write {
            realm.add(chatList, update: true)
        }
        
        NotificationCenter.default.post(name: .hideMessagePlaceholder, object: nil)
        
        ToastView.showNotificationToast(message: chatObj["message"].stringValue, name: chatObj["name"].stringValue, imageUrl: "", type: .white, onCompletion: {
            kAppDelegate?.chatSocketNotificationTap(recruiterId: chatObj["recruiterId"].stringValue, officeName: chatList.officeName)
        })
        
        addChatForFirstTimeMessage(chatObj: chatObj)
    }

    class func addChatForFirstTimeMessage(chatObj: JSON?) {
        guard let chatObj = chatObj else { return }
        
        if let _ = chat(with: chatObj["messageId"].intValue) {
            // Update chat
            // debugPrint("Update Chat")
            
        } else {
            
            let chatModel = ChatModel(chatObj: chatObj)
            
            if let user = UserManager.shared().activeUser {
                
                chatModel.fromId = chatObj["recruiterId"].stringValue
                chatModel.toId = user.userId
                chatModel.timeStamp = chatObj["timestamp"].doubleValue
                let filteredDateTime = DatabaseManager.getDate(timestamp: chatObj["timestamp"].doubleValue)
                chatModel.timeString = filteredDateTime.time
                chatModel.dateString = filteredDateTime.date
            }
            
            let realm = try! Realm()
            try! realm.write {
                realm.add(chatModel, update: true)
            }
        }
    }

    class func getDate(timestamp: Double) -> (time: String, date: String) {
        let date = Date(timeIntervalSince1970: timestamp / 1000)
        let dateFormatter = DateFormatter()
        dateFormatter.amSymbol = "am"
        dateFormatter.pmSymbol = "pm"
        dateFormatter.dateFormat = Date.dateFormatYYYYMMDDHHMMSSAA()

        dateFormatter.dateFormat = Date.dateFormatHHMM()
        let dateEnter1 = dateFormatter.string(from: date)
        dateFormatter.dateFormat = Date.dateFormatMMDDYYYY()
        let dateEnter2 = dateFormatter.string(from: date)
        return (dateEnter1, dateEnter2)
    }

    class func getMessageDate(timestamp: String) -> Date {
        guard let time = TimeInterval(timestamp) else { return Date() }
        let lastMessageDate = Date(timeIntervalSince1970: time / 1000)
        return lastMessageDate
    }
    
    class func getUnreadedMessages() -> Int {
        return try! Realm().objects(ChatListModel.self).map({ $0.unreadCount }).reduce(0, +)
    }
}

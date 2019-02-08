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
            let chatLists = realm.objects(ChatListModel.self).filter({ $0.recruiterId == recruiterId })
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
            let chats = realm.objects(ChatModel.self).filter({ $0.toId == recruiterId || $0.fromId == recruiterId })
            realm.delete(chats)
        }
    }

    class func addUpdateChatToDB(chatObj: JSON?) {
        guard let chatObj = chatObj else { return }
        
        if let _ = chatExits(messageId: chatObj["messageId"].intValue) {
            // Update chat
            // debugPrint("Update Chat")
            
        } else {
            // New chat
            let chatModel = ChatModel(chatObj: chatObj)
            
            let filteredDateTime = DatabaseManager.getDate(timestamp: chatObj["sentTime"].doubleValue)
            chatModel.timeString = filteredDateTime.time
            chatModel.dateString = filteredDateTime.date
            
            if let user = UserManager.shared().activeUser {
                
                let realm = try! Realm()
                try! realm.write {
                    
                    realm.add(chatModel, update: true)
                    
                    let isSenderChat = chatObj["fromId"].stringValue == user.userId
                    if let chatList = chatListExists(recruiterId: isSenderChat ? chatObj["toId"].stringValue : chatObj["fromId"].stringValue) {
                        
                        chatList.lastMessage = chatObj["message"].stringValue
                        chatList.lastMessageId = chatObj["messageId"].stringValue
                        chatList.timeStamp = chatObj["sentTime"].doubleValue
                        
                        if !isSenderChat {
                            
                            chatList.unreadCount = chatList.unreadCount + 1
                            
                            ToastView.showNotificationToast(message: chatObj["message"].stringValue, name: chatObj["fromName"].stringValue, imageUrl: "", type: .white, onCompletion: {
                                kAppDelegate?.chatSocketNotificationTap(recruiterId: chatObj["fromId"].stringValue)
                            })
                        }
                        
                        realm.add(chatList, update: true)
                    }
                }
            }
        }
    }

    class func updateReadCount(recruiterId: String) {
        
        try! Realm().write {
            
            if recruiterId != "0" {
                if let chatList = chatListExists(recruiterId: recruiterId) {
                    chatList.unreadCount = 0
                }
            }
        }
    }

    class func chatExits(messageId: Int) -> ChatModel? {
        return try! Realm().object(ofType: ChatModel.self, forPrimaryKey: messageId)
    }

    class func chatListExists(recruiterId: String) -> ChatListModel? {
        return try! Realm().objects(ChatListModel.self).filter({ $0.recruiterId == recruiterId }).first
    }

    class func getCountForChats(recruiterId: String) -> Int {
        
        let realm = try! Realm()
        let userId = UserManager.shared().activeUser.userId
        let chatModel = realm.objects(ChatModel.self).filter({ ($0.fromId == userId && $0.toId == recruiterId) || ($0.fromId == recruiterId && $0.toId == userId) })
        
        return chatModel.count
    }

    class func insertChats(chats: [JSON]?) {
        guard let chats = chats else { return }
        
        for chatObj in chats {
            addUpdateChatToDB(chatObj: chatObj)
        }
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
            kAppDelegate?.chatSocketNotificationTap(recruiterId: chatObj["recruiterId"].stringValue)
        })
        
        addChatForFirstTimeMessage(chatObj: chatObj)
    }

    class func addChatForFirstTimeMessage(chatObj: JSON?) {
        guard let chatObj = chatObj else { return }
        
        if let _ = chatExits(messageId: chatObj["messageId"].intValue) {
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
}

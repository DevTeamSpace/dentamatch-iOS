import Foundation
import RealmSwift
import SwiftyJSON

@objcMembers
class ChatListModel: Object {
    
    dynamic var messageListId: String = ""
    dynamic var date: Date?
    dynamic var isBlockedFromRecruiter: Bool = false
    dynamic var isBlockedFromSeeker: Bool = false
    dynamic var lastMessage: String = ""
    dynamic var lastMessageId: String = ""
    dynamic var officeName: String = ""
    dynamic var recruiterId: String = ""
    dynamic var timeStamp: Double = 0.0
    dynamic var unreadCount: Int = 0
    
    override static func primaryKey() -> String? {
        return "messageListId"
    }
    
    convenience init(chatListObj: JSON) {
        self.init()
        
        messageListId = chatListObj["messageListId"].stringValue
        lastMessage = chatListObj["message"].stringValue
        recruiterId = chatListObj["recruiterId"].stringValue
        isBlockedFromRecruiter = chatListObj["recruiterBlock"].boolValue
        isBlockedFromSeeker = chatListObj["seekerBlock"].boolValue
        timeStamp = chatListObj["timestamp"].doubleValue
        officeName = chatListObj["name"].stringValue
        lastMessageId = chatListObj["messageId"].stringValue
        unreadCount = chatListObj["unreadCount"].intValue
    }
}

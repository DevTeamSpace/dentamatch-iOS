import Foundation
import RealmSwift
import SwiftyJSON

@objcMembers
class ChatModel: Object {
    
    dynamic var id: Int = 0
    dynamic var dateString: String = ""
    dynamic var dateTime: String?
    dynamic var fromId: String = ""
    dynamic var message: String = ""
    dynamic var readStatus: Int = -1
    dynamic var timeStamp: Double = 0.0
    dynamic var timeString: String = ""
    dynamic var toId: String = ""
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    convenience init(chatObj: JSON) {
        self.init()
        
        id = chatObj["messageId"].int ?? 0
        message = chatObj["message"].stringValue
        fromId = chatObj["fromId"].stringValue
        toId = chatObj["toId"].stringValue
        timeStamp = chatObj["sentTime"].doubleValue
    }
}

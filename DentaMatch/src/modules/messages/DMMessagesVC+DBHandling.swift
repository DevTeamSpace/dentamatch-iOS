import Foundation
import SwiftyJSON
import RealmSwift

extension DMMessagesVC {
    
    func addUpdateMessageToDB(chatList: [JSON]?) {
        guard let chatList = chatList else { return }
        
        let realm = try! Realm()
        try! realm.write {
            
            realm.add(chatList.map({
                
                let model = ChatListModel(chatListObj: $0)
                model.date = getDate(timestamp: $0["timestamp"].stringValue)
                return model
            }), update: true)
        }
    }

    func getDate(timestamp: String) -> Date {
        let doubleTime = Double(timestamp)
        let lastMessageDate = Date(timeIntervalSince1970: doubleTime! / 1000)
        return lastMessageDate
    }
}

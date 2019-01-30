import Foundation
import SwiftyJSON
import RealmSwift

extension DMChatVC {
    
    func addUpdateChatToDB(chatObj: JSON?) {
        
        DatabaseManager.addUpdateChatToDB(chatObj: chatObj)
    }

    func getChats() {
        
        let realm = try! Realm()
        let userId = UserManager.shared().activeUser.userId
        
        guard let recruiterId = chatList?.recruiterId else { return }
        
        let chats = Array(realm.objects(ChatModel.self).filter({ ($0.fromId == userId && $0.toId == recruiterId) || ($0.fromId == recruiterId && $0.toId == userId) })).sorted(by: { $0.timeStamp < $1.timeStamp })
        
        if notificationToken == nil {
            notificationToken = realm.objects(ChatModel.self).observe({ [weak self] _ in
                self?.getChats()
            })
        }
        
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
        
        DispatchQueue.main.async {
            self.chatTableView.reloadData()
            self.scrollTableToBottom()
        }
    }

    func scrollTableToBottom() {
        
        chatTableView.scrollToRow(at: IndexPath(row: chatsArray[chatsArray.count - 1].count - 1, section: chatsArray.count - 1), at: .bottom, animated: false)
    }
}

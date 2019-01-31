import Foundation
import SwiftyJSON
import RealmSwift

extension DMMessagesVC {
    func getChatListAPI(isLoaderHidden: Bool = false) {
        
        getMessageList()
        
        if !isLoaderHidden, chatListArray.isEmpty {
            showLoader()
        }
        
        APIManager.apiGet(serviceName: Constants.API.getChatUserList, parameters: [:]) {[weak self] (response: JSON?, error: NSError?) in
            self?.refreshControl.endRefreshing()
            self?.hideLoader()
            if error != nil {
                self?.makeToast(toastString: (error?.localizedDescription)!)
                self?.getMessageList()
                return
            }
            guard let _ = response else {
                self?.makeToast(toastString: Constants.AlertMessage.somethingWentWrong)
                return
            }
            // print(response!)
            DatabaseManager.clearChatList()
            self?.handleChatListResponse(response: response)
            self?.getMessageList()
        }
    }

    func handleChatListResponse(response: JSON?) {
        if let response = response {
            if response[Constants.ServerKey.status].boolValue {
                let chatUserList = response[Constants.ServerKey.result][Constants.ServerKey.list].arrayValue
                if chatUserList.count > 0 {
                    addUpdateMessageToDB(chatList: chatUserList)
                    placeHolderEmptyJobsView?.isHidden = true
                } else {
                    placeHolderEmptyJobsView?.isHidden = false
//                    self.makeToast(toastString: "No messages")
                }
            } else {
                makeToast(toastString: response[Constants.ServerKey.message].stringValue)
            }
        }
    }
    
    func blockRecruiter(chatList: ChatListModel) {
        let params = [
            Constants.ServerKey.recruiterId: chatList.recruiterId,
            Constants.ServerKey.blockStatus: "1",
            ] as [String: Any]
        showLoader()
        APIManager.apiPost(serviceName: Constants.API.blockUnblockRecruiter, parameters: params) { (response: JSON?, error: NSError?) in
            self.hideLoader()
            if error != nil {
                self.makeToast(toastString: (error?.localizedDescription)!)
                return
            }
            guard let _ = response else {
                self.makeToast(toastString: Constants.AlertMessage.somethingWentWrong)
                return
            }
            // debugPrint(response!)
            self.handleBlockRecruiterResponse(chatList: chatList, response: response)
        }
    }

    func handleBlockRecruiterResponse(chatList: ChatListModel, response: JSON?) {
        if let response = response {
            if response[Constants.ServerKey.status].boolValue {
                
                try! Realm().write {
                    if response[Constants.ServerKey.result][Constants.ServerKey.blockStatus].stringValue == "1" {
                        chatList.isBlockedFromSeeker = true
                        makeToast(toastString: "This Recruiter is Blocked and will no longer be able to see your profile or send you messages.")
                    } else {
                        chatList.isBlockedFromSeeker = false
                        makeToast(toastString: "Recruiter Unblocked")
                    }
                }
            } else {
                makeToast(toastString: response[Constants.ServerKey.message].stringValue)
            }
        }
    }
    
    func deleteChat(chatList: ChatListModel) {
        let params = [
            Constants.ServerKey.recruiterId: chatList.recruiterId
            ] as [String: Any]
        showLoader()
        APIManager.apiPost(serviceName: Constants.API.chatDelete, parameters: params) { (response: JSON?, error: NSError?) in
            self.hideLoader()
            if error != nil {
                self.makeToast(toastString: (error?.localizedDescription)!)
                return
            }
            guard let _ = response else {
                self.makeToast(toastString: Constants.AlertMessage.somethingWentWrong)
                return
            }
            // debugPrint(response!)
            self.handleChatDeleteResponse(chatList: chatList, response: response)
        }
    }
    
    func handleChatDeleteResponse(chatList: ChatListModel, response: JSON?) {
        if let response = response {
            if response[Constants.ServerKey.status].boolValue {
                makeToast(toastString: "This chat history with this Recruiter is deleted you will no longer be able to see the previous chat.")
                DatabaseManager.clearChats(recruiterId: chatList.recruiterId)
                DatabaseManager.clearChatList(recruiterId: chatList.recruiterId)
                self.refreshMessageList()
            } else {
                makeToast(toastString: response[Constants.ServerKey.message].stringValue)
            }
        }
    }
}
import Foundation
import SwiftyJSON
import RealmSwift

extension DMChatVC {
    func unBlockRecruiter(chatList: ChatListModel) {
        let params = [
            Constants.ServerKey.recruiterId: chatList.recruiterId,
            Constants.ServerKey.blockStatus: "0",
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
            self.handleUnblockRecruiterResponse(chatList: chatList, response: response)
        }
    }

    func handleUnblockRecruiterResponse(chatList: ChatListModel, response: JSON?) {
        if let response = response {
            if response[Constants.ServerKey.status].boolValue {
                
                try! Realm().write {
                    
                    if response[Constants.ServerKey.result][Constants.ServerKey.blockStatus].stringValue == "1" {
                        chatList.isBlockedFromSeeker = true
                        makeToast(toastString: "Recruiter Blocked")
                    } else {
                        chatList.isBlockedFromSeeker = false
                        DispatchQueue.main.async {
                            self.chatTextView.isHidden = false
                            self.sendButton.isHidden = false
                            self.unblockButton.isHidden = true
                        }
                        makeToast(toastString: "Recruiter Unblocked")
                    }
                }
            } else {
                makeToast(toastString: response[Constants.ServerKey.message].stringValue)
            }
        }
    }
}

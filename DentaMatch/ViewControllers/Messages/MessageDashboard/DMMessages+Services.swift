//
//  DMMessages+Services.swift
//  DentaMatch
//
//  Created by Rajan Maheshwari on 07/02/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import Foundation
import SwiftyJSON

extension DMMessagesVC {
    func getChatListAPI() {
        showLoader()
        APIManager.apiGet(serviceName: Constants.API.getChatUserList, parameters: [:]) { (response: JSON?, error: NSError?) in
            self.hideLoader()
            if error != nil {
                self.makeToast(toastString: (error?.localizedDescription)!)
                self.getMessageList()
                return
            }
            guard let _ = response else {
                self.makeToast(toastString: Constants.AlertMessage.somethingWentWrong)
                return
            }
            // print(response!)
            self.handleChatListResponse(response: response)
            self.getMessageList()
        }
    }

    func blockRecruiter(chatList: ChatList) {
        let params = [
            Constants.ServerKey.recruiterId: chatList.recruiterId!,
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

    func handleBlockRecruiterResponse(chatList: ChatList, response: JSON?) {
        if let response = response {
            if response[Constants.ServerKey.status].boolValue {
                if response[Constants.ServerKey.result][Constants.ServerKey.blockStatus].stringValue == "1" {
                    chatList.isBlockedFromSeeker = true
                    makeToast(toastString: "Recruiter Blocked")
                } else {
                    chatList.isBlockedFromSeeker = false
                    makeToast(toastString: "Recruiter Unblocked")
                }
                appDelegate?.saveContext()
            } else {
                makeToast(toastString: response[Constants.ServerKey.message].stringValue)
            }
        }
    }
}

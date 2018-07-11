//
//  DMChatVC+Services.swift
//  DentaMatch
//
//  Created by Rajan Maheshwari on 08/02/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import Foundation
import SwiftyJSON

extension DMChatVC {
    func unBlockRecruiter(chatList: ChatList) {
        let params = [
            Constants.ServerKey.recruiterId: chatList.recruiterId!,
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

    func handleUnblockRecruiterResponse(chatList: ChatList, response: JSON?) {
        if let response = response {
            if response[Constants.ServerKey.status].boolValue {
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
                appDelegate?.saveContext()
            } else {
                makeToast(toastString: response[Constants.ServerKey.message].stringValue)
            }
        }
    }
}

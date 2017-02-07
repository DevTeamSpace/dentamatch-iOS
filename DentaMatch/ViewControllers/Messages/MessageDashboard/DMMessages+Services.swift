//
//  DMMessages+Services.swift
//  DentaMatch
//
//  Created by Rajan Maheshwari on 07/02/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import Foundation
import SwiftyJSON
import CoreData

extension DMMessagesVC {
    
    func getChatListAPI() {
        self.showLoader()
        APIManager.apiGet(serviceName: Constants.API.getChatUserList, parameters: [:]) { (response:JSON?, error:NSError?) in
            self.hideLoader()
            if error != nil {
                self.makeToast(toastString: (error?.localizedDescription)!)
                return
            }
            guard let _ = response else {
                self.makeToast(toastString: Constants.AlertMessage.somethingWentWrong)
                return
            }
            print(response!)
            self.handleChatListResponse(response: response)
        }
    }
    
    func blockRecruiter() {
        print("blockRecruiter")
    }
    
    func handleChatListResponse(response:JSON?) {
        if let response = response {
            if response[Constants.ServerKey.status].boolValue {
                let chatUserList = response[Constants.ServerKey.result][Constants.ServerKey.list].arrayValue
                if chatUserList.count > 0 {
                    self.addUpdateMessageToDB(chatList: chatUserList)
                } else {
                    self.makeToast(toastString: "No messages")
                }
            } else {
                self.makeToast(toastString: response[Constants.ServerKey.message].stringValue)
            }
        }
    }
    
    func addUpdateMessageToDB(chatList:[JSON]?) {
        
        DispatchQueue.global(qos: .background).async {
            print("This will run on the main queue, after the previous code in outer block")
            for chatListObj in chatList! {
                let chat = NSEntityDescription.insertNewObject(forEntityName: "ChatList", into: self.context) as! ChatList
                chat.lastMessage = chatListObj["message"].stringValue
                chat.recruiterId = chatListObj["recruiterId"].stringValue
                chat.isBlockedFromRecruiter = chatListObj["recruiterBlock"].boolValue
                chat.isBlockedFromSeeker = chatListObj["seekerBlock"].boolValue
                chat.dateString = chatListObj["timestamp"].stringValue
                chat.officeName = chatListObj["name"].stringValue

//                if (true) {
//                } else {
//                    let chat = NSEntityDescription.insertNewObject(forEntityName: "ChatList", into: self.context) as! ChatList
//                    chat.lastMessage! = ""
//                }
            }
           
            DispatchQueue.main.async {
                print("This is run on the main queue, after the previous code in outer block")
                self.appDelegate.saveContext()
            }
        }
    }
}

//
//  SocketManager.swift
//  SocketChatManager
//
//  Created by Rajan Maheshwari on 10/11/16.
//  Copyright © 2016 Rajan Maheshwari. All rights reserved.
//

import UIKit
import SwiftyJSON
import UserNotifications

class SocketManager: NSObject,SocketConnectionDelegate {
    
    static let sharedInstance = SocketManager()
    
    typealias ReceiveMessageClosure = ((_ messageInfo: [String: AnyObject],_ isMine:Bool)->Void)
    private var chatCompletionHandler: ReceiveMessageClosure?
    
    //To check whether the same recruiter is chatting
    var recruiterId = "0"
    
    typealias HistoryCallBackClosure = ((_ messageInfo: [Any])->Void)
    private var historyMessagesCompletionHandler: HistoryCallBackClosure?
    
    typealias GetLeftMessagesCallBackClosure = ((_ messageInfo: [Any])->Void)
    private var getLeftMessagesCompletionHandler: GetLeftMessagesCallBackClosure?
    
    var socket = SocketIOClient(socketURL: URL(string:ConfigurationManager.sharedManager().socketEndPoint())!)
    
    override init() {
        super.init()
    }
    
    func establishConnection() {
 //     DefaultSocketLogger.Logger.log = true
//      socket.engine?.ws?.voipEnabled = true
        socket.delegate = self
        socket.connect()
    }
    
    func closeConnection() {
        socket.disconnect()
    }
    
    func initServer() {
        /*
         userType:
         1 is for jobseeker,
         2 is recruiter
         */
        
        let params = [
            "userId":UserManager.shared().activeUser.userId!,
            "userName":UserManager.shared().activeUser.firstName!,
            "userType":1
        ] as [String : Any]
        socket.emitWithAck("init", params).timingOut(after: 0) { (params:[Any]) in
            //debugPrint(params)
            NotificationCenter.default.post(name: .refreshMessageList, object: nil)
            NotificationCenter.default.post(name: .refreshChat, object: nil)
            //self.getChatHistory()
        }
    }
    
    func handleBlockUnblock(chatList:ChatList,blockStatus:String) {
        let params = [
            "fromId":UserManager.shared().activeUser.userId!,
            "toId":chatList.recruiterId!,
            "blockStatus":blockStatus
        ]
        
        //debugPrint(params)

        socket.emitWithAck("blockUnblock", params).timingOut(after: 0) { (params:[Any]) in
            //debugPrint(params)
            if blockStatus == "1" {
                 chatList.isBlockedFromSeeker = true
                NotificationCenter.default.post(name: .refreshBlockList, object: params)
            } else {
                chatList.isBlockedFromSeeker = false
                NotificationCenter.default.post(name: .refreshUnblockList, object: params)
            }
            kAppDelegate.saveContext()
        }
    }
    
    func sendTextMessage(message: String,recruiterId:String) {
        let params = [
            "fromId":UserManager.shared().activeUser.userId!,
            "toId":recruiterId,
            "message":message
        ]
        
        socket.emitWithAck("sendMessage", params).timingOut(after: 0) { (params:[Any]) in
            self.handleReceivedChatMessage(params: params, isMine: true)
        }
        
        //socket.emit("sendMessage", with: [params])
    }
    
    func updateMessageRead() {
        let params = [
            "toId":UserManager.shared().activeUser.userId!,
            "fromId":recruiterId,
        ]
        
        socket.emitWithAck("updateReadCount", params).timingOut(after: 0) { (params:[Any]) in
            self.handleUpdateUnreadCounter(params: params)
        }
    }
    
    func notOnChat() {
        let params = [
            "fromId":UserManager.shared().activeUser.userId!,
            ]
        socket.emitWithAck("notOnChat", params).timingOut(after: 0) { (params:[Any]) in
            //debugPrint(params)
        }
    }
    
    
    func getChatMessage(completionHandler: @escaping (_ messageInfo: [String: AnyObject],_ isMine:Bool) -> Void) {
        self.chatCompletionHandler = completionHandler
    }
    
    func getChatHistory() {
        if UserDefaultsManager.sharedInstance.isHistoryRetrieved {
            return
        }
        if socket.status == .connected {
            let params = [
                "fromId":UserManager.shared().activeUser.userId!
            ]
            socket.emitWithAck("getChatHistory", params).timingOut(after: 0) { (params:[Any]) in
                //debugPrint(params)
            }
        }
    }
    
    func getHistory(recruiterId:String,completionHandler: @escaping (_ messageInfo: [Any]) -> Void) {
        self.historyMessagesCompletionHandler = completionHandler
        let params = [
            "fromId":UserManager.shared().activeUser.userId!,
            "toId":recruiterId,
        ] as [String : Any]
        socket.emit("getHistory", params)
    }
    
    func getLeftMessages(recruiterId:String,messageId:Int64,completionHandler: @escaping (_ messageInfo: [Any]) -> Void) {
        self.getLeftMessagesCompletionHandler = completionHandler
        let params = [
            "fromId":UserManager.shared().activeUser.userId!,
            "toId":recruiterId,
            "messageId":messageId
            ] as [String : Any]
        socket.emitWithAck("getLeftMessages", params).timingOut(after: 0) { (params:[Any]) in
            self.getLeftMessagesCompletionHandler!(params)
        }

    }
    
    private func listenForOtherMessages() {
        socket.on("userTypingUpdate") { (dataArray, socketAck) -> Void in
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "userTypingNotification"), object: dataArray[0] as? [String: AnyObject])
        }
    }
    
    //MARK:- Socket Delegates
    func didConnectSocket() {
        //debugPrint("Socket Connected")
        if let _ = UserManager.shared().activeUser {
            self.initServer()
            eventForReceiveMessage()
            eventForHistoryMessages()
            eventForLogoutPreviousSession()
            //getChatHistory()
        }
    }
    
    func didDisconnectSocket() {
        //debugPrint("Socket Disconnected")
    }
    
    //MARK:- Events for On
    func eventForReceiveMessage() {
        socket.off("receiveMessage")
        socket.on("receiveMessage") { (dataArray, socketAck) -> Void in
            self.handleReceivedChatMessage(params: dataArray, isMine: false)
        }
    }
    
    func eventForLogoutPreviousSession() {
        socket.off("logoutPreviousSession")
        socket.on("logoutPreviousSession") { (dataArray, socketAck) -> Void in
           // var messageDictionary = [String: AnyObject]()
            let messageDictionary = dataArray[0] as! [String:AnyObject]
            if messageDictionary["logout"] as! Bool {
                Utilities.logOutOfInvalidToken()
            }
        }
    }
    
    func eventForHistoryMessages() {
        socket.off("getMessages")
        socket.on("getMessages") { (dataArray, socketAck) -> Void in
            //var messageDictionary = [Any]()
            let messageDictionary = dataArray
            if let _ = self.historyMessagesCompletionHandler {
                self.historyMessagesCompletionHandler?(messageDictionary)
            } else {
                //debugPrint("not on chat page")
            }
        }
    }
    
    func removeAllCompletionHandlers() {
        self.chatCompletionHandler = nil
        self.historyMessagesCompletionHandler = nil
        self.recruiterId = "0"
    }
    
    func makeNotificationData(chat:JSON?) {
        DatabaseManager.addUpdateChatToDB(chatObj: chat)
    }
    
    
    //MARK:- Handling
    
    func handleReceivedChatMessage(params:[Any],isMine:Bool) {
        //var messageDictionary = [String: AnyObject]()
        //debugPrint(params)
        let messageDictionary = params[0] as! [String:AnyObject]
        
        if let _ = self.chatCompletionHandler {
            self.chatCompletionHandler?(messageDictionary,isMine)
            let chatObj = JSON(rawValue: messageDictionary)
            if chatObj!["messageListId"].exists(){
                self.handleFirstTimeRecruiterMessage(chatObj: chatObj)
            } else {
                if chatObj!["fromId"].stringValue == self.recruiterId || chatObj!["toId"].stringValue == self.recruiterId {
                    //If app is in background but same chat page is opened
                    return
                } else {
                    self.makeNotificationData(chat: chatObj)
                }
            }
        } else {
            //debugPrint("not on chat page")
            let chatObj = JSON(rawValue: messageDictionary)
            if chatObj!["messageListId"].exists() {
                self.handleFirstTimeRecruiterMessage(chatObj: chatObj)
            } else {
                self.makeNotificationData(chat: chatObj)
            }
        }
    }
    
    func handleUpdateUnreadCounter(params:[Any]) {
        //var messageDictionary = [String: AnyObject]()
        let messageDictionary = params[0] as! [String:AnyObject]
        if let unreadCounterObject = JSON(rawValue: messageDictionary) {
            //debugPrint(unreadCounterObject)
            DatabaseManager.updateReadCount(recruiterId: unreadCounterObject["recruiterId"].stringValue)
        }
    }
    
    func handleFirstTimeRecruiterMessage(chatObj:JSON?) {
        if let chatObj = chatObj {
            //First time recruiter message
            DatabaseManager.insertNewMessageListObj(chatObj: chatObj)
        }
    }
}


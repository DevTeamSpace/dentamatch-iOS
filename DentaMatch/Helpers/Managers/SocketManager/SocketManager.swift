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
    
    typealias ReceiveMessageClosure = ((_ messageInfo: [String: AnyObject])->Void)
    
    private var chatCompletionHandler: ReceiveMessageClosure?
    
    //To check whether the same recruiter is chatting
    var recruiterId = "0"
    
    typealias HistoryCallBackClosure = ((_ messageInfo: [Any])->Void)
    private var historyMessagesCompletionHandler: HistoryCallBackClosure?
    
    var socket = SocketIOClient(socketURL: URL(string: "http://dev.dentamatch.co:3000")!)
    
    override init() {
        super.init()
    }
    
    func establishConnection() {
 //       DefaultSocketLogger.Logger.log = true
//        socket.engine?.ws?.voipEnabled = true
        socket.delegate = self
        socket.connect()
    }
    
    func closeConnection() {
        socket.disconnect()
    }
    
    func initServer() {
        let params = [
            "userId":UserManager.shared().activeUser.userId!,
            "userName":UserManager.shared().activeUser.firstName!
        ]
        socket.emit("init", params)
    }
    
    
    func sendTextMessage(message: String,recruiterId:String) {
        let params = [
            "fromId":UserManager.shared().activeUser.userId!,
            "toId":recruiterId,
            "message":message
        ]
        
        socket.emitWithAck("sendMessage", params).timingOut(after: 0) { (params:[Any]) in
            self.handleReceivedChatMessage(params: params)
        }
        
        //socket.emit("sendMessage", with: [params])
    }
    
    
    func getChatMessage(completionHandler: @escaping (_ messageInfo: [String: AnyObject]) -> Void) {
        self.chatCompletionHandler = completionHandler
    }
    
    func getHistory(pageNo:Int) {
        let params = [
            "fromId":UserManager.shared().activeUser.userId!,
            "toId":"8",
            "pageNo":pageNo
        ] as [String : Any]
        socket.emit("getHistory", params)
    }
    
    func receiveMessages(completionHandler: @escaping (_ messageInfo: [Any]) -> Void) {
        self.historyMessagesCompletionHandler = completionHandler
    }

    func connectToServerWithNickname(nickname: String, completionHandler: @escaping (_ userList: [[String: AnyObject]]?) -> Void) {
        socket.emit("connectUser", nickname)
        
        socket.on("userList") { ( dataArray, ack) -> Void in
            completionHandler(dataArray[0] as? [[String: AnyObject]])
        }
        
        listenForOtherMessages()
    }
    
    func exitChatWithNickname(nickname: String, completionHandler: () -> Void) {
        socket.emit("exitUser", nickname)
        completionHandler()
    }
    
    private func listenForOtherMessages() {
        socket.on("userConnectUpdate") { (dataArray, socketAck) -> Void in
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "userWasConnectedNotification"), object: dataArray[0] as! [String: AnyObject])
        }
        
        socket.on("userExitUpdate") { (dataArray, socketAck) -> Void in
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "userWasDisconnectedNotification"), object: dataArray[0] as! String)
        }
        
        socket.on("userTypingUpdate") { (dataArray, socketAck) -> Void in
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "userTypingNotification"), object: dataArray[0] as? [String: AnyObject])
        }
    }
    
    func sendStartTypingMessage(nickname: String) {
        socket.emit("startType", nickname)
    }
    
    func sendStopTypingMessage(nickname: String) {
        socket.emit("stopType", nickname)
    }
    
    func didConnectSocket() {
        print("Socket Connected")
        if let _ = UserManager.shared().activeUser {
            self.initServer()
            eventForReceiveMessage()
            eventForHistoryMessages()
        }
    }
    
    func didDisconnectSocket() {
        print("Socket Disconnected")
    }
    
    func eventForReceiveMessage() {
        socket.off("receiveMessage")
        socket.on("receiveMessage") { (dataArray, socketAck) -> Void in
            self.handleReceivedChatMessage(params: dataArray)
        }
    }
    
    func eventForHistoryMessages() {
        socket.off("getMessages")
        socket.on("getMessages") { (dataArray, socketAck) -> Void in
            var messageDictionary = [Any]()
            messageDictionary = dataArray
            if let _ = self.historyMessagesCompletionHandler {
                self.historyMessagesCompletionHandler?(messageDictionary)
            } else {
                print("not on chat page")
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
        if UIApplication.shared.applicationState == .active {
            self.scheduleNotification(message: (chat?["message"].stringValue)!)
        }
    }
    
    func scheduleNotification(message:String) {
//        if #available(iOS 10.0, *) {
//            let content = UNMutableNotificationContent()
//            let requestIdentifier = "chatNotification"
//            
//            content.badge = 1
//            content.title = "New Message"
//            content.subtitle = ""
//            content.body = message
////            content.categoryIdentifier = "actionCategory"
//            content.sound = UNNotificationSound.default()
//            content.userInfo = ["myKey": "myValue"] as [String : Any]
//
////            let url = Bundle.main.url(forResource: "DP", withExtension: ".jpg")
////            do {
////                let attachment = try? UNNotificationAttachment(identifier: requestIdentifier, url: url!, options: nil)
////                content.attachments = [attachment!]
////            }
//            let trigger = UNTimeIntervalNotificationTrigger.init(timeInterval: 0.1, repeats: false)
//            
//            let request = UNNotificationRequest(identifier: requestIdentifier, content: content, trigger: trigger)
//            UNUserNotificationCenter.current().add(request) { (error:Error?) in
//                if error != nil {
//                    print((error?.localizedDescription)!)
//                }
//                print("Notification Register Success")
//            }
//
//        } else {
//            // Fallback on earlier versions
//        }
    }
    
    //handling
    
    func handleReceivedChatMessage(params:[Any]) {
        var messageDictionary = [String: AnyObject]()
        messageDictionary = params[0] as! [String:AnyObject]
        if let _ = self.chatCompletionHandler {
            self.chatCompletionHandler?(messageDictionary)
            let chatObj = JSON(rawValue: messageDictionary)
            if chatObj!["fromId"].stringValue == self.recruiterId || chatObj!["toId"].stringValue == self.recruiterId {
                //If app is in background but same chat page is opened
                return
            } else {
                self.makeNotificationData(chat: chatObj)
            }
        } else {
            debugPrint("not on chat page")
            let chatObj = JSON(rawValue: messageDictionary)
            self.makeNotificationData(chat: chatObj)
        }

    }
}


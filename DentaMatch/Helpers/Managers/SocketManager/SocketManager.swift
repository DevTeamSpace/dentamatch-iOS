//
//  SocketManager.swift
//  SocketChatManager
//
//  Created by Rajan Maheshwari on 10/11/16.
//  Copyright © 2016 Rajan Maheshwari. All rights reserved.
//

import UIKit

class SocketManager: NSObject,SocketConnectionDelegate {
    
    static let sharedInstance = SocketManager()
    
    var socket = SocketIOClient(socketURL: URL(string: "http://dev.dentamatch.co:3000")!)

    override init() {
        super.init()
    }
    
    func establishConnection() {
        //DefaultSocketLogger.Logger.log = true
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
    
    func getHistory(pageNo:Int) {
        let params = [
            "fromId":UserManager.shared().activeUser.userId!,
            "toId":"8",
            "pageNo":pageNo
        ] as [String : Any]
        socket.emit("getHistory", params)
    }
    
    func receiveMessages(completionHandler: @escaping (_ messageInfo: [Any]) -> Void) {
        socket.on("getMessages") { (dataArray, socketAck) -> Void in
            var messageDictionary = [Any]()
            messageDictionary = dataArray
            completionHandler(messageDictionary)
        }
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
    
    func sendTextMessage(message: String) {
        let params = [
            "fromId":UserManager.shared().activeUser.userId!,
            "toId":"8",
            "message":message
        ]
        socket.emit("sendMessage", with: [params])
    }
    
    func sendMessage(message: String, withNickname nickname: String) {
        socket.emit("chatMessage", nickname, message)
    }
    
    func getChatMessage(completionHandler: @escaping (_ messageInfo: [String: AnyObject]) -> Void) {
        socket.on("receiveMessage") { (dataArray, socketAck) -> Void in
            var messageDictionary = [String: AnyObject]()
            messageDictionary = dataArray[0] as! [String:AnyObject]
            //            messageDictionary["message"] = dataArray[1] as! String as AnyObject?
//            messageDictionary["date"] = dataArray[2] as! String as AnyObject?
            
            completionHandler(messageDictionary)
        }
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
        }
    }
    
    func didDisconnectSocket() {
        print("Socket Disconnected")

    }
    
}


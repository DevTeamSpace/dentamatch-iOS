//
//  DMMessagesVC+TableViewExtension.swift
//  DentaMatch
//
//  Created by Rajan Maheshwari on 07/02/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import Foundation

extension DMMessagesVC : UITableViewDataSource, UITableViewDelegate {

    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        let chatList = fetchedResultsController.object(at: indexPath) as! ChatList
        if chatList.isBlockedFromSeeker {
            return false
        }
        return true
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let blockAction = UITableViewRowAction(style: .normal, title: "Block", handler: { (action:UITableViewRowAction, indexPath:IndexPath) in
            self.messageListTableView.setEditing(false, animated: true)
            let chatList = self.fetchedResultsController.object(at: indexPath) as! ChatList
            DispatchQueue.main.async {
                self.showBlockRecruiterAlert(chatList: chatList)
            }
        })
        blockAction.backgroundColor = Constants.Color.cancelJobDeleteColor
        return [blockAction]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = fetchedResultsController.sections {
            let sectionInfo = sections[section]
            return sectionInfo.numberOfObjects
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessageListTableCell") as! MessageListTableCell
        let chatList = fetchedResultsController.object(at: indexPath) as! ChatList
        cell.recruiterNameLabel.text = chatList.officeName
        cell.lastMessageLabel.text = chatList.lastMessage
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let chatList = self.fetchedResultsController.object(at: indexPath) as! ChatList
        let chatVC = UIStoryboard.messagesStoryBoard().instantiateViewController(type: DMChatVC.self)!
        chatVC.chatList = chatList
        chatVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(chatVC, animated: true)
    }
}

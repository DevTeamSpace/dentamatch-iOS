//
//  DMMessagesVC+TableViewExtension.swift
//  DentaMatch
//
//  Created by Rajan Maheshwari on 07/02/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import Foundation

extension DMMessagesVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
        return 75
    }

    func tableView(_: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        let chatList = fetchedResultsController.object(at: indexPath) as! ChatList
        if chatList.isBlockedFromSeeker {
            return false
        }
        return true
    }

    func tableView(_: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let blockAction = UITableViewRowAction(style: .normal, title: "Block", handler: { (_: UITableViewRowAction, indexPath: IndexPath) in
            self.messageListTableView.setEditing(false, animated: true)
            let chatList = self.fetchedResultsController.object(at: indexPath) as! ChatList
            DispatchQueue.main.async {
                self.showBlockRecruiterAlert(chatList: chatList)
            }
        })
        blockAction.backgroundColor = Constants.Color.cancelJobDeleteColor
        return [blockAction]
    }

    func tableView(_: UITableView, numberOfRowsInSection section: Int) -> Int {
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
        cell.badgeCountLabel.text = "\(chatList.unreadCount)"
        cell.badgeCountLabel.isHidden = chatList.unreadCount > 0 ? false : true
        let chatDate = Date.getDateMMDDYYYY(date: dateFormatter.date(from: dateFormatter.string(from: chatList.date as! Date))!)
        cell.dateLabel.text = ""
        if todaysDate == chatDate {
            cell.dateLabel.text = "Today"
        } else if (todaysDate - 86400) == chatDate {
            cell.dateLabel.text = "Yesterday"
        } else {
            cell.dateLabel.text = Date.getDateDashedMMDDYYYY(date: chatDate)
        }

        return cell
    }

    func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        let chatList = fetchedResultsController.object(at: indexPath) as! ChatList
        let chatVC = UIStoryboard.messagesStoryBoard().instantiateViewController(type: DMChatVC.self)!
        chatVC.chatList = chatList
        chatVC.hidesBottomBarWhenPushed = true
        chatVC.delegate = self
        if DatabaseManager.getCountForChats(recruiterId: chatList.recruiterId!) == 0 {
            chatVC.shouldFetchFromBeginning = true
        }
        navigationController?.pushViewController(chatVC, animated: true)
    }
}

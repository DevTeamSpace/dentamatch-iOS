//
//  DMChatVC+TableViewExtensions.swift
//  DentaMatch
//
//  Created by Rajan Maheshwari on 06/02/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import Foundation

extension DMChatVC:UITableViewDataSource,UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let chat = fetchedResultsController.object(at: indexPath) as! Chat
        if let message = chat.message {
            return MessageSenderTableCell.calculateHeight(text: message)
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = fetchedResultsController.sections {
            let sectionInfo = sections[section]
            return sectionInfo.numberOfObjects
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let chat = fetchedResultsController.object(at: indexPath) as! Chat
        if let _ = UserManager.shared().activeUser {
            if chat.fromId == UserManager.shared().activeUser.userId {
                //self message
                let cell = tableView.dequeueReusableCell(withIdentifier: "MessageSenderTableCell") as! MessageSenderTableCell
                cell.chatTextView.text = chat.message
                //self.setContent(textView: cell.chatTextView)
                return cell
                
            } else {
                //recruiter message
                let cell = tableView.dequeueReusableCell(withIdentifier: "MessageReceiverTableCell") as! MessageReceiverTableCell
                cell.chatTextView.text = chat.message
                return cell
            }
        } else {
            return UITableViewCell()
        }
    }
}

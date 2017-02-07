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
        return 81
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let blockAction = UITableViewRowAction(style: .normal, title: "Block", handler: { (action:UITableViewRowAction, indexPath:IndexPath) in
            self.messageListTableView.setEditing(false, animated: true)
            DispatchQueue.main.async {
                self.showBlockRecruiterAlert()
            }
        })
        blockAction.backgroundColor = Constants.Color.cancelJobDeleteColor
        return [blockAction]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessageListTableCell") as! MessageListTableCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let chatVC = UIStoryboard.messagesStoryBoard().instantiateViewController(type: DMChatVC.self)!
        chatVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(chatVC, animated: true)
    }
}

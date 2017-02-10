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
        return MessageSenderTableCell.requiredHeight(message: messages[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessageSenderTableCell") as! MessageSenderTableCell
        return cell
    }
}

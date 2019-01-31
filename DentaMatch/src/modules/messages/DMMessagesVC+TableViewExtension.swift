import Foundation

extension DMMessagesVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
        return 75
    }

    func tableView(_: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return !chatListArray[indexPath.row].isBlockedFromSeeker
    }

    func tableView(_: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let chatDeleteAction = UITableViewRowAction(style: .normal, title: "Delete", handler: { [weak self] (_: UITableViewRowAction, indexPath: IndexPath) in
            
            self?.messageListTableView.setEditing(false, animated: true)
            guard let chatList = self?.chatListArray[indexPath.row] else { return }
            
            DispatchQueue.main.async { [weak self] in
                self?.showChatDeleteAlert(chatList: chatList)
            }
        })
        
        chatDeleteAction.backgroundColor = Constants.Color.tickSelectColor
        
        let blockAction = UITableViewRowAction(style: .normal, title: "Block", handler: { [weak self] (_: UITableViewRowAction, indexPath: IndexPath) in
            
            self?.messageListTableView.setEditing(false, animated: true)
            guard let chatList = self?.chatListArray[indexPath.row] else { return }
            
            DispatchQueue.main.async { [weak self] in
                self?.showBlockRecruiterAlert(chatList: chatList)
            }
        })
        
        blockAction.backgroundColor = Constants.Color.cancelJobDeleteColor
        return [chatDeleteAction, blockAction]
    }

    func tableView(_: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatListArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessageListTableCell") as! MessageListTableCell
        let chatList = chatListArray[indexPath.row]
        
        cell.recruiterNameLabel.text = chatList.officeName
        cell.lastMessageLabel.text = chatList.lastMessage
        cell.badgeCountLabel.text = "\(chatList.unreadCount)"
        cell.badgeCountLabel.isHidden = chatList.unreadCount > 0 ? false : true
        cell.dateLabel.text = ""
        
        if let date = chatList.date, let dateAfterFormat =  dateFormatter.date(from: dateFormatter.string(from: date)) {
            
            let chatDate = Date.getDateMMDDYYYY(date:dateAfterFormat)
            
            if todaysDate == chatDate {
                cell.dateLabel.text = "Today"
            } else if (todaysDate - 86400) == chatDate {
                cell.dateLabel.text = "Yesterday"
            } else {
                cell.dateLabel.text = Date.getDateDashedMMDDYYYY(date: chatDate)
            }
        }
        return cell
    }

    func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let chatList = chatListArray[indexPath.row]
        
        moduleOutput?.showChat(chatList: chatList,
                               fetchFromBegin: DatabaseManager.getCountForChats(recruiterId: chatList.recruiterId) == 0,
                               delegate: self)
    }
}

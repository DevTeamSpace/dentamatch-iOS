import Foundation

extension DMChatVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return MessageSenderTableCell.calculateHeight(text: chatsArray[indexPath.section][indexPath.row].message)
    }

    func tableView(_: UITableView, numberOfRowsInSection section: Int) -> Int {
        if printData == true {
            
            for section in chatsArray {
                LogManager.logDebug(section.first?.dateString)
                LogManager.logDebug(section.count.description)
            }
            
            printData = false
        }
        
        return chatsArray[section].count
    }

    func numberOfSections(in _: UITableView) -> Int {
        return chatsArray.count
    }

    func tableView(_: UITableView, heightForHeaderInSection _: Int) -> CGFloat {
        return 40
    }

    func tableView(_: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let dateString = chatsArray[section].first?.dateString else { return nil }
        
        let sectionView = UIView(frame: CGRect(x: 0, y: 0, width: Utilities.ScreenSize.SCREEN_WIDTH, height: 40))
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 30))
        label.font = UIFont.fontRegular(fontSize: 13.0)
        label.textColor = UIColor.color(withHexCode: "8e9091")
        label.textAlignment = .center
        label.text = dateString
        label.center = sectionView.center
        sectionView.addSubview(label)
        return sectionView
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let chat = chatsArray[indexPath.section][indexPath.row]
        
        if let _ = UserManager.shared().activeUser {
            if chat.fromId == UserManager.shared().activeUser.userId {
                let cell = tableView.dequeueReusableCell(withIdentifier: "MessageSenderTableCell") as! MessageSenderTableCell
                cell.chatTextView.text = chat.message
                cell.timeLabel.text = chat.timeString
                return cell

            } else {
                // recruiter message
                let cell = tableView.dequeueReusableCell(withIdentifier: "MessageReceiverTableCell") as! MessageReceiverTableCell
                cell.chatTextView.text = chat.message
                cell.timeLabel.text = chat.timeString
                return cell
            }
        } else {
            return UITableViewCell()
        }
    }
}

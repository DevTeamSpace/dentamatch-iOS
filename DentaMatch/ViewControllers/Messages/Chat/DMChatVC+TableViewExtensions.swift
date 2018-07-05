//
//  DMChatVC+TableViewExtensions.swift
//  DentaMatch
//
//  Created by Rajan Maheshwari on 06/02/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import Foundation

extension DMChatVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let chat = fetchedResultsController.object(at: indexPath) as! Chat
        if let message = chat.message {
            return MessageSenderTableCell.calculateHeight(text: message)
        } else {
            return 0
        }
    }

    func tableView(_: UITableView, numberOfRowsInSection section: Int) -> Int {
        if printData == true {
            if let sections = fetchedResultsController.sections {
                let sectionInfo = sections[section]
                for i in 0 ..< sections.count {
                    let sectionInfo = sections[i]
                    print(sectionInfo.name)
                    print(sectionInfo.numberOfObjects)
                }

                printData = false
            }
        }
        if let sections = fetchedResultsController.sections {
            let sectionInfo = sections[section]
            return sectionInfo.numberOfObjects
        }
        return 0
    }

    func numberOfSections(in _: UITableView) -> Int {
        if fetchedResultsController != nil {
            if let sections = fetchedResultsController.sections {
                return sections.count
            }
            return 0
        }
        return 0
    }

    func tableView(_: UITableView, heightForHeaderInSection _: Int) -> CGFloat {
        return 40
    }

    func tableView(_: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let sections = fetchedResultsController.sections {
            let section = sections[section]
            let sectionView = UIView(frame: CGRect(x: 0, y: 0, width: Utilities.ScreenSize.SCREEN_WIDTH, height: 40))
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 30))
            label.font = UIFont.fontRegular(fontSize: 13.0)
            label.textColor = UIColor.color(withHexCode: "8e9091")
            label.textAlignment = .center
            label.text = section.name
            label.center = sectionView.center
            sectionView.addSubview(label)
            return sectionView
        }
        return nil
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let chat = fetchedResultsController.object(at: indexPath) as! Chat
        if let _ = UserManager.shared().activeUser {
            if chat.fromId == UserManager.shared().activeUser.userId {
                // self message
                let cell = tableView.dequeueReusableCell(withIdentifier: "MessageSenderTableCell") as! MessageSenderTableCell
                cell.chatTextView.text = chat.message
//                cell.chatTextView.text = chat.message!.converttoASCIIString()
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

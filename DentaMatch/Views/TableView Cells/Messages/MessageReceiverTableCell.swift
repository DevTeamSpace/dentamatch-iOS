//
//  MessageReceiverTableCell.swift
//  DentaMatch
//
//  Created by Rajan Maheshwari on 06/02/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

class MessageReceiverTableCell: UITableViewCell {
    @IBOutlet var chatTextView: UITextView!
    @IBOutlet var timeLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        chatTextView.layer.cornerRadius = 5.0
        chatTextView.textContainerInset = UIEdgeInsets(top: 9, left: 8, bottom: 8, right: 8)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

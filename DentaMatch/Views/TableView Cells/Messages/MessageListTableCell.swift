//
//  MessageListTableCell.swift
//  DentaMatch
//
//  Created by Rajan Maheshwari on 07/02/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

class MessageListTableCell: UITableViewCell {
    @IBOutlet var recruiterNameLabel: UILabel!

    @IBOutlet var badgeCountLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var lastMessageLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        badgeCountLabel.layer.cornerRadius = 11.0
        badgeCountLabel.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

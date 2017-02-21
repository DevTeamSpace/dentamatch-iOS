//
//  MessageListTableCell.swift
//  DentaMatch
//
//  Created by Rajan Maheshwari on 07/02/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

class MessageListTableCell: UITableViewCell {
    @IBOutlet weak var recruiterNameLabel: UILabel!

    @IBOutlet weak var badgeCountLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var lastMessageLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.badgeCountLabel.layer.cornerRadius = 11.0
        self.badgeCountLabel.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

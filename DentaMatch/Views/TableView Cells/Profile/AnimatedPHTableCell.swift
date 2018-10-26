//
//  AnimatedPHTableCell.swift
//  DentaMatch
//
//  Created by Sanjay Kumar Yadav on 30/12/16.
//  Copyright © 2016 Appster. All rights reserved.
//

import UIKit

class AnimatedPHTableCell: UITableViewCell {
    @IBOutlet weak var commonTextField: AnimatedPHTextField!
    @IBOutlet weak var cellTopSpace: NSLayoutConstraint!
    @IBOutlet weak var cellBottomSpace: NSLayoutConstraint!

    @IBOutlet weak var accessoryLabel: UILabel!
    @IBOutlet weak var toolTipLabel: UILabel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

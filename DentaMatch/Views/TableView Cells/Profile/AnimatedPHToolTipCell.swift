//
//  AnimatedPHToolTipCell.swift
//  DentaMatch
//
//  Created by Prashant Gautam on 26/10/18.
//  Copyright © 2018 Appster. All rights reserved.
//

import UIKit

class AnimatedPHToolTipCell: UITableViewCell {
    @IBOutlet weak var commonTextField: AnimatedPHTextField!
    @IBOutlet weak var accessoryLabel: UILabel!
    @IBOutlet weak var toolTipLabel: UILabel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}

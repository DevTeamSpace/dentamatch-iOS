//
//  JobTitleCell.swift
//  DentaMatch
//
//  Created by Shailesh Tyagi on 25/01/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

class JobTitleCell: UITableViewCell {
    @IBOutlet var lblJobTitle: UILabel!

    @IBOutlet var btnTick: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        btnTick.isUserInteractionEnabled = false
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}

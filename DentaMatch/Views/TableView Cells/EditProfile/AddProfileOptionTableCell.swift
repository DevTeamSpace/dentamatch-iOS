//
//  AddProfileOptionTableCell.swift
//  DentaMatch
//
//  Created by Rajan Maheshwari on 18/01/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

class AddProfileOptionTableCell: UITableViewCell {
    @IBOutlet var profileOptionLabel: UILabel!

    override func awakeFromNib() {
        clipsToBounds = true
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

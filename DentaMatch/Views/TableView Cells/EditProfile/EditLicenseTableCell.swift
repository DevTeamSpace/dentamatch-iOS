//
//  EditLicenseTableCell.swift
//  DentaMatch
//
//  Created by Rajan Maheshwari on 18/01/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

class EditLicenseTableCell: UITableViewCell {
    @IBOutlet var stateLabel: UILabel!
    @IBOutlet var licenceNumberLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        clipsToBounds = true
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

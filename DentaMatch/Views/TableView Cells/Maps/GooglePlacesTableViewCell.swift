//
//  GooglePlacesTableViewCell.swift
//  DentaMatch
//
//  Created by Rajan Maheshwari on 27/10/16.
//  Copyright © 2016 Appster. All rights reserved.
//

import UIKit

class GooglePlacesTableViewCell: UITableViewCell {
    @IBOutlet var placeLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}

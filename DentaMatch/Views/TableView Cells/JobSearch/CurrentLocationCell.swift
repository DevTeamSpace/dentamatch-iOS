//
//  CurrentLocationCell.swift
//  DentaMatch
//
//  Created by Shailesh Tyagi on 09/01/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

class CurrentLocationCell: UITableViewCell {
    
    @IBOutlet weak var viewCurrentLocation: UIView!
    @IBOutlet weak var lblLocation: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.setUp()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func setUp() {
        viewCurrentLocation.layer.borderColor = Constants.Color.jobSearchTitleLocationColor.cgColor
        viewCurrentLocation.layer.borderWidth = 1.0
    }
}

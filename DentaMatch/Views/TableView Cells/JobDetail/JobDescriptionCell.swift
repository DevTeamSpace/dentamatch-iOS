//
//  JobDescriptionCell.swift
//  DentaMatch
//
//  Created by Shailesh Tyagi on 19/01/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

class JobDescriptionCell: UITableViewCell {
    
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var btnReadMore: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func actionReadMore(_ sender: UIButton) {
    }
    
    
}

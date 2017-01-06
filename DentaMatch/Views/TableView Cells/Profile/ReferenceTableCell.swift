//
//  ReferenceTableCell.swift
//  DentaMatch
//
//  Created by Sanjay Kumar Yadav on 03/01/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

class ReferenceTableCell: UITableViewCell {
    @IBOutlet weak var referenceNameLabel: AnimatedPHTextField!
    @IBOutlet weak var referenceMobileNoLabel: AnimatedPHTextField!
    @IBOutlet weak var referenceEmailLabel: AnimatedPHTextField!
    
    @IBOutlet weak var referenceButtonFirst: UIButton!
    @IBOutlet weak var referenceButtonSecond: UIButton!
    @IBOutlet weak var referenceLabel: UILabel!
    @IBOutlet weak var addMoreButtonTopSpace: NSLayoutConstraint!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

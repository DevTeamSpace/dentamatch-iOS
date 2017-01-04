//
//  PhotoCell.swift
//  DentaMatch
//
//  Created by Sanjay Kumar Yadav on 02/01/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

class PhotoCell: UITableViewCell {

    @IBOutlet var stateBoardPhotoButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.stateBoardPhotoButton.layer.cornerRadius = self.stateBoardPhotoButton.bounds.size.height/2
        self.stateBoardPhotoButton.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
}

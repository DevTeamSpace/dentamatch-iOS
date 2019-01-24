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
        clipsToBounds = true
        stateBoardPhotoButton.layer.cornerRadius = stateBoardPhotoButton.bounds.size.height / 2
        stateBoardPhotoButton.clipsToBounds = true
        stateBoardPhotoButton.imageView?.contentMode = .scaleAspectFill
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}

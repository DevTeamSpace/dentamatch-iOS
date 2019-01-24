//
//  CertificationsCell.swift
//  DentaMatch
//
//  Created by Rajan Maheshwari on 10/01/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

class CertificationsCell: UITableViewCell {
    @IBOutlet var photoButton: UIButton!
    @IBOutlet var validityDateTextField: PickerAnimatedTextField!
    @IBOutlet var uploadPhotoButton: UIButton!
    @IBOutlet var headingLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        photoButton.layer.cornerRadius = photoButton.frame.size.width / 2
        photoButton.clipsToBounds = true
        photoButton.imageView?.contentMode = .scaleAspectFill
        validityDateTextField.tintColor = UIColor.clear
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

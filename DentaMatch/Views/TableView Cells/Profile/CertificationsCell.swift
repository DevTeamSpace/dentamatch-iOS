//
//  CertificationsCell.swift
//  DentaMatch
//
//  Created by Rajan Maheshwari on 10/01/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

class CertificationsCell: UITableViewCell {

    @IBOutlet weak var photoButton: UIButton!
    @IBOutlet weak var validityDateTextField: PickerTextField!
    @IBOutlet weak var uploadPhotoButton: UIButton!
    @IBOutlet weak var headingLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.photoButton.layer.cornerRadius = self.photoButton.frame.size.width/2
        self.photoButton.clipsToBounds = true
        self.validityDateTextField.tintColor = UIColor.clear
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

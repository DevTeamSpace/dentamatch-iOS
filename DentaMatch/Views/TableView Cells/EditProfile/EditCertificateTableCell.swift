//
//  EditCertificateTableCell.swift
//  DentaMatch
//
//  Created by Rajan Maheshwari on 20/01/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

class EditCertificateTableCell: UITableViewCell {
    @IBOutlet weak var certificateHeadingLabel: UILabel!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var validityDateAttributedLabel: UILabel!
    @IBOutlet weak var certificateNameLabel: UILabel!
    @IBOutlet weak var certificateImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.clipsToBounds = true
        self.certificateImageView.layer.cornerRadius = self.certificateImageView.frame.size.width/2
        self.certificateImageView.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func createValidityDateAttributedText(date:String) -> NSMutableAttributedString {
        let attributedString = NSMutableAttributedString()
        let validityDateText = NSAttributedString(string: "Validity date ", attributes: [NSFontAttributeName:UIFont.fontRegular(fontSize: 14.0)!,NSForegroundColorAttributeName:Constants.Color.textFieldTextColor])
        let dateString = NSAttributedString(string: date, attributes: [NSFontAttributeName:UIFont.fontSemiBold(fontSize: 14.0)!,NSForegroundColorAttributeName:Constants.Color.textFieldTextColor])
        attributedString.append(validityDateText)
        attributedString.append(dateString)
        return attributedString
    }
    
}

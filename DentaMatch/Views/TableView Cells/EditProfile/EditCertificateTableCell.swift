//
//  EditCertificateTableCell.swift
//  DentaMatch
//
//  Created by Rajan Maheshwari on 20/01/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

class EditCertificateTableCell: UITableViewCell {
    @IBOutlet var certificateHeadingLabel: UILabel!
    @IBOutlet var editButton: UIButton!
    @IBOutlet var validityDateAttributedLabel: UILabel!
    @IBOutlet var certificateNameLabel: UILabel!
    @IBOutlet var certificateImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        clipsToBounds = true
        certificateImageView.layer.cornerRadius = certificateImageView.frame.size.width / 2
        certificateImageView.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func createValidityDateAttributedText(date: String) -> NSMutableAttributedString {
        let attributedString = NSMutableAttributedString()
        let validityDateText = NSAttributedString(string: "Validity date ", attributes: [NSAttributedString.Key.font: UIFont.fontRegular(fontSize: 14.0), NSAttributedString.Key.foregroundColor: Constants.Color.textFieldTextColor])
        let convertedDate = getCertificateDateFormat(dateString: date)
        let dateString = NSAttributedString(string: convertedDate, attributes: [NSAttributedString.Key.font: UIFont.fontSemiBold(fontSize: 14.0), NSAttributedString.Key.foregroundColor: Constants.Color.textFieldTextColor])
        attributedString.append(validityDateText)
        attributedString.append(dateString)
        return attributedString
    }

    func getCertificateDateFormat(dateString: String) -> String {
        if !dateString.isEmptyField && dateString != Constants.kEmptyDate {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = Date.dateFormatYYYYMMDDDashed()
            let date = dateFormatter.date(from: dateString)
            dateFormatter.dateFormat = Date.dateFormatDDMMMMYYYY()
            return dateFormatter.string(from: date!)
        }
        return ""
    }
}

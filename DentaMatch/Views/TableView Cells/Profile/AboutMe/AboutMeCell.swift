//
//  AboutMeCell.swift
//  DentaMatch
//
//  Created by Rajan Maheshwari on 10/01/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

class AboutMeCell: UITableViewCell {
    @IBOutlet var aboutMeTextView: UITextView!

    var placeHolderLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        aboutMeTextView.layer.cornerRadius = 5.0
        aboutMeTextView.layer.borderWidth = 1.0
        aboutMeTextView.layer.borderColor = Constants.Color.textFieldBorderColor.cgColor
        aboutMeTextView.textContainer.lineFragmentPadding = 12.0
        addPlaceHolderLabel()
    }

    func addPlaceHolderLabel() {
        placeHolderLabel = UILabel(frame: CGRect(x: 10, y: 10, width: 200, height: 20))
        placeHolderLabel.font = UIFont.fontRegular(fontSize: 16.0)
        placeHolderLabel.textColor = UIColor.color(withHexCode: "939393")
        placeHolderLabel.text = "Write a brief introduction"
        aboutMeTextView.addSubview(placeHolderLabel)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

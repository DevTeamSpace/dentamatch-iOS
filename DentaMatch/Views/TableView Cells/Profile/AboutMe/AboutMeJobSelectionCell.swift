//
//  AboutMeJobSelectionCell.swift
//  DentaMatch
//
//  Created by Rajan Maheshwari on 06/11/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

class AboutMeJobSelectionCell: UITableViewCell {
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
//        self.titleFont = UIFont.fontRegular(fontSize: 12.0)!
//        self.titleActiveTextColour = Constants.Color.textFieldPlaceHolderColor
//        self.titleTextColour = Constants.Color.textFieldPlaceHolderColor

        placeHolderLabel = UILabel(frame: CGRect(x: 10, y: 10, width: 280, height: 20))
        placeHolderLabel.font = UIFont.fontRegular(fontSize: 14.0)

        placeHolderLabel.textColor = UIColor(red: CGFloat(170.0) / 255.0, green: CGFloat(170.0) / 255.0, blue: CGFloat(170.0) / 255.0, alpha: 0.7)
        placeHolderLabel.text = "Write a brief introduction about yourself"
        aboutMeTextView.addSubview(placeHolderLabel)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

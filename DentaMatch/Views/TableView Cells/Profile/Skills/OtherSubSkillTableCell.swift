//
//  OtherSubSkillTableCell.swift
//  DentaMatch
//
//  Created by Rajan Maheshwari on 18/01/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

class OtherSubSkillTableCell: UITableViewCell {

    @IBOutlet weak var tickButton: UIButton!
    @IBOutlet weak var otherTextView: UITextView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.backgroundColor = UIColor.color(withHexCode: "0470C0")
        self.contentView.backgroundColor = UIColor.color(withHexCode: "0470C0")

        self.clipsToBounds = true
        
        self.otherTextView.layer.cornerRadius = 5.0
        self.otherTextView.layer.borderWidth = 1.0
        self.otherTextView.layer.borderColor = UIColor.white.cgColor
        self.otherTextView.textContainer.lineFragmentPadding = 12.0
        self.otherTextView.backgroundColor = UIColor.color(withHexCode: "0470C0")
//        UITextView.appearance().tintColor = UIColor.white
        self.otherTextView.tintColor = UIColor.white
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

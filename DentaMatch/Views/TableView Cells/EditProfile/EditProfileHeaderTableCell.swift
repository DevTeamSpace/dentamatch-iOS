//
//  EditProfileHeaderTableCell.swift
//  DentaMatch
//
//  Created by Rajan Maheshwari on 17/01/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

class EditProfileHeaderTableCell: UITableViewCell {
    @IBOutlet weak var settingButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var placeLabel: UILabel!

    @IBOutlet weak var aboutTextView: UITextView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profileButton: ProfileImageButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        //self.aboutTextView.textContainer.lineFragmentPadding = 20.0
        self.clipsToBounds = true
        self.placeLabel.numberOfLines = 3
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func fillPlaceAndJobTitle(jobTitle:String,place:String) -> NSMutableAttributedString {
        
        if jobTitle.isEmptyField {
            let attributedString = NSMutableAttributedString()
            let placeText = NSAttributedString(string: place, attributes: [NSAttributedStringKey.font:UIFont.fontRegular(fontSize: 16.0)!,NSAttributedStringKey.foregroundColor:UIColor.white])
            attributedString.append(placeText)
            return attributedString
        } else {
            let attributedString = NSMutableAttributedString()
            let jobTitleText = NSAttributedString(string: jobTitle, attributes: [NSAttributedStringKey.font:UIFont.fontSemiBold(fontSize: 16.0)!,NSAttributedStringKey.foregroundColor:UIColor.white])
            let placeText = NSAttributedString(string: place, attributes: [NSAttributedStringKey.font:UIFont.fontRegular(fontSize: 16.0)!,NSAttributedStringKey.foregroundColor:UIColor.white])
            attributedString.append(jobTitleText)
            attributedString.append(NSAttributedString(string: "\n"))
            attributedString.append(placeText)
            return attributedString
        }
        
    }
    
    class func calculateHeight(text:String) -> CGFloat {
        let textView = UITextView()
        textView.font = UIFont.fontRegular(fontSize: 16.0)!
        var newFrame:CGRect!
        textView.text = text
        
        let fixedWidth = UIScreen.main.bounds.width - 40
        textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        let newSize = textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        newFrame = textView.frame
        newFrame.size = CGSize(width: max(newSize.width, fixedWidth), height: newSize.height)

        debugPrint("height \(newFrame.height)")
        if newFrame.height + 10 > 109 {
            return 109
        } else {
            return newFrame.height + 10
        }
    }
}

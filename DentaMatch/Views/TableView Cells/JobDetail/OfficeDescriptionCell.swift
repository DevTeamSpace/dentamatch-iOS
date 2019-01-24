//
//  OfficeDescriptionCell.swift
//  DentaMatch
//
//  Created by Shailesh Tyagi on 19/01/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

@objc protocol OfficeDescriptionCellDelegate {
    @objc optional func readMoreOrReadOfficeDescription()
}

class OfficeDescriptionCell: UITableViewCell {
    @IBOutlet var heightConstraintReadMoreButton: NSLayoutConstraint!
    @IBOutlet var officeDescriptionLabel: UILabel!

    @IBOutlet var readMoreButton: UIButton!
    var isReadMore = false

    var textHeight: CGFloat!
    weak var delegate: OfficeDescriptionCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

    @IBAction func readMoreButtonClicked(_: Any) {
        delegate?.readMoreOrReadOfficeDescription!()
    }

    func setCellData(job _: Job) {
        // Filling cell data
    }

    class func requiredHeight(jobDescription: String, isReadMore: Bool) -> CGFloat {
        let font = UIFont.fontLight(fontSize: 13.0)
        var label: UILabel!
        label = UILabel(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - 40, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = jobDescription
        label.sizeToFit()
        if label.frame.height > 50 {
            if isReadMore == false {
                return 50 + 22 + 41
            } else {
                return label.frame.height + 22 + 41
            } // Button Show
        } else {
            return label.frame.height + 22 // Button Hide
        }
    }
}

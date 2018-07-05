//
//  JobDescriptionCell.swift
//  DentaMatch
//
//  Created by Shailesh Tyagi on 19/01/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

@objc protocol JobDescriptionCellDelegate {
    @objc optional func readMoreOrReadLess()
}

class JobDescriptionCell: UITableViewCell {
    @IBOutlet var lblDescription: UILabel!
    @IBOutlet var btnReadMore: UIButton!
    @IBOutlet var constraintDescHeight: NSLayoutConstraint!
    @IBOutlet var constarintBtnReadMoreLessHeight: NSLayoutConstraint!
    var isReadMore: Bool! = false
    var textHeight: CGFloat!
    weak var delegate: JobDescriptionCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

    @IBAction func actionReadMore(_: UIButton) {
        delegate?.readMoreOrReadLess!()
    }

//    class func requiredHeight(jobDescription:String,isReadMore:Bool) -> CGFloat{
//        let font = UIFont.fontLight(fontSize: 13.0)
//        var label:UILabel!
//
//        if isReadMore {
//            label = UILabel(frame: CGRect(x:0, y:0, width:UIScreen.main.bounds.width - 42, height:CGFloat.greatestFiniteMagnitude))
//        } else {
//            label = UILabel(frame: CGRect(x:0, y:0, width:UIScreen.main.bounds.width - 42, height:80))
//        }
//        label.numberOfLines = 0
//        label.lineBreakMode = NSLineBreakMode.byWordWrapping
//        label.font = font
//        label.text = jobDescription
//        if isReadMore {
//            label.sizeToFit()
//        } else {
//
//        }
//        return label.frame.height + 22 + 41
//    }

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

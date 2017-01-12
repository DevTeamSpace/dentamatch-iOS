//
//  JobSeachTitleCell.swift
//  DentaMatch
//
//  Created by Shailesh Tyagi on 09/01/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

class JobSeachTitleCell: UITableViewCell {

    @IBOutlet weak var lblJobTitle: UILabel!
    @IBOutlet weak var scrollViewJobTitle: UIScrollView!
    @IBOutlet weak var viewJobSearchTitle: UIView!
    @IBOutlet weak var constraintScrollViewHeight: NSLayoutConstraint!
    @IBOutlet weak var constraintScrollViewTop: NSLayoutConstraint!
    @IBOutlet weak var constraintScrollViewBottom: NSLayoutConstraint!
    
    var jobTitles = [JobTitle]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.setUp()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func setUp() {
        viewJobSearchTitle.layer.borderColor = UIColor.init(colorLiteralRed: 229.0/255.0, green: 229.0/255.0, blue: 229.0/255.0, alpha: 1.0).cgColor
        viewJobSearchTitle.layer.borderWidth = 1.0
    }
    
    func updateJobTitle(){
        
        self.scrollViewJobTitle.subviews.forEach ({
            if $0 is UILabel {
                $0.removeFromSuperview()
            }
        })
        
        var topMargin : CGFloat = 0.0
        var leftMargin : CGFloat = 5.0
        let rightMargin : CGFloat = 0.0
        var totalHeight : CGFloat = 5.0
        let widthPadding : CGFloat = 10.0
        let heightPadding : CGFloat = 23.0
        
        if jobTitles.count == 0 {
            constraintScrollViewHeight.constant = 24.0
            self.layoutIfNeeded()
            return
        }
        
        for objTitle in jobTitles {
            let font = UIFont.fontRegular(fontSize: 14.0)
            let textAttributes = [NSFontAttributeName: font]
            let textSize = objTitle.jobTitle.boundingRect(with: CGSize(width : self.frame.size.width + 10,height : 14), options: .usesLineFragmentOrigin, attributes: textAttributes, context: nil)
            let textWidth : CGFloat = textSize.width
            let textHeight : CGFloat = 34.0
            if leftMargin + textSize.width + rightMargin + widthPadding >= self.scrollViewJobTitle.frame.size.width{
                leftMargin = 5.0
                topMargin =  topMargin + textSize.height + heightPadding + 5.0
                //widthPadding = 20.0
                //textWidth = self.scrollViewJobTitle.frame.size.width - 20
                //textHeight = 64.0
            }
            
            let label = UILabel(frame: CGRect(x : leftMargin,y : topMargin,width : textWidth + widthPadding + 15,height :  textHeight))
            label.textAlignment = NSTextAlignment.center
            label.font = font
            label.textColor = UIColor(red: 169.0/255.0, green: 169.0/255.0, blue: 169.0/255.0, alpha: 1.0)
            label.text = objTitle.jobTitle as String
            label.layer.borderWidth  = 1
            //label.numberOfLines = 0
            label.layer.borderColor = UIColor(red: 169.0/255.0, green: 169.0/255.0, blue: 169.0/255.0, alpha: 1.0).cgColor
            label.layer.cornerRadius = 15.0
            label.clipsToBounds = true
            self.scrollViewJobTitle.addSubview(label)
            
            leftMargin = leftMargin + textWidth + widthPadding + 25
            totalHeight =  topMargin + textSize.height + heightPadding
        }
        
        self.scrollViewJobTitle.contentSize = CGSize(width : self.scrollViewJobTitle.frame.size.width,height : totalHeight)
        
        // Set scrollview height equals to Total Height
        
        constraintScrollViewHeight.constant = totalHeight
        //self.layoutIfNeeded()
    }
    
}

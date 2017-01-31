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
        viewJobSearchTitle.layer.borderColor = Constants.Color.jobSearchBorderColor.cgColor
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
            constraintScrollViewHeight.constant = 4.0
            self.layoutIfNeeded()
            return
        }
        
        for objTitle in jobTitles {
            let font = UIFont.fontRegular(fontSize: 14.0)
            let textAttributes = [NSFontAttributeName: font]
            let textSize = objTitle.jobTitle.boundingRect(with: CGSize(width : self.frame.size.width + 10,height : 14), options: .usesLineFragmentOrigin, attributes: textAttributes, context: nil)
            var textWidth : CGFloat = textSize.width
            let textHeight : CGFloat = 34.0
            
            if textSize.width >= self.scrollViewJobTitle.frame.size.width {
                leftMargin = 5.0
                if topMargin == 0.0 {
                    topMargin = 5.0
                }
                else {
                    topMargin =  topMargin + textSize.height + heightPadding + 5.0
                }
                textWidth = self.scrollViewJobTitle.frame.size.width - leftMargin - rightMargin - 15
            }
            else if leftMargin + textSize.width + rightMargin + widthPadding >= self.scrollViewJobTitle.frame.size.width {
                leftMargin = 5.0
                topMargin =  topMargin + textSize.height + heightPadding + 5.0
            }
            
            let label = UILabel(frame: CGRect(x : leftMargin,y : topMargin,width : textWidth + widthPadding + 15,height :  textHeight))
            label.textAlignment = NSTextAlignment.center
            label.font = font
            label.textColor = Constants.Color.jobTitleBricksColor
            label.text = objTitle.jobTitle as String
            label.layer.borderWidth  = 1
            label.layer.borderColor = Constants.Color.jobTitleBricksColor.cgColor
            label.layer.cornerRadius = 15.0
            label.clipsToBounds = true
            self.scrollViewJobTitle.addSubview(label)
            
            leftMargin = leftMargin + textWidth + widthPadding + 25
            totalHeight =  topMargin + textSize.height + heightPadding
        }
        
        self.scrollViewJobTitle.contentSize = CGSize(width : self.scrollViewJobTitle.frame.size.width,height : totalHeight)
        
        // Set scrollview height equals to Total Height
        
        constraintScrollViewHeight.constant = totalHeight
    }
    
}

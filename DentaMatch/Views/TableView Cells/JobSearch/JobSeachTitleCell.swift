//
//  JobSeachTitleCell.swift
//  DentaMatch
//
//  Created by Shailesh Tyagi on 09/01/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

class JobSeachTitleCell: UITableViewCell {
    @IBOutlet var lblJobTitle: UILabel!
    @IBOutlet var scrollViewJobTitle: UIScrollView!
    @IBOutlet var viewJobSearchTitle: UIView!
    @IBOutlet var constraintScrollViewHeight: NSLayoutConstraint!

    var jobTitles = [JobTitle]()
    var preferredLocations = [PreferredLocation]()
    var forPreferredLocation = false

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setUp()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

    func setUp() {
        viewJobSearchTitle.layer.borderColor = Constants.Color.jobSearchBorderColor.cgColor
        viewJobSearchTitle.layer.borderWidth = 1.0
    }

    func updateJobTitle() {
        scrollViewJobTitle.subviews.forEach({
            if $0 is UILabel {
                $0.removeFromSuperview()
            }
        })

        var topMargin: CGFloat = 0.0
        var leftMargin: CGFloat = 5.0
        let rightMargin: CGFloat = 0.0
        var totalHeight: CGFloat = 5.0
        let widthPadding: CGFloat = 10.0
        let heightPadding: CGFloat = 23.0

        if forPreferredLocation {
            if preferredLocations.count == 0 {
                constraintScrollViewHeight.constant = 4.0
                return
            }
        } else {
            if jobTitles.count == 0 {
                constraintScrollViewHeight.constant = 4.0
                return
            }
        }

        if forPreferredLocation {
            for objTitle in preferredLocations {
                let font = UIFont.fontRegular(fontSize: 14.0)
                let textAttributes = [NSAttributedStringKey.font: font]
                let textSize = objTitle.preferredLocationName.boundingRect(with: CGSize(width: UIScreen.main.bounds.size.width + 10, height: 14), options: .usesLineFragmentOrigin, attributes: textAttributes, context: nil)
                var textWidth: CGFloat = textSize.width
                let textHeight: CGFloat = 34.0

                if textSize.width >= scrollViewJobTitle.frame.size.width {
                    leftMargin = 5.0
                    if topMargin == 0.0 {
                        topMargin = 5.0
                    } else {
                        topMargin = topMargin + textSize.height + heightPadding + 5.0
                    }
                    textWidth = scrollViewJobTitle.frame.size.width - leftMargin - rightMargin - 15
                } else if leftMargin + textSize.width + rightMargin + widthPadding >= (UIScreen.main.bounds.size.width - 20) {
                    leftMargin = 5.0
                    topMargin = topMargin + textSize.height + heightPadding + 5.0
                }

                let label = UILabel(frame: CGRect(x: leftMargin, y: topMargin, width: textWidth + widthPadding + 15, height: textHeight))
                label.textAlignment = NSTextAlignment.center
                label.font = font
                label.textColor = Constants.Color.jobTitleBricksColor
                label.text = objTitle.preferredLocationName as String
                label.layer.borderWidth = 1
                label.layer.borderColor = Constants.Color.jobTitleBricksColor.cgColor
                label.layer.cornerRadius = 5.0
                label.clipsToBounds = true
                scrollViewJobTitle.addSubview(label)

                leftMargin = leftMargin + textWidth + widthPadding + 25
                totalHeight = topMargin + textSize.height + heightPadding
            }
        } else {
            for objTitle in jobTitles {
                let font = UIFont.fontRegular(fontSize: 14.0)
                let textAttributes = [NSAttributedStringKey.font: font]
                let textSize = objTitle.jobTitle.boundingRect(with: CGSize(width: UIScreen.main.bounds.size.width + 10, height: 14), options: .usesLineFragmentOrigin, attributes: textAttributes, context: nil)
                var textWidth: CGFloat = textSize.width
                let textHeight: CGFloat = 34.0

                if textSize.width >= scrollViewJobTitle.frame.size.width {
                    leftMargin = 5.0
                    if topMargin == 0.0 {
                        topMargin = 5.0
                    } else {
                        topMargin = topMargin + textSize.height + heightPadding + 5.0
                    }
                    textWidth = scrollViewJobTitle.frame.size.width - leftMargin - rightMargin - 15
                } else if leftMargin + textSize.width + rightMargin + widthPadding >= (UIScreen.main.bounds.size.width - 20) {
                    leftMargin = 5.0
                    topMargin = topMargin + textSize.height + heightPadding + 5.0
                }

                let label = UILabel(frame: CGRect(x: leftMargin, y: topMargin, width: textWidth + widthPadding + 15, height: textHeight))
                label.textAlignment = NSTextAlignment.center
                label.font = font
                label.textColor = Constants.Color.jobTitleBricksColor
                label.text = objTitle.jobTitle as String
                label.layer.borderWidth = 1
                label.layer.borderColor = Constants.Color.jobTitleBricksColor.cgColor
                label.layer.cornerRadius = 5.0
                label.clipsToBounds = true
                scrollViewJobTitle.addSubview(label)

                leftMargin = leftMargin + textWidth + widthPadding + 25
                totalHeight = topMargin + textSize.height + heightPadding
            }
        }

        scrollViewJobTitle.contentSize = CGSize(width: UIScreen.main.bounds.size.width - 20, height: totalHeight)

        // Set scrollview height equals to Total Height

        constraintScrollViewHeight.constant = totalHeight
    }
}

//
//  WorkingHoursTableCell.swift
//  DentaMatch
//
//  Created by Rajan Maheshwari on 22/03/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

class WorkingHoursTableCell: UITableViewCell {

    @IBOutlet weak var workingHoursLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setAllDayText(job:Job) -> NSMutableAttributedString {
        let allDayTextAttrString = NSMutableAttributedString()
        if !job.workEverydayStart.isEmptyField {
            let allDayText = NSAttributedString(string: "All Days: ", attributes: [NSFontAttributeName:UIFont.fontSemiBold(fontSize: 13.0)!,NSForegroundColorAttributeName:UIColor.color(withHexCode: "272727")])
            allDayTextAttrString.append(allDayText)
            
            allDayDate(job: job)
        }
        return allDayTextAttrString
    }
    
    func allDayDate(job:Job) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        let date = dateFormatter.date(from: job.workEverydayStart)
        dateFormatter.dateFormat = "HH:mm a"
        let st = dateFormatter.string(from: date!)

    }
    
    class func requiredHeight(job:Job) -> CGFloat {
        if !job.workEverydayStart.isEmptyField {
          return 50
        } else {
            let font = UIFont.fontLight(fontSize: 13.0)
            var label:UILabel!
            label = UILabel(frame: CGRect(x:0, y:0, width:UIScreen.main.bounds.width - 42, height:CGFloat.greatestFiniteMagnitude))
            label.numberOfLines = 0
            label.lineBreakMode = NSLineBreakMode.byWordWrapping
            label.font = font
            label.text = ""
            label.sizeToFit()
            return label.frame.height + 22 //Button Hide
        }
    }
    
}

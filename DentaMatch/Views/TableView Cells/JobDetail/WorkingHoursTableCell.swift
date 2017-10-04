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
        workingHoursLabel.numberOfLines = 0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    class func setAllDayText(job:Job) -> NSMutableAttributedString {
        let allDayTextAttrString = NSMutableAttributedString()
        if !job.workEverydayStart.isEmptyField {
            let allDayText = NSAttributedString(string: "All Days: ", attributes: [NSAttributedStringKey.font:UIFont.fontSemiBold(fontSize: 13.0)!,NSAttributedStringKey.foregroundColor:UIColor.color(withHexCode: "272727")])
            allDayTextAttrString.append(allDayText)
            
            let allDayTime = NSAttributedString(string: allDayDate(job: job), attributes: [NSAttributedStringKey.font:UIFont.fontRegular(fontSize: 13.0)!,NSAttributedStringKey.foregroundColor:UIColor.color(withHexCode: "515151")])

            allDayTextAttrString.append(allDayTime)
            
        } else {
            return makeWeekDayText(job: job)
        }
        return allDayTextAttrString

    }
    
    class func allDayDate(job:Job) -> String {
        var allDayTimeString = ""
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        var date = dateFormatter.date(from: job.workEverydayStart)
        dateFormatter.dateFormat = "hh:mm a"
        if let date = date {
            allDayTimeString = dateFormatter.string(from: date)
        }
        allDayTimeString += " - "
        dateFormatter.dateFormat = "HH:mm:ss"
        date = dateFormatter.date(from: job.workEverydayEnd)
        dateFormatter.dateFormat = "hh:mm a"
        if let date = date {
            allDayTimeString = allDayTimeString + dateFormatter.string(from: date)
        }
        return allDayTimeString
    }
    
    class func makeWeekDayText(job:Job) -> NSMutableAttributedString {
        
        let paragraphStyle = NSMutableParagraphStyle.default.mutableCopy() as! NSMutableParagraphStyle
        paragraphStyle.lineSpacing = 12.0
      
        
        var isStarted = false
        let dateFormatter = DateFormatter()
        
        let weekDayAttrString = NSMutableAttributedString()
        
        var weekDayText = NSAttributedString(string: "Sunday: ", attributes: [NSAttributedStringKey.font:UIFont.fontSemiBold(fontSize: 13.0)!,NSAttributedStringKey.foregroundColor:UIColor.color(withHexCode: "272727")])
        
        var timeText = NSAttributedString(string: allDayDate(job: job), attributes: [NSAttributedStringKey.font:UIFont.fontRegular(fontSize: 13.0)!,NSAttributedStringKey.foregroundColor:UIColor.color(withHexCode: "515151")])
        
        
        if !job.sundayStart.isEmptyField {
            isStarted = true
            weekDayAttrString.append(weekDayText)
            
            var time = ""
            dateFormatter.dateFormat = "HH:mm:ss"
            var date = dateFormatter.date(from: job.sundayStart)
            dateFormatter.dateFormat = "hh:mm a"
            if let date = date {
                time = dateFormatter.string(from: date)
            }
            time += " - "
            dateFormatter.dateFormat = "HH:mm:ss"
            date = dateFormatter.date(from: job.sundayEnd)
            dateFormatter.dateFormat = "hh:mm a"
            if let date = date {
                time += dateFormatter.string(from: date)
            }
            timeText = NSAttributedString(string: time, attributes: [NSAttributedStringKey.font:UIFont.fontRegular(fontSize: 13.0)!,NSAttributedStringKey.foregroundColor:UIColor.color(withHexCode: "515151")])
            weekDayAttrString.append(timeText)
        }
        
        if !job.mondayStart.isEmptyField {
            if isStarted {
                weekDayAttrString.append(NSAttributedString(string: "\n"))
            }
            isStarted = true
            weekDayText = NSAttributedString(string: "Monday: ", attributes: [NSAttributedStringKey.font:UIFont.fontSemiBold(fontSize: 13.0)!,NSAttributedStringKey.foregroundColor:UIColor.color(withHexCode: "272727")])
            weekDayAttrString.append(weekDayText)
            var time = ""
            dateFormatter.dateFormat = "HH:mm:ss"
            var date = dateFormatter.date(from: job.mondayStart)
            dateFormatter.dateFormat = "hh:mm a"
            if let date = date {
                time = dateFormatter.string(from: date)
            }
            time += " - "
            dateFormatter.dateFormat = "HH:mm:ss"
            date = dateFormatter.date(from: job.mondayEnd)
            dateFormatter.dateFormat = "hh:mm a"
            if let date = date {
                time += dateFormatter.string(from: date)
            }
            timeText = NSAttributedString(string: time, attributes: [NSAttributedStringKey.font:UIFont.fontRegular(fontSize: 13.0)!,NSAttributedStringKey.foregroundColor:UIColor.color(withHexCode: "515151")])
            weekDayAttrString.append(timeText)

        }
        
        if !job.tuesdayStart.isEmptyField {
            if isStarted {
                weekDayAttrString.append(NSAttributedString(string: "\n"))
            }
            isStarted = true
            weekDayText = NSAttributedString(string: "Tuesday: ", attributes: [NSAttributedStringKey.font:UIFont.fontSemiBold(fontSize: 13.0)!,NSAttributedStringKey.foregroundColor:UIColor.color(withHexCode: "272727")])
            weekDayAttrString.append(weekDayText)
            var time = ""
            dateFormatter.dateFormat = "HH:mm:ss"
            var date = dateFormatter.date(from: job.tuesdayStart)
            dateFormatter.dateFormat = "hh:mm a"
            if let date = date {
                time = dateFormatter.string(from: date)
            }
            time += " - "
            dateFormatter.dateFormat = "HH:mm:ss"
            date = dateFormatter.date(from: job.tuesdayEnd)
            dateFormatter.dateFormat = "hh:mm a"
            if let date = date {
                time += dateFormatter.string(from: date)
            }
            timeText = NSAttributedString(string: time, attributes: [NSAttributedStringKey.font:UIFont.fontRegular(fontSize: 13.0)!,NSAttributedStringKey.foregroundColor:UIColor.color(withHexCode: "515151")])
            weekDayAttrString.append(timeText)

        }
        
        if !job.wednesdayStart.isEmptyField {
            if isStarted {
                weekDayAttrString.append(NSAttributedString(string: "\n"))
            }
            isStarted = true
            weekDayText = NSAttributedString(string: "Wednesday: ", attributes: [NSAttributedStringKey.font:UIFont.fontSemiBold(fontSize: 13.0)!,NSAttributedStringKey.foregroundColor:UIColor.color(withHexCode: "272727")])
            weekDayAttrString.append(weekDayText)
            var time = ""
            dateFormatter.dateFormat = "HH:mm:ss"
            var date = dateFormatter.date(from: job.wednesdayStart)
            dateFormatter.dateFormat = "hh:mm a"
            if let date = date {
                time = dateFormatter.string(from: date)
            }
            time += " - "
            dateFormatter.dateFormat = "HH:mm:ss"
            date = dateFormatter.date(from: job.wednesdayEnd)
            dateFormatter.dateFormat = "hh:mm a"
            if let date = date {
                time += dateFormatter.string(from: date)
            }
            timeText = NSAttributedString(string: time, attributes: [NSAttributedStringKey.font:UIFont.fontRegular(fontSize: 13.0)!,NSAttributedStringKey.foregroundColor:UIColor.color(withHexCode: "515151")])
            weekDayAttrString.append(timeText)


        }
        
        if !job.thursdayStart.isEmptyField {
            if isStarted {
                weekDayAttrString.append(NSAttributedString(string: "\n"))
            }
            isStarted = true
            weekDayText = NSAttributedString(string: "Thursday: ", attributes: [NSAttributedStringKey.font:UIFont.fontSemiBold(fontSize: 13.0)!,NSAttributedStringKey.foregroundColor:UIColor.color(withHexCode: "272727")])
            weekDayAttrString.append(weekDayText)
            var time = ""
            dateFormatter.dateFormat = "HH:mm:ss"
            var date = dateFormatter.date(from: job.thursdayStart)
            dateFormatter.dateFormat = "hh:mm a"
            if let date = date {
                time = dateFormatter.string(from: date)
            }
            time += " - "
            dateFormatter.dateFormat = "HH:mm:ss"
            date = dateFormatter.date(from: job.thursdayEnd)
            dateFormatter.dateFormat = "hh:mm a"
            if let date = date {
                time += dateFormatter.string(from: date)
            }
            timeText = NSAttributedString(string: time, attributes: [NSAttributedStringKey.font:UIFont.fontRegular(fontSize: 13.0)!,NSAttributedStringKey.foregroundColor:UIColor.color(withHexCode: "515151")])
            weekDayAttrString.append(timeText)


        }
        
        if !job.fridayStart.isEmptyField {
            if isStarted {
                weekDayAttrString.append(NSAttributedString(string: "\n"))
            }
            isStarted = true
            weekDayText = NSAttributedString(string: "Friday: ", attributes: [NSAttributedStringKey.font:UIFont.fontSemiBold(fontSize: 13.0)!,NSAttributedStringKey.foregroundColor:UIColor.color(withHexCode: "272727")])
            weekDayAttrString.append(weekDayText)
            var time = ""
            dateFormatter.dateFormat = "HH:mm:ss"
            var date = dateFormatter.date(from: job.fridayStart)
            dateFormatter.dateFormat = "hh:mm a"
            if let date = date {
                time = dateFormatter.string(from: date)
            }
            time += " - "
            dateFormatter.dateFormat = "HH:mm:ss"
            date = dateFormatter.date(from: job.fridayEnd)
            dateFormatter.dateFormat = "hh:mm a"
            if let date = date {
                time += dateFormatter.string(from: date)
            }
            timeText = NSAttributedString(string: time, attributes: [NSAttributedStringKey.font:UIFont.fontRegular(fontSize: 13.0)!,NSAttributedStringKey.foregroundColor:UIColor.color(withHexCode: "515151")])
            weekDayAttrString.append(timeText)


        }
        
        if !job.saturdayStart.isEmptyField {
            if isStarted {
                weekDayAttrString.append(NSAttributedString(string: "\n"))
            }
            isStarted = true
            weekDayText = NSAttributedString(string: "Saturday: ", attributes: [NSAttributedStringKey.font:UIFont.fontSemiBold(fontSize: 13.0)!,NSAttributedStringKey.foregroundColor:UIColor.color(withHexCode: "272727")])
            weekDayAttrString.append(weekDayText)
            var time = ""
            dateFormatter.dateFormat = "HH:mm:ss"
            var date = dateFormatter.date(from: job.saturdayStart)
            dateFormatter.dateFormat = "hh:mm a"
            if let date = date {
                time = dateFormatter.string(from: date)
            }
            time += " - "
            dateFormatter.dateFormat = "HH:mm:ss"
            date = dateFormatter.date(from: job.saturdayEnd)
            dateFormatter.dateFormat = "hh:mm a"
            if let date = date {
                time += dateFormatter.string(from: date)
            }
            timeText = NSAttributedString(string: time, attributes: [NSAttributedStringKey.font:UIFont.fontRegular(fontSize: 13.0)!,NSAttributedStringKey.foregroundColor:UIColor.color(withHexCode: "515151")])
            weekDayAttrString.append(timeText)

        }

        weekDayAttrString.addAttributes([NSAttributedStringKey.paragraphStyle:paragraphStyle], range: NSMakeRange(0, weekDayAttrString.length))

        return weekDayAttrString
    }
    
    class func requiredHeight(job:Job) -> CGFloat {
        if !job.workEverydayStart.isEmptyField {
          return 40
        } else {
            let font = UIFont.fontLight(fontSize: 13.0)
            var label:UILabel!
            label = UILabel(frame: CGRect(x:0, y:0, width:200, height:CGFloat.greatestFiniteMagnitude))
            label.numberOfLines = 0
            label.lineBreakMode = NSLineBreakMode.byWordWrapping
            label.font = font
            label.attributedText = self.makeWeekDayText(job: job)
            label.sizeToFit()
            return label.frame.height + 20
        }
    }
    
}

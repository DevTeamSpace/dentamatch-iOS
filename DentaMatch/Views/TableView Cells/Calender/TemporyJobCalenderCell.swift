//
//  TemporyJobCalenderCell.swift
//  DentaMatch
//
//  Created by Sanjay Kumar Yadav on 26/01/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit
import FSCalendar

class TemporyJobCalenderCell: UITableViewCell {
    @IBOutlet weak var calenderView: FSCalendar!
    @IBOutlet weak var previouseButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    
    var gregorian:NSCalendar?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        gregorian = NSCalendar(calendarIdentifier: .gregorian)
        calenderView.appearance.headerTitleFont = UIFont.fontRegular(fontSize: 12)
        calenderView.appearance.titleFont = UIFont.fontRegular(fontSize: 16)
        calenderView.appearance.weekdayFont = UIFont.fontRegular(fontSize: 16)

        calenderView.appearance.adjustsFontSizeToFitContentSize = true
        calenderView.appearance.adjustTitleIfNecessary()
//        calenderView.appearance.preferredTitleFont = UIFont.fontRegular(fontSize: 16)

        calenderView.appearance.headerTitleColor = UIColor(red: 81.0/255.0, green: 81.0/255.0, blue: 81.0/255.0, alpha: 1)
        calenderView.appearance.weekdayTextColor = UIColor(red: 81.0/255.0, green: 81.0/255.0, blue: 81.0/255.0, alpha: 0.5)
        calenderView.appearance.titleDefaultColor = UIColor(red: 81.0/255.0, green: 81.0/255.0, blue: 81.0/255.0, alpha: 1)

        calenderView.appearance.selectionColor = UIColor(red: 241.0/255.0, green: 184.0/255.0, blue: 90.0/255.0, alpha: 1)


    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
        // Configure the view for the selected state
    }
    @IBAction func previouseButtonClicked(_ sender: Any) {
        let currentMonth:Date = self.calenderView.currentPage
        let previousMonth:Date = (self.gregorian?.date(byAdding: .month, value: -1, to: currentMonth, options: .matchFirst))!
        self.calenderView.setCurrentPage(previousMonth, animated: true)

//        NSDate *currentMonth = self.calendar.currentPage;
//        NSDate *previousMonth = [self.gregorian dateByAddingUnit:NSCalendarUnitMonth value:-1 toDate:currentMonth options:0];
//        [self.calendar setCurrentPage:previousMonth animated:YES];

    }
    @IBAction func nextButtonClicked(_ sender: Any) {
        let currentMonth:Date = self.calenderView.currentPage
        let previousMonth:Date = (self.gregorian?.date(byAdding: .month, value: 1, to: currentMonth, options: .matchFirst))!
        self.calenderView.setCurrentPage(previousMonth, animated: true)

    }
    
}

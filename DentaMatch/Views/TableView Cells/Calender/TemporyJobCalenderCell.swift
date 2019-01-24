//
//  TemporyJobCalenderCell.swift
//  DentaMatch
//
//  Created by Sanjay Kumar Yadav on 26/01/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

@objc protocol TemporyJobCalenderCellDelegate {
    @objc optional func selectTempJobDate(selected: Date)
    @objc optional func deSelectTempJobDate(deSelected: Date)
    @objc optional func nextButtonDelegate(date: Date)
    @objc optional func previouseButtonDelegate(date: Date)
}

class TemporyJobCalenderCell: UITableViewCell, FSCalendarDataSource, FSCalendarDelegate {
    @IBOutlet var calenderView: FSCalendar!
    @IBOutlet var previouseButton: UIButton!
    @IBOutlet var nextButton: UIButton!
    weak var delegate: TemporyJobCalenderCellDelegate?

    var gregorian: NSCalendar?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

        gregorian = NSCalendar(calendarIdentifier: .gregorian)
        calenderView.appearance.headerTitleFont = UIFont.fontRegular(fontSize: 12)
        calenderView.appearance.titleFont = UIFont.fontRegular(fontSize: 16)
        calenderView.appearance.weekdayFont = UIFont.fontRegular(fontSize: 16)

        calenderView.appearance.adjustsFontSizeToFitContentSize = false
        calenderView.appearance.adjustTitleIfNecessary()

        calenderView.appearance.headerTitleColor = Constants.Color.headerTitleColor
        calenderView.appearance.weekdayTextColor = Constants.Color.weekdayTextColor
        calenderView.appearance.titleDefaultColor = Constants.Color.headerTitleColor

        calenderView.appearance.selectionColor = Constants.Color.selectionColor
        calenderView.appearance.todayColor = UIColor.clear
//        calenderView.appearance.
        calenderView.appearance.caseOptions = .headerUsesUpperCase

//        calenderView.appearance.caseOptions = .weekdayUsesUpperCase
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func selectPreSelctDate(dateArray: [String]) {
        for dateString in dateArray {
            let date = Date.stringToDate(dateString: dateString)
            calenderView.select(date)
        }
        calenderView.setCurrentPage(Date(), animated: true)
    }

    @IBAction func previouseButtonClicked(_: Any) {
        let currentMonth: Date = calenderView.currentPage
        let previousMonth: Date = (gregorian?.date(byAdding: .month, value: -1, to: currentMonth, options: .matchFirst))!

        if previousMonth < calenderView.minimumDate {
            // self.makeToast("You can set up to previous six months availability from current month")
        }
        calenderView.setCurrentPage(previousMonth, animated: true)
        delegate?.nextButtonDelegate!(date: previousMonth)
    }

    @IBAction func nextButtonClicked(_: Any) {
        let currentMonth: Date = calenderView.currentPage
        let nextMonth: Date = (gregorian?.date(byAdding: .month, value: 1, to: currentMonth, options: .matchFirst))!

        if nextMonth > calenderView.maximumDate {
            makeToast("You can set up to next six months availability from current month")
        }
        calenderView.setCurrentPage(nextMonth, animated: true)
        delegate?.nextButtonDelegate!(date: nextMonth)
    }

    func minimumDate(for _: FSCalendar) -> Date {
        let firstDate = Date.getMonthBasedOnThis(date1: Date(), duration: -6)
        let date5 = gregorian?.fs_firstDay(ofMonth: firstDate)
        return date5!
    }

    func maximumDate(for _: FSCalendar) -> Date {
        let lastDate = Date.getMonthBasedOnThis(date1: Date(), duration: 6)
        let date2 = gregorian?.fs_lastDay(ofMonth: lastDate)
        return date2!
    }

    func calendar(_: FSCalendar, didSelect date: Date, at _: FSCalendarMonthPosition) {
        let dateStrFirst = Date.dateToString(date: date)
        let dateStrToday = Date.dateToString(date: Date())
        let dateSelected = Date.stringToDate(dateString: dateStrFirst)
        let dateToday = Date.stringToDate(dateString: dateStrToday)

        if dateSelected >= dateToday {
            delegate?.selectTempJobDate!(selected: date)
        } else {
            calenderView.deselect(date)
            makeToast(Constants.AlertMessage.canNotSelectPreDate)
        }
    }

    func calendar(_: FSCalendar, didDeselect date: Date, at _: FSCalendarMonthPosition) {
        delegate?.deSelectTempJobDate!(deSelected: date)
    }
}

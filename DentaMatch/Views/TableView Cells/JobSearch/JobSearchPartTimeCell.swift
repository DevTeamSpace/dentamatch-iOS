//
//  JobSearchPartTimeCell.swift
//  DentaMatch
//
//  Created by Shailesh Tyagi on 09/01/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

@objc protocol JobSearchPartTimeCellDelegate {
    @objc optional func selectDay(selected: Bool, day: String)
}

class JobSearchPartTimeCell: UITableViewCell {
    @IBOutlet var viewPartTime: UIView!
    @IBOutlet var btnSunday: UIButton!
    @IBOutlet var btnMonday: UIButton!
    @IBOutlet var btnTuesday: UIButton!
    @IBOutlet var btnWednesday: UIButton!
    @IBOutlet var btnThursday: UIButton!
    @IBOutlet var btnFriday: UIButton!
    @IBOutlet var btnSaturday: UIButton!

    weak var delegate: JobSearchPartTimeCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setUp()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

    override func layoutIfNeeded() {
        super.layoutIfNeeded()
    }

    // MARK: Private Methods

    func setUp() {
        viewPartTime.layer.borderColor = Constants.Color.jobSearchBorderColor.cgColor
        viewPartTime.layer.borderWidth = 1.0

        btnSunday.layer.cornerRadius = btnFriday.frame.size.height / 2
        btnMonday.layer.cornerRadius = btnFriday.frame.size.height / 2
        btnTuesday.layer.cornerRadius = btnFriday.frame.size.height / 2
        btnWednesday.layer.cornerRadius = btnFriday.frame.size.height / 2
        btnThursday.layer.cornerRadius = btnFriday.frame.size.height / 2
        btnFriday.layer.cornerRadius = btnFriday.frame.size.height / 2
        btnSaturday.layer.cornerRadius = btnFriday.frame.size.height / 2

        btnSunday.backgroundColor = UIColor.clear
        btnSunday.setTitleColor(Constants.Color.headerTitleColor, for: .normal)
        btnMonday.backgroundColor = UIColor.clear
        btnMonday.setTitleColor(Constants.Color.headerTitleColor, for: .normal)
        btnTuesday.backgroundColor = UIColor.clear
        btnTuesday.setTitleColor(Constants.Color.headerTitleColor, for: .normal)
        btnWednesday.backgroundColor = UIColor.clear
        btnWednesday.setTitleColor(Constants.Color.headerTitleColor, for: .normal)
        btnThursday.backgroundColor = UIColor.clear
        btnThursday.setTitleColor(Constants.Color.headerTitleColor, for: .normal)
        btnFriday.backgroundColor = UIColor.clear
        btnFriday.setTitleColor(Constants.Color.headerTitleColor, for: .normal)
        btnSaturday.backgroundColor = UIColor.clear
        btnSaturday.setTitleColor(Constants.Color.headerTitleColor, for: .normal)
    }

    // MARK: Set Cell Data

    func setCellData(parttimeDays: [String]) {
        if parttimeDays.contains(Constants.Days.sunday) {
            btnSunday.backgroundColor = Constants.Color.partTimeDaySelectColor
            btnSunday.setTitleColor(UIColor.white, for: .normal)
        } else {
            btnSunday.backgroundColor = UIColor.clear
            btnSunday.setTitleColor(Constants.Color.headerTitleColor, for: .normal)
        }

        if parttimeDays.contains(Constants.Days.monday) {
            btnMonday.backgroundColor = Constants.Color.partTimeDaySelectColor
            btnMonday.setTitleColor(UIColor.white, for: .normal)
        } else {
            btnMonday.backgroundColor = UIColor.clear
            btnMonday.setTitleColor(Constants.Color.headerTitleColor, for: .normal)
        }

        if parttimeDays.contains(Constants.Days.tuesday) {
            btnTuesday.backgroundColor = Constants.Color.partTimeDaySelectColor
            btnTuesday.setTitleColor(UIColor.white, for: .normal)
        } else {
            btnTuesday.backgroundColor = UIColor.clear
            btnTuesday.setTitleColor(Constants.Color.headerTitleColor, for: .normal)
        }

        if parttimeDays.contains(Constants.Days.wednesday) {
            btnWednesday.backgroundColor = Constants.Color.partTimeDaySelectColor
            btnWednesday.setTitleColor(UIColor.white, for: .normal)
        } else {
            btnWednesday.backgroundColor = UIColor.clear
            btnWednesday.setTitleColor(Constants.Color.headerTitleColor, for: .normal)
        }

        if parttimeDays.contains(Constants.Days.thursday) {
            btnThursday.backgroundColor = Constants.Color.partTimeDaySelectColor
            btnThursday.setTitleColor(UIColor.white, for: .normal)
        } else {
            btnThursday.backgroundColor = UIColor.clear
            btnThursday.setTitleColor(Constants.Color.headerTitleColor, for: .normal)
        }

        if parttimeDays.contains(Constants.Days.friday) {
            btnFriday.backgroundColor = Constants.Color.partTimeDaySelectColor
            btnFriday.setTitleColor(UIColor.white, for: .normal)
        } else {
            btnFriday.backgroundColor = UIColor.clear
            btnFriday.setTitleColor(Constants.Color.headerTitleColor, for: .normal)
        }

        if parttimeDays.contains(Constants.Days.saturday) {
            btnSaturday.backgroundColor = Constants.Color.partTimeDaySelectColor
            btnSaturday.setTitleColor(UIColor.white, for: .normal)
        } else {
            btnSaturday.backgroundColor = UIColor.clear
            btnSaturday.setTitleColor(Constants.Color.headerTitleColor, for: .normal)
        }
    }

    // MARK: IBOutlet Actions

    @IBAction func actionSunday(_ sender: UIButton) {
        checkToSelectOrDeselectButton(button: sender, day: Constants.Days.sunday)
    }

    @IBAction func actionMonday(_ sender: UIButton) {
        checkToSelectOrDeselectButton(button: sender, day: Constants.Days.monday)
    }

    @IBAction func actionTuesday(_ sender: UIButton) {
        checkToSelectOrDeselectButton(button: sender, day: Constants.Days.tuesday)
    }

    @IBAction func actionWednesday(_ sender: UIButton) {
        checkToSelectOrDeselectButton(button: sender, day: Constants.Days.wednesday)
    }

    @IBAction func btnThursday(_ sender: UIButton) {
        checkToSelectOrDeselectButton(button: sender, day: Constants.Days.thursday)
    }

    @IBAction func actionFriday(_ sender: UIButton) {
        checkToSelectOrDeselectButton(button: sender, day: Constants.Days.friday)
    }

    @IBAction func actionSaturday(_ sender: UIButton) {
        checkToSelectOrDeselectButton(button: sender, day: Constants.Days.saturday)
    }

    func checkToSelectOrDeselectButton(button: UIButton, day: String) {
        if button.backgroundColor == UIColor.clear {
            daySelect(button: button, day: day)
        } else {
            dayDeselect(button: button, day: day)
        }
    }

    func daySelect(button: UIButton, day: String) {
        button.backgroundColor = Constants.Color.partTimeDaySelectColor
        button.setTitleColor(UIColor.white, for: .normal)
        delegate?.selectDay!(selected: true, day: day)
    }

    func dayDeselect(button: UIButton, day: String) {
        button.backgroundColor = UIColor.clear
        button.setTitleColor(Constants.Color.headerTitleColor, for: .normal)
        delegate?.selectDay!(selected: false, day: day)
    }

    func daySelectFor(avail: UserAvailability) {
        if avail.isParttimeMonday {
            btnMonday.backgroundColor = Constants.Color.partTimeDaySelectColor
            btnMonday.setTitleColor(UIColor.white, for: .normal)

        } else {
            btnMonday.backgroundColor = UIColor.clear
            btnMonday.setTitleColor(Constants.Color.headerTitleColor, for: .normal)
        }
        if avail.isParttimeTuesday {
            btnTuesday.backgroundColor = Constants.Color.partTimeDaySelectColor
            btnTuesday.setTitleColor(UIColor.white, for: .normal)

        } else {
            btnTuesday.backgroundColor = UIColor.clear
            btnTuesday.setTitleColor(Constants.Color.headerTitleColor, for: .normal)
        }
        if avail.isParttimeWednesday {
            btnWednesday.backgroundColor = Constants.Color.partTimeDaySelectColor
            btnWednesday.setTitleColor(UIColor.white, for: .normal)

        } else {
            btnWednesday.backgroundColor = UIColor.clear
            btnWednesday.setTitleColor(Constants.Color.headerTitleColor, for: .normal)
        }
        if avail.isParttimeThursday {
            btnThursday.backgroundColor = Constants.Color.partTimeDaySelectColor
            btnThursday.setTitleColor(UIColor.white, for: .normal)

        } else {
            btnThursday.backgroundColor = UIColor.clear
            btnThursday.setTitleColor(Constants.Color.headerTitleColor, for: .normal)
        }
        if avail.isParttimeFriday {
            btnFriday.backgroundColor = Constants.Color.partTimeDaySelectColor
            btnFriday.setTitleColor(UIColor.white, for: .normal)

        } else {
            btnFriday.backgroundColor = UIColor.clear
            btnFriday.setTitleColor(Constants.Color.headerTitleColor, for: .normal)
        }
        if avail.isParttimeSaturday {
            btnSaturday.backgroundColor = Constants.Color.partTimeDaySelectColor
            btnSaturday.setTitleColor(UIColor.white, for: .normal)

        } else {
            btnSaturday.backgroundColor = UIColor.clear
            btnSaturday.setTitleColor(Constants.Color.headerTitleColor, for: .normal)
        }
        if avail.isParttimeSunday {
            btnSunday.backgroundColor = Constants.Color.partTimeDaySelectColor
            btnSunday.setTitleColor(UIColor.white, for: .normal)

        } else {
            btnSunday.backgroundColor = UIColor.clear
            btnSunday.setTitleColor(Constants.Color.headerTitleColor, for: .normal)
        }
    }
}

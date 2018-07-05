//
//  TemporyJobCell.swift
//  DentaMatch
//
//  Created by Sanjay Kumar Yadav on 26/01/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

@objc protocol TemporyJobCellDelegate {
    @objc optional func selectTempJobType(selected: Bool)
}

class TemporyJobCell: UITableViewCell {
    @IBOutlet var TemporyJobLabel: UILabel!
    @IBOutlet var temporyButton: UIButton!
    var isTemporaryTime: Bool! = false
    weak var delegate: TemporyJobCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setUpForButton(isTempTime: Bool) {
        isTemporaryTime = isTempTime
        if isTempTime {
            temporyButton.setTitle("w", for: .normal)
            temporyButton.setTitleColor(Constants.Color.tickSelectColor, for: .normal)
            TemporyJobLabel.textColor = Constants.Color.headerTitleColor

        } else {
            temporyButton.setTitle("t", for: .normal)
            temporyButton.setTitleColor(Constants.Color.tickDeselectColor, for: .normal)
            TemporyJobLabel.textColor = Constants.Color.jobTypeLabelDeselectedColor
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func TemporyButtonClicked(_: Any) {
        if isTemporaryTime == false {
            temporyButton.setTitle("w", for: .normal)
            temporyButton.setTitleColor(Constants.Color.availabilitySeletedColor, for: .normal)
            TemporyJobLabel.textColor = Constants.Color.headerTitleColor
            delegate?.selectTempJobType!(selected: true)
        } else {
            temporyButton.setTitle("t", for: .normal)
            temporyButton.setTitleColor(Constants.Color.availabilityUnseletedColor, for: .normal)
            TemporyJobLabel.textColor = Constants.Color.jobTypeLabelDeselectedColor
            delegate?.selectTempJobType!(selected: false)
        }
        isTemporaryTime = !isTemporaryTime
    }
}

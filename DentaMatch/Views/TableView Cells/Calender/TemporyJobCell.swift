//
//  TemporyJobCell.swift
//  DentaMatch
//
//  Created by Sanjay Kumar Yadav on 26/01/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

@objc protocol TemporyJobCellDelegate {
    @objc optional func selectTempJobType(selected : Bool)
}

class TemporyJobCell: UITableViewCell {
    @IBOutlet weak var TemporyJobLabel: UILabel!
    @IBOutlet weak var temporyButton: UIButton!
    var isTemporaryTime : Bool! = false
    weak var delegate : TemporyJobCellDelegate?


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func TemporyButtonClicked(_ sender: Any) {
        if isTemporaryTime == false {
            temporyButton.setTitle("w", for: .normal)
            temporyButton.setTitleColor(UIColor.init(red: 4.0/255.0, green: 112.0/255.0, blue: 192.0/255.0, alpha: 1.0), for: .normal)
            delegate?.selectTempJobType!(selected: true)
        }
        else {
            temporyButton.setTitle("t", for: .normal)
            temporyButton.setTitleColor(UIColor.init(red: 151.0/255.0, green: 151.0/255.0, blue: 151.0/255.0, alpha: 1.0), for: .normal)
            delegate?.selectTempJobType!(selected: false)
        }
        isTemporaryTime = !isTemporaryTime

        
    }
    
}

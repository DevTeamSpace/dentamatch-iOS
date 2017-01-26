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

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func previouseButtonClicked(_ sender: Any) {
    }
    @IBAction func nextButtonClicked(_ sender: Any) {
    }
    
}

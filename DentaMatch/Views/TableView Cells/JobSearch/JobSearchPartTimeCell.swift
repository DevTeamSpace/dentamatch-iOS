//
//  JobSearchPartTimeCell.swift
//  DentaMatch
//
//  Created by Shailesh Tyagi on 09/01/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

@objc protocol JobSearchPartTimeCellDelegate {
    
    @objc optional func selectDay(selected : Bool, day : String)
}

class JobSearchPartTimeCell: UITableViewCell {

    @IBOutlet weak var viewPartTime: UIView!
    @IBOutlet weak var btnSunday: UIButton!
    @IBOutlet weak var btnMonday: UIButton!
    @IBOutlet weak var btnTuesday: UIButton!
    @IBOutlet weak var btnWednesday: UIButton!
    @IBOutlet weak var btnThursday: UIButton!
    @IBOutlet weak var btnFriday: UIButton!
    @IBOutlet weak var btnSaturday: UIButton!
    
    weak var delegate : JobSearchPartTimeCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.setUp()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    override func layoutIfNeeded() {
        super.layoutIfNeeded()
    }
    
    //MARK : Private Methods
    
    func setUp() {
    
        viewPartTime.layer.borderColor = Constants.Color.jobSearchBorderColor.cgColor
        viewPartTime.layer.borderWidth = 1.0
        
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
        
        btnSunday.layer.cornerRadius = btnFriday.frame.size.height / 2
        btnMonday.layer.cornerRadius = btnFriday.frame.size.height / 2
        btnTuesday.layer.cornerRadius = btnFriday.frame.size.height / 2
        btnWednesday.layer.cornerRadius = btnFriday.frame.size.height / 2
        btnThursday.layer.cornerRadius = btnFriday.frame.size.height / 2
        btnFriday.layer.cornerRadius = btnFriday.frame.size.height / 2
        btnSaturday.layer.cornerRadius = btnFriday.frame.size.height / 2
    }
    
    //MARK : IBOutlet Actions
    
    @IBAction func actionSunday(_ sender: UIButton) {
        self.checkToSelectOrDeselectButton(button: sender, day: "sunday")
    }
    
    @IBAction func actionMonday(_ sender: UIButton) {
        self.checkToSelectOrDeselectButton(button: sender, day: "monday")
    }
    
    @IBAction func actionTuesday(_ sender: UIButton) {
        self.checkToSelectOrDeselectButton(button: sender, day: "tuesday")
    }
    
    @IBAction func actionWednesday(_ sender: UIButton) {
        self.checkToSelectOrDeselectButton(button: sender, day: "wednesday")
    }
    
    @IBAction func btnThursday(_ sender: UIButton) {
        self.checkToSelectOrDeselectButton(button: sender, day: "thursday")
    }
    
    @IBAction func actionFriday(_ sender: UIButton) {
        self.checkToSelectOrDeselectButton(button: sender, day: "friday")
    }
    
    @IBAction func actionSaturday(_ sender: UIButton) {
        self.checkToSelectOrDeselectButton(button: sender, day: "saturday")
    }
    
    func checkToSelectOrDeselectButton(button : UIButton, day : String) {
        if button.backgroundColor == UIColor.clear {
            self.daySelect(button: button, day: day)
        }
        else {
            self.dayDeselect(button: button, day: day)
        }
    }
    
    func daySelect(button : UIButton, day : String) {
        button.backgroundColor = Constants.Color.partTimeDaySelectColor
        button.setTitleColor(UIColor.white, for: .normal)
        delegate?.selectDay!(selected: true, day: day)
    }
    
    func dayDeselect(button : UIButton, day : String) {
        button.backgroundColor = UIColor.clear
        button.setTitleColor(Constants.Color.headerTitleColor, for: .normal)
        delegate?.selectDay!(selected: false, day: day)
        
    }
}

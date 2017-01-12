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
    
        viewPartTime.layer.borderColor = UIColor.init(colorLiteralRed: 229.0/255.0, green: 229.0/255.0, blue: 229.0/255.0, alpha: 1.0).cgColor
        viewPartTime.layer.borderWidth = 1.0
        
        btnSunday.backgroundColor = UIColor.clear
        btnSunday.setTitleColor(UIColor.init(colorLiteralRed: 81.0/255.0, green: 81.0/255.0, blue: 81.0/255.0, alpha: 1.0), for: .normal)
        btnMonday.backgroundColor = UIColor.clear
        btnMonday.setTitleColor(UIColor.init(colorLiteralRed: 81.0/255.0, green: 81.0/255.0, blue: 81.0/255.0, alpha: 1.0), for: .normal)
        btnTuesday.backgroundColor = UIColor.clear
        btnTuesday.setTitleColor(UIColor.init(colorLiteralRed: 81.0/255.0, green: 81.0/255.0, blue: 81.0/255.0, alpha: 1.0), for: .normal)
        btnWednesday.backgroundColor = UIColor.clear
        btnWednesday.setTitleColor(UIColor.init(colorLiteralRed: 81.0/255.0, green: 81.0/255.0, blue: 81.0/255.0, alpha: 1.0), for: .normal)
        btnThursday.backgroundColor = UIColor.clear
        btnThursday.setTitleColor(UIColor.init(colorLiteralRed: 81.0/255.0, green: 81.0/255.0, blue: 81.0/255.0, alpha: 1.0), for: .normal)
        btnFriday.backgroundColor = UIColor.clear
        btnFriday.setTitleColor(UIColor.init(colorLiteralRed: 81.0/255.0, green: 81.0/255.0, blue: 81.0/255.0, alpha: 1.0), for: .normal)
        btnSaturday.backgroundColor = UIColor.clear
        btnSaturday.setTitleColor(UIColor.init(colorLiteralRed: 81.0/255.0, green: 81.0/255.0, blue: 81.0/255.0, alpha: 1.0), for: .normal)
        
        btnSunday.layer.cornerRadius = btnFriday.frame.size.height / 2
        btnMonday.layer.cornerRadius = btnFriday.frame.size.height / 2
        btnTuesday.layer.cornerRadius = btnFriday.frame.size.height / 2
        btnWednesday.layer.cornerRadius = btnFriday.frame.size.height / 2
        btnThursday.layer.cornerRadius = btnFriday.frame.size.height / 2
        btnFriday.layer.cornerRadius = btnFriday.frame.size.height / 2
        btnSaturday.layer.cornerRadius = btnFriday.frame.size.height / 2
    }
    
    func daySelect(button : UIButton) {
        button.backgroundColor = UIColor.init(colorLiteralRed: 142.0/255.0, green: 207.0/255.0, blue: 125.0/255.0, alpha: 1.0)
        button.setTitleColor(UIColor.white, for: .normal)
    }
    
    func dayDeselect(button : UIButton) {
        button.backgroundColor = UIColor.clear
        button.setTitleColor(UIColor.init(colorLiteralRed: 81.0/255.0, green: 81.0/255.0, blue: 81.0/255.0, alpha: 1.0), for: .normal)
    }
    
    func checkToSelectOrDeselectButton(button : UIButton) {
        if button.backgroundColor == UIColor.clear {
            self.daySelect(button: button)
        }
        else {
            self.dayDeselect(button: button)
        }
    }
    
    //MARK : IBOutlet Actions
    
    @IBAction func actionSunday(_ sender: UIButton) {
        self.checkToSelectOrDeselectButton(button: sender)
    }
    
    @IBAction func actionMonday(_ sender: UIButton) {
        self.checkToSelectOrDeselectButton(button: sender)
    }
    
    @IBAction func actionTuesday(_ sender: UIButton) {
        self.checkToSelectOrDeselectButton(button: sender)
    }
    
    @IBAction func actionWednesday(_ sender: UIButton) {
        self.checkToSelectOrDeselectButton(button: sender)
    }
    
    @IBAction func btnThursday(_ sender: UIButton) {
        self.checkToSelectOrDeselectButton(button: sender)
    }
    
    @IBAction func actionFriday(_ sender: UIButton) {
        self.checkToSelectOrDeselectButton(button: sender)
    }
    
    @IBAction func actionSaturday(_ sender: UIButton) {
        self.checkToSelectOrDeselectButton(button: sender)
    }
}

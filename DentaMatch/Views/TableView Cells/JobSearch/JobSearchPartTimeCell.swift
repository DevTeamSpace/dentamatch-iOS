//
//  JobSearchPartTimeCell.swift
//  DentaMatch
//
//  Created by Shailesh Tyagi on 09/01/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

class JobSearchPartTimeCell: UITableViewCell {

    @IBOutlet weak var viewPartTime: UIView!
    
    @IBOutlet weak var btnSunday: UIButton!
    @IBOutlet weak var btnMonday: UIButton!
    @IBOutlet weak var btnTuesday: UIButton!
    @IBOutlet weak var btnWednesday: UIButton!
    @IBOutlet weak var btnThursday: UIButton!
    @IBOutlet weak var btnFriday: UIButton!
    @IBOutlet weak var btnSaturday: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
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
    }
    
    func daySelect(_ button : UIButton) {
        button.layer.cornerRadius = btnFriday.frame.size.height / 2
        button.backgroundColor = UIColor.init(colorLiteralRed: 142.0/255.0, green: 207.0/255.0, blue: 125.0/255.0, alpha: 1.0)
        button.titleLabel?.textColor = UIColor.white
    }
    
    func dayDeselect(_ button : UIButton) {
        button.backgroundColor = UIColor.clear
        button.titleLabel?.textColor = UIColor.init(colorLiteralRed: 81.0/255.0, green: 81.0/255.0, blue: 81.0/255.0, alpha: 1.0)
    }
    
    //MARK : IBOutlet Actions
    
    @IBAction func actionSunday(_ sender: UIButton) {
    }
    
    @IBAction func actionMonday(_ sender: UIButton) {
    }
    
    @IBAction func actionTuesday(_ sender: UIButton) {
    }
    
    @IBAction func actionWednesday(_ sender: UIButton) {
    }
    
    @IBAction func btnThursday(_ sender: UIButton) {
    }
    
    @IBAction func actionFriday(_ sender: UIButton) {
    }
    
    @IBAction func actionSaturday(_ sender: UIButton) {
    }
}

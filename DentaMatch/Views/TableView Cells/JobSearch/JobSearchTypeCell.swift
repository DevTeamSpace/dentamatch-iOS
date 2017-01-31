//
//  JobSearchTypeCell.swift
//  DentaMatch
//
//  Created by Shailesh Tyagi on 09/01/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

enum JobSearchType : String {
    case FullTime = "FullTime"
    case PartTime = "PartTime"
}

@objc protocol JobSearchTypeCellDelegate {
    
    @objc optional func selectJobSearchType(selected : Bool,type : String)
}

class JobSearchTypeCell: UITableViewCell {
    
    @IBOutlet weak var viewJobType: UIView!
    @IBOutlet weak var btnFullTime: UIButton!
    @IBOutlet weak var btnPartTime: UIButton!
    @IBOutlet weak var lblFullTime: UILabel!
    @IBOutlet weak var lblPartTime: UILabel!
    
    var isFullTime : Bool! = false
    var isPartTime : Bool! = false
    
    weak var delegate : JobSearchTypeCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.setUp()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    
    func setUp() {
        viewJobType.layer.borderColor = Constants.Color.jobSearchTitleLocationColor.cgColor
        viewJobType.layer.borderWidth = 1.0
    }
    
    //MARK : IBOutlet Action
    
    @IBAction func actionFullTime(_ sender: UIButton) {
        if isFullTime == false {
            sender.setTitle("w", for: .normal)
            sender.setTitleColor(Constants.Color.availabilitySeletedColor, for: .normal)
            self.lblFullTime.textColor = Constants.Color.jobSearchSelectedLabel
            delegate?.selectJobSearchType!(selected: true, type: JobSearchType.FullTime.rawValue)
        }
        else {
            sender.setTitle("t", for: .normal)
            sender.setTitleColor(Constants.Color.availabilityUnseletedColor, for: .normal)
            self.lblFullTime.textColor = Constants.Color.jobSearchUnSelectedLabel
            delegate?.selectJobSearchType!(selected: false, type: JobSearchType.FullTime.rawValue)
        }
        isFullTime = !isFullTime
    }
    
    @IBAction func actionPartTime(_ sender: UIButton) {
        if isPartTime == false {
            sender.setTitle("w", for: .normal)
            sender.setTitleColor(Constants.Color.availabilitySeletedColor, for: .normal)
            self.lblPartTime.textColor = Constants.Color.jobSearchSelectedLabel
            delegate?.selectJobSearchType!(selected: true, type: JobSearchType.PartTime.rawValue)
        }
        else {
            sender.setTitle("t", for: .normal)
            sender.setTitleColor(Constants.Color.availabilityUnseletedColor, for: .normal)
            self.lblPartTime.textColor = Constants.Color.jobSearchUnSelectedLabel
            delegate?.selectJobSearchType!(selected: false, type: JobSearchType.PartTime.rawValue)
        }
        isPartTime = !isPartTime
    }
}

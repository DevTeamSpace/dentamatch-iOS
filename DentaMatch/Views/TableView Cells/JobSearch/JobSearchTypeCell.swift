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
        viewJobType.layer.borderColor = UIColor.init(colorLiteralRed: 229.0/255.0, green: 229.0/255.0, blue: 229.0/255.0, alpha: 1.0).cgColor
        viewJobType.layer.borderWidth = 1.0
    }
    
    //MARK : IBOutlet Action
    
    @IBAction func actionFullTime(_ sender: UIButton) {
        if isFullTime == true {
            delegate?.selectJobSearchType!(selected: true, type: JobSearchType.FullTime.rawValue)
            sender.setTitle("check", for: .normal)
        }
        else {
            delegate?.selectJobSearchType!(selected: false, type: JobSearchType.FullTime.rawValue)
            sender.setTitle("t", for: .normal)
        }
        isFullTime = !isFullTime
    }
    
    @IBAction func actionPartTime(_ sender: UIButton) {
        if isPartTime == true {
            delegate?.selectJobSearchType!(selected: false, type: JobSearchType.PartTime.rawValue)
            sender.setTitle("check", for: .normal)
        }
        else {
            delegate?.selectJobSearchType!(selected: true, type: JobSearchType.PartTime.rawValue)
            sender.setTitle("t", for: .normal)
        }
        isPartTime = !isPartTime
    }
    
    
}

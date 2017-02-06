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
        viewJobType.layer.borderColor = Constants.Color.jobSearchBorderColor.cgColor
        viewJobType.layer.borderWidth = 1.0
    }
    func setUpForButtons(isPartTime:Bool, isFullTime:Bool ) {
        self.isFullTime = isFullTime
        self.isPartTime = isPartTime
        if isFullTime {
            self.btnFullTime.setTitle("w", for: .normal)
            self.btnFullTime.setTitleColor(Constants.Color.tickSelectColor, for: .normal)
            self.lblFullTime.textColor = Constants.Color.headerTitleColor

        }else {
            
            self.btnFullTime.setTitle("t", for: .normal)
            self.btnFullTime.setTitleColor(Constants.Color.tickDeselectColor, for: .normal)
            self.lblFullTime.textColor = Constants.Color.jobTypeLabelDeselectedColor
        }
        if isPartTime {
            self.btnPartTime.setTitle("w", for: .normal)
            self.btnPartTime.setTitleColor(Constants.Color.tickSelectColor, for: .normal)
            self.lblPartTime.textColor = Constants.Color.headerTitleColor
        }else {
            self.btnPartTime.setTitle("t", for: .normal)
            self.btnPartTime.setTitleColor(Constants.Color.tickDeselectColor, for: .normal)
            self.lblPartTime.textColor = Constants.Color.jobTypeLabelDeselectedColor
        }

    }
    
    //MARK : Set Cell Data
    
    func setCellData(isFullTime : String, isPartTime : String) {
        if isFullTime == "1" {
            btnFullTime.setTitle("w", for: .normal)
            btnFullTime.setTitleColor(Constants.Color.tickSelectColor, for: .normal)
            self.lblFullTime.textColor = Constants.Color.headerTitleColor
            self.isFullTime = true
        }
        else {
            btnFullTime.setTitle("t", for: .normal)
            btnFullTime.setTitleColor(Constants.Color.tickDeselectColor, for: .normal)
            self.lblFullTime.textColor = Constants.Color.jobTypeLabelDeselectedColor
            self.isFullTime = false
        }
        
        if isPartTime == "1" {
            btnPartTime.setTitle("w", for: .normal)
            btnPartTime.setTitleColor(Constants.Color.tickSelectColor, for: .normal)
            self.lblPartTime.textColor = Constants.Color.headerTitleColor
            delegate?.selectJobSearchType!(selected: true, type: JobSearchType.FullTime.rawValue)
            self.isPartTime = true
        }
        else {
            btnPartTime.setTitle("t", for: .normal)
            btnPartTime.setTitleColor(Constants.Color.tickDeselectColor, for: .normal)
            self.lblPartTime.textColor = Constants.Color.jobTypeLabelDeselectedColor
            delegate?.selectJobSearchType!(selected: false, type: JobSearchType.FullTime.rawValue)
            self.isPartTime = false
        }
    }
    
    //MARK : IBOutlet Action
    
    @IBAction func actionFullTime(_ sender: UIButton) {
        if isFullTime == false {
            sender.setTitle("w", for: .normal)
            sender.setTitleColor(Constants.Color.tickSelectColor, for: .normal)
            self.lblFullTime.textColor = Constants.Color.headerTitleColor
            delegate?.selectJobSearchType!(selected: true, type: JobSearchType.FullTime.rawValue)
        }
        else {
            sender.setTitle("t", for: .normal)
            sender.setTitleColor(Constants.Color.tickDeselectColor, for: .normal)
            self.lblFullTime.textColor = Constants.Color.jobTypeLabelDeselectedColor
            delegate?.selectJobSearchType!(selected: false, type: JobSearchType.FullTime.rawValue)
        }
        isFullTime = !isFullTime
    }
    
    @IBAction func actionPartTime(_ sender: UIButton) {
        if isPartTime == false {
            sender.setTitle("w", for: .normal)
            sender.setTitleColor(Constants.Color.tickSelectColor, for: .normal)
            self.lblPartTime.textColor = Constants.Color.headerTitleColor
            delegate?.selectJobSearchType!(selected: true, type: JobSearchType.PartTime.rawValue)
        }
        else {
            sender.setTitle("t", for: .normal)
            sender.setTitleColor(Constants.Color.tickDeselectColor, for: .normal)
            self.lblPartTime.textColor = Constants.Color.jobTypeLabelDeselectedColor
            delegate?.selectJobSearchType!(selected: false, type: JobSearchType.PartTime.rawValue)
        }
        isPartTime = !isPartTime
    }
}

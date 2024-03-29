//
//  CustomSegmentControl.swift
//  DentaMatch
//
//  Created by Rajan Maheshwari on 27/01/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

class CustomSegmentControl: UISegmentedControl {

    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor.clear
        self.tintColor = UIColor.color(withHexCode: "0470c0")
        self.setTitleTextAttributes([NSFontAttributeName:UIFont.fontRegular(fontSize: 13.0)!,NSForegroundColorAttributeName:UIColor.white], for: .normal)
        self.setTitleTextAttributes([NSFontAttributeName:UIFont.fontRegular(fontSize: 13.0)!,NSForegroundColorAttributeName:UIColor.white], for: .selected)
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}

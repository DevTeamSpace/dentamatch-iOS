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
        backgroundColor = UIColor.clear
        tintColor = UIColor.color(withHexCode: "0470c0")
        setTitleTextAttributes([NSAttributedStringKey.font: UIFont.fontRegular(fontSize: 13.0)!, NSAttributedStringKey.foregroundColor: UIColor.white], for: .normal)
        setTitleTextAttributes([NSAttributedStringKey.font: UIFont.fontRegular(fontSize: 13.0)!, NSAttributedStringKey.foregroundColor: UIColor.white], for: .selected)
    }

}

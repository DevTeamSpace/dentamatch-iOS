//
//  TitleHeaderView.swift
//  DentaMatch
//
//  Created by Rajan Maheshwari on 06/11/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

class TitleHeaderView: UIView {
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */

    class func loadTitleHeaderView() -> TitleHeaderView {
        guard let instance = Bundle.main.loadNibNamed("TitleHeaderView", owner: self)?.first as? TitleHeaderView else {
            fatalError("Could not instantiate from nib: PlaceHolderJobsView")
        }
        return instance
    }
}

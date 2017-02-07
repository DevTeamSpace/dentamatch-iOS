//
//  PlaceHolderJobsView.swift
//  DentaMatch
//
//  Created by Rajan Maheshwari on 06/02/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

class PlaceHolderJobsView: UIView {

    @IBOutlet weak var placeHolderMessageLabel: UILabel!
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    class func loadPlaceHolderJobsView() ->  PlaceHolderJobsView {
        guard let instance = Bundle.main.loadNibNamed("PlaceHolderJobsView", owner: self)?.first as? PlaceHolderJobsView else {
            fatalError("Could not instantiate from nib: PlaceHolderJobsView")
        }
        return instance
    }

}

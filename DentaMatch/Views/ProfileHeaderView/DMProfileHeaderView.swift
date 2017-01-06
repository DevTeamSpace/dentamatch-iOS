//
//  DMProfileHeaderView.swift
//  DentaMatch
//
//  Created by Sanjay Kumar Yadav on 04/01/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

class DMProfileHeaderView: UIView {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var NameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    class func loadProfileView() ->  DMProfileHeaderView{
        guard let instance = Bundle.main.loadNibNamed("DMProfileHeaderView", owner: self)?.first as? DMProfileHeaderView else {
            fatalError("Could not instantiate from nib: DMProfileHeaderView")
        }
        instance.profileImage.layer.cornerRadius = instance.profileImage.frame.size.height/2
        instance.profileImage.clipsToBounds = true
        return instance
    }
    

}

//
//  ProfileImageButton.swift
//  DentaMatch
//
//  Created by Rajan Maheshwari on 07/01/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

class ProfileImageButton: UIButton {

    var progressBar:CircleProgressBar!
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        self.layer.cornerRadius = self.frame.size.width/2
        self.imageView?.contentMode = .scaleAspectFill
        self.clipsToBounds = true
        progressBar = CircleProgressBar(frame: CGRect(x: 0, y: 0, width: self.frame.size.width , height: self.frame.size.height ))
        progressBar.progressBarWidth = 3.0
        progressBar.progressBarTrackColor = Constants.Color.profileProgressBarTrackColor
        progressBar.progressBarProgressColor = Constants.Color.profileProgressBarColor
        progressBar.hintHidden = true
        progressBar.backgroundColor = UIColor.clear
        progressBar.startAngle = -90
        progressBar.bounds = self.bounds
        self.addSubview(progressBar)
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
 */

}

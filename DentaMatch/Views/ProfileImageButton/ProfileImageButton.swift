//
//  ProfileImageButton.swift
//  DentaMatch
//
//  Created by Rajan Maheshwari on 07/01/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

class ProfileImageButton: UIButton {
    var progressBar: CircleProgressBar!

    override func awakeFromNib() {
        super.awakeFromNib()

        layer.cornerRadius = frame.size.width / 2
        imageView?.contentMode = .scaleAspectFill
        clipsToBounds = true
        progressBar = CircleProgressBar(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height))
        progressBar.progressBarWidth = 3.0
        progressBar.progressBarTrackColor = Constants.Color.profileProgressBarTrackColor
        progressBar.progressBarProgressColor = Constants.Color.profileProgressBarColor
        progressBar.hintHidden = true
        progressBar.backgroundColor = UIColor.clear
        progressBar.startAngle = -90
        progressBar.bounds = bounds
        addSubview(progressBar)
    }

}

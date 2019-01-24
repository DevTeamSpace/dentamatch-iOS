//
//  PhotoNameCell.swift
//  DentaMatch
//
//  Created by Sanjay Kumar Yadav on 02/01/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

class PhotoNameCell: UITableViewCell {
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var jobTitleLabel: UILabel!
    @IBOutlet var photoButton: ProfileImageButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        photoButton.layer.cornerRadius = photoButton.bounds.size.height / 2
        photoButton.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

    func updateCellForPhotoNameCell(nametext: String, jobTitleText: String, profileProgress: CGFloat) {
        nameLabel.text = nametext
        jobTitleLabel.text = jobTitleText
        if let imageURL = URL(string: UserManager.shared().activeUser.profileImageURL!) {
            photoButton.setImage(for: .normal, url: imageURL, placeholder: kPlaceHolderImage)
        }
        photoButton.progressBar.setProgress(profileProgress, animated: true)
    }
}

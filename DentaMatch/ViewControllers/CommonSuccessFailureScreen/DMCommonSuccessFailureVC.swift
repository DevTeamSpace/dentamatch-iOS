//
//  DMCommonSuccessFailureVC.swift
//  DentaMatch
//
//  Created by Rajan Maheshwari on 14/12/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

class DMCommonSuccessFailureVC: UIViewController {
    @IBOutlet var headingImageView: UIImageView!

    @IBOutlet var completeProfileButton: UIButton!
    @IBOutlet var detailLabel: UILabel!
    @IBOutlet var titleLabel: UILabel!

    var isJobSeekerVerified = false

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        // Do any additional setup after loading the view.
    }

    func setup() {
        if !isJobSeekerVerified {
            headingImageView.image = UIImage(named: "pendingApproval")
            detailLabel.text = "Your profile is pending admin’s approval. You can view details and apply for jobs once your profile gets approved."
            titleLabel.text = "Pending Approval"
            completeProfileButton.isHidden = true
        }
    }

    @IBAction func dismissButtonPressed(_: Any) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func completeProfileButtonPressed(_: Any) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "setTabBarToProfile"), object: nil)
        dismiss(animated: true, completion: nil)
    }
}

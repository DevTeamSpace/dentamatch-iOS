//
//  DMCommonSuccessFailureVC.swift
//  DentaMatch
//
//  Created by Rajan Maheshwari on 14/12/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

class DMCommonSuccessFailureVC: UIViewController {

    @IBOutlet weak var headingImageView: UIImageView!
    
    @IBOutlet weak var completeProfileButton: UIButton!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
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

    @IBAction func dismissButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func completeProfileButtonPressed(_ sender: Any) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "setTabBarToProfile"), object: nil)
        self.dismiss(animated: true, completion: nil)

    }
    
}

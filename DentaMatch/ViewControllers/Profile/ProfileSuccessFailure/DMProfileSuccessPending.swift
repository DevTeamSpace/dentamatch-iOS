//
//  DMProfileSuccessPending.swift
//  DentaMatch
//
//  Created by Rajan Maheshwari on 28/11/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

class DMProfileSuccessPending: UIViewController {

    @IBOutlet weak var successPendingImageView: UIImageView!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    var isLicenseRequired = false
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    func setup() {
        if isLicenseRequired {
            successPendingImageView.image = UIImage(named:"pendingApproval")
            titleLabel.text = "Pending Approval"
            detailLabel.text = "Your profile has been sent for admin’s  approval. You can apply for jobs once your profile gets approved.\n\nIn the meantime, Lets set your availability so that dental offices can get to know about your timings."
        }
    }
    
    @IBAction func letsGoButtonPressed(_ sender: Any) {
        let calendarSetAvailabillityVC = UIStoryboard.calenderStoryBoard().instantiateViewController(type: DMCalendarSetAvailabillityVC.self)!
        calendarSetAvailabillityVC.fromJobSelection = true
        self.navigationController?.pushViewController(calendarSetAvailabillityVC, animated: true)
    }
    

}
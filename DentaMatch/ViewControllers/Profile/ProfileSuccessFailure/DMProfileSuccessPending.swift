//
//  DMProfileSuccessPending.swift
//  DentaMatch
//
//  Created by Rajan Maheshwari on 28/11/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

class DMProfileSuccessPending: DMBaseVC {
    
    @IBOutlet weak var letsGoButton: UIButton!
    @IBOutlet weak var successPendingImageView: UIImageView!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    var isLicenseRequired = false
    var isEmailVerified = false
    var fromRoot = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        verifyEmailAPI()
    }
    
    func verifyEmailAPI() {
        verifyEmail(completionHandler: { (isVerified:Bool, error:NSError?) in
            if error == nil && isVerified {
                DispatchQueue.main.async {
                    if self.isEmailVerified {
                        return
                    }
                    self.goToCalendar()
                }
            } else {
                self.hideAll(isHidden: false)
            }
        })
    }
    
    func hideAll(isHidden:Bool) {
        letsGoButton.isHidden = isHidden
        successPendingImageView.isHidden = isHidden
        titleLabel.isHidden = isHidden
        detailLabel.isHidden = isHidden
    }

    func setup() {
        if fromRoot {
            self.hideAll(isHidden: true)
        }
        if !isEmailVerified {
            letsGoButton.setTitle("VERIFIED EMAIL", for: .normal)
            successPendingImageView.image = UIImage(named:"verifyEmail")
            titleLabel.text = "Verify Email"
            detailLabel.text = "We Have sent a verification link on your registered email. Please verify it to proceed further."
            
        } else if isLicenseRequired {
            successPendingImageView.image = UIImage(named:"pendingApproval")
            titleLabel.text = "Pending Approval"
            detailLabel.text = "Your profile has been sent for admin’s  approval. You can apply for jobs once your profile gets approved.\n\nIn the meantime, Lets set your availability so that dental offices can get to know about your timings."
        }
    }
    
    @IBAction func letsGoButtonPressed(_ sender: Any) {
        if !isEmailVerified {
            verifyEmail(completionHandler: { (isVerified:Bool, error:NSError?) in
                if error == nil && isVerified {
                    DispatchQueue.main.async {
                        self.goToCalendar()
                    }
                }
            })
            print("Check with new email verify api")
        } else {
            goToCalendar()
        }
    }
    
    func goToCalendar() {
        let calendarSetAvailabillityVC = UIStoryboard.calenderStoryBoard().instantiateViewController(type: DMCalendarSetAvailabillityVC.self)!
        calendarSetAvailabillityVC.fromJobSelection = true
        self.navigationController?.pushViewController(calendarSetAvailabillityVC, animated: true)
    }

}

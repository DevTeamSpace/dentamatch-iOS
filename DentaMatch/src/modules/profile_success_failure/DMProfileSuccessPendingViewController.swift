//
//  DMProfileSuccessPending.swift
//  DentaMatch
//
//  Created by Rajan Maheshwari on 28/11/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

class DMProfileSuccessPending: DMBaseVC {
    @IBOutlet var letsGoButton: UIButton!
    @IBOutlet var successPendingImageView: UIImageView!
    @IBOutlet var detailLabel: UILabel!
    @IBOutlet var titleLabel: UILabel!

    var isLicenseRequired = false
    var isEmailVerified = false
    var fromRoot = false
    
    var viewOutput: DMProfileSuccessPendingViewOutput?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        addNotificationObserver()
        setup()
        
        viewOutput?.didLoad()
    }

    func addNotificationObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(willEnterForgeGroundCalled), name: UIApplication.willEnterForegroundNotification, object: nil)
    }

    func removeObserversForNotification() {
        NotificationCenter.default.removeObserver(self, name: UIApplication.willEnterForegroundNotification, object: nil)
    }

    @objc func willEnterForgeGroundCalled() {
        if isEmailVerified == false {
            viewOutput?.verifyEmail(silent: true)
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        removeObserversForNotification()
    }

    deinit {
        self.removeObserversForNotification()
    }

    func hideAll(isHidden: Bool) {
        letsGoButton.isHidden = isHidden
        successPendingImageView.isHidden = isHidden
        titleLabel.isHidden = isHidden
        detailLabel.isHidden = isHidden
    }

    func setup() {
        if fromRoot {
            hideAll(isHidden: true)
            viewOutput?.verifyEmail(silent: true)
        }
        if !isEmailVerified {
            showUIForVerifyEmail()

        } else if isLicenseRequired {
            showUIForPending()
        }
        
        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    func showUIForVerifyEmail() {
        letsGoButton.setTitle("LET'S GO", for: .normal)
        successPendingImageView.image = UIImage(named: "verifyEmail")
        titleLabel.text = "Almost There"
        detailLabel.text = "Please check your email to activate your new account."
    }

    func showUIForCongrats() {
        hideAll(isHidden: false)
        letsGoButton.setTitle("LET'S GO", for: .normal)
        successPendingImageView.image = UIImage(named: "congratesTick")
        titleLabel.text = Constants.AlertMessage.niceToMeetYou
        detailLabel.text = "Now it’s time set your availability to get matched with jobs and temp work that fits your schedule."
    }

    func showUIForPending() {
        hideAll(isHidden: false)
        letsGoButton.setTitle("LET'S GO", for: .normal)
        successPendingImageView.image = UIImage(named: "pendingApproval")
        titleLabel.text = Constants.AlertMessage.niceToMeetYou
        detailLabel.text = "We’ll confirm your license and approve your profile within 1 business day.\n\nIn the meantime, set your availability to get matched with jobs that fit your schedule and add skills and certifications to your profile."
    }

    @IBAction func letsGoButtonPressed(_: Any) {
        if !isEmailVerified {
            viewOutput?.verifyEmail(silent: false)
        } else {
            viewOutput?.openCalendar()
        }
    }

    func showPendingCongrats() {
        isEmailVerified = true
        if UserManager.shared().activeUser.isJobSeekerVerified == true {
            showUIForCongrats()
        } else {

            showUIForPending()
        }
    }
}

extension DMProfileSuccessPending: DMProfileSuccessPendingViewInput {
    
    func configure(isEmailVerified: Bool, isLicenseRequired: Bool, fromRoot: Bool) {
        self.isEmailVerified = isEmailVerified
        self.isLicenseRequired = isLicenseRequired
        self.fromRoot = fromRoot
    }
    
    func configureViewOnVerify(isVerified: Bool, message: String, silent: Bool) {
        
        if isVerified {
            showPendingCongrats()
            return
        }
        
        if !silent {
            showAlertMessage(title: "Message", body: message)
        } else {
            hideAll(isHidden: false)
            showUIForVerifyEmail()
        }
    }
}

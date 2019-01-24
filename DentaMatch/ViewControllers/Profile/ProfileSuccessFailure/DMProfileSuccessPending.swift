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

    override func viewDidLoad() {
        super.viewDidLoad()
        addNotificationObserver()
        setup()
        verifyEmailAPI()
    }

    func addNotificationObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(willEnterForgeGroundCalled), name: UIApplication.willEnterForegroundNotification, object: nil)
    }

    func removeObserversForNotification() {
        NotificationCenter.default.removeObserver(self, name: UIApplication.willEnterForegroundNotification, object: nil)
    }

    @objc func willEnterForgeGroundCalled() {
        if isEmailVerified == false {
            verifyEmailAPI()
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // print("viewWillDisappear called ")
        removeObserversForNotification()
    }

    deinit {
        // print("deinit called ")
        self.removeObserversForNotification()
        // Logger.debug("deinit TLStory")
    }

    func verifyEmailAPI() {
        verifyEmail(completionHandler: { (isVerified: Bool, _: String, error: NSError?) in
            if error == nil && isVerified {
                DispatchQueue.main.async {
                    self.showPendingCongrats()
                    if self.isEmailVerified {
                        return
                    }
                }
            } else {
                self.hideAll(isHidden: false)
                self.showUIForVerifyEmail()
            }
        })
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
        }
        if !isEmailVerified {
            showUIForVerifyEmail()

        } else if isLicenseRequired {
            showUIForPending()
        }
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
            verifyEmail(completionHandler: { (isVerified: Bool, message: String, error: NSError?) in
                if error == nil {
                    if isVerified {
                        DispatchQueue.main.async {
                            self.showPendingCongrats()
                        }
                    } else {
                        DispatchQueue.main.async {
                            self.alertMessage(title: "Message", message: message, buttonText: "Ok", completionHandler: nil)
                        }
                    }
                }
            })
            // print("Check with new email verify api")
        } else {
            goToCalendar()
        }
    }

    func showPendingCongrats() {
        isEmailVerified = true
        if UserManager.shared().activeUser.isJobSeekerVerified == true {
            // congrats UI
            showUIForCongrats()
        } else {
            // pending UI
            showUIForPending()
        }
    }

    func goToCalendar() {
        let calendarSetAvailabillityVC = UIStoryboard.calenderStoryBoard().instantiateViewController(type: DMCalendarSetAvailabillityVC.self)!
        calendarSetAvailabillityVC.fromJobSelection = true
        navigationController?.pushViewController(calendarSetAvailabillityVC, animated: true)
    }
}

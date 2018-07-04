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
        self.addNotificationObserver()
        setup()
        verifyEmailAPI()
    }
    
    func addNotificationObserver(){
        NotificationCenter.default.addObserver(self, selector: #selector(self.willEnterForgeGroundCalled), name:.UIApplicationWillEnterForeground, object: nil)

    }
    func removeObserversForNotification() {
        NotificationCenter.default.removeObserver(self, name: .UIApplicationWillEnterForeground, object: nil)
    }
    
    @objc func willEnterForgeGroundCalled() {
        if self.isEmailVerified == false {
            self.verifyEmailAPI()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //print("viewWillDisappear called ")
        self.removeObserversForNotification()
    }
    deinit {
        //print("deinit called ")
        self.removeObserversForNotification()
        //Logger.debug("deinit TLStory")
    }
    
    func verifyEmailAPI() {
        verifyEmail(completionHandler: { (isVerified:Bool, message:String,error:NSError?) in
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
           self.showUIForVerifyEmail()
            
        } else if isLicenseRequired {
            self.showUIForPending()
        }
        
    }
    
    func showUIForVerifyEmail(){
        letsGoButton.setTitle("RESEND VERIFICATION EMAIL", for: .normal)
        successPendingImageView.image = UIImage(named:"verifyEmail")
        titleLabel.text = "Verify Email"
        detailLabel.text = "We have sent a verification link on your registered email. Please verify it to proceed further."
    }
    func showUIForCongrats(){
        self.hideAll(isHidden: false)
        letsGoButton.setTitle("LET'S GO", for: .normal)
        successPendingImageView.image = UIImage(named:"congratesTick")
        titleLabel.text = "Congratulations!"
        detailLabel.text = "Your profile has been created successfully.\nLet's set your availability so that dental offices can get to know about your timings."
    }
    
    func showUIForPending(){
        self.hideAll(isHidden: false)
        letsGoButton.setTitle("LET'S GO", for: .normal)
        successPendingImageView.image = UIImage(named:"pendingApproval")
        titleLabel.text = "Pending Approval"
        detailLabel.text = "Your profile has been sent for admin’s  approval. You can apply for jobs once your profile gets approved.\n\nIn the meantime, Lets set your availability so that dental offices can get to know about your timings."
    }
    
    @IBAction func letsGoButtonPressed(_ sender: Any) {
        if !isEmailVerified {
            verifyEmail(completionHandler: { (isVerified:Bool, message:String,error:NSError?) in
                if error == nil  {
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
            //print("Check with new email verify api")
        } else {
            goToCalendar()
        }
    }
    
    func showPendingCongrats(){
        self.isEmailVerified = true
        if UserManager.shared().activeUser.isJobSeekerVerified == true {
            // congrats UI
            self.showUIForCongrats()
        }
        else {
            // pending UI
             self.showUIForPending()
            
        }
    }
    
    func goToCalendar() {
        let calendarSetAvailabillityVC = UIStoryboard.calenderStoryBoard().instantiateViewController(type: DMCalendarSetAvailabillityVC.self)!
        calendarSetAvailabillityVC.fromJobSelection = true
        self.navigationController?.pushViewController(calendarSetAvailabillityVC, animated: true)
    }

}

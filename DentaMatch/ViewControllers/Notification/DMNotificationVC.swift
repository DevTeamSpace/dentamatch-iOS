//
//  DMNotificationVC.swift
//  DentaMatch
//
//  Created by Sanjay Kumar Yadav on 08/02/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit
enum UserNotificationType:Int {
    case acceptJob = 1
    case hired
    case jobCancellation
    case deleteJob
    case verifyDocuments
    case completeProfile
    case chatMessgae
    case other
}
class DMNotificationVC: DMBaseVC {
    @IBOutlet weak var notificationTableView: UITableView!
    var notificationList = [UserNotification]()

    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func setup() {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.notificationTableView.estimatedRowHeight = 76
        self.notificationTableView.register(UINib(nibName: "HiredJobNotificationTableCell", bundle: nil), forCellReuseIdentifier: "HiredJobNotificationTableCell")
        self.notificationTableView.register(UINib(nibName: "CommonTextNotificationTableCell", bundle: nil), forCellReuseIdentifier: "CommonTextNotificationTableCell")
        self.notificationTableView.register(UINib(nibName: "NotificationJobTypeTableCell", bundle: nil), forCellReuseIdentifier: "NotificationJobTypeTableCell")
        self.getNotificationList { (isSucess, error) in
            if isSucess! {
                self.notificationTableView.reloadData()
            }else{
                
            }
        }
    }
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

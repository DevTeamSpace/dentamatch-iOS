//
//  DMEditProfileVC.swift
//  DentaMatch
//
//  Created by Rajan Maheshwari on 17/01/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

class DMEditProfileVC: DMBaseVC {
    
    enum EditProfileOptions:Int {
        case profileHeader
        case dentalStateboard
        case experience
        case schooling
        case keySkills
        case affiliations
        case licenseNumber
    }
    
    @IBOutlet weak var editProfileTableView: UITableView!
    
    var dashBoardVC:TabBarVC?
    
    var license:License?

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        
        if let dashBoard = ((UIApplication.shared.delegate) as! AppDelegate).window?.rootViewController as? TabBarVC {
            dashBoardVC = dashBoard
        }

        self.userProfileAPI()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        dashBoardVC?.tabBar.alpha = 1.0
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIView.animate(withDuration: 0.5) {
            self.dashBoardVC?.tabBar.alpha = 0.0
        }
    }
    
    func setup() {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.editProfileTableView.register(UINib(nibName: "EditProfileHeaderTableCell", bundle: nil), forCellReuseIdentifier: "EditProfileHeaderTableCell")
        self.editProfileTableView.register(UINib(nibName: "SectionHeadingTableCell", bundle: nil), forCellReuseIdentifier: "SectionHeadingTableCell")
        self.editProfileTableView.register(UINib(nibName: "AddProfileOptionTableCell", bundle: nil), forCellReuseIdentifier: "AddProfileOptionTableCell")
        self.editProfileTableView.register(UINib(nibName: "EditLicenseTableCell", bundle: nil), forCellReuseIdentifier: "EditLicenseTableCell")
    }
    
    func openEditLicenseScreen() {
            self.performSegue(withIdentifier: Constants.StoryBoard.SegueIdentifier.goToEditLicense, sender: self)
    }
    
    func openEditPublicProfileScreen() {
        self.performSegue(withIdentifier: Constants.StoryBoard.SegueIdentifier.goToPublicProfile, sender: self)

    }

    func openSetttingScreen() {
        self.performSegue(withIdentifier: Constants.StoryBoard.SegueIdentifier.goToPublicProfile, sender: self)
        
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.StoryBoard.SegueIdentifier.goToEditLicense {
            let destinationVC:DMEditLicenseVC = segue.destination as! DMEditLicenseVC
            destinationVC.license = self.license
        } else if segue.identifier == Constants.StoryBoard.SegueIdentifier.goToPublicProfile {
            let destinationVC:DMPublicProfileVC = segue.destination as! DMPublicProfileVC
        }
    }
    

}

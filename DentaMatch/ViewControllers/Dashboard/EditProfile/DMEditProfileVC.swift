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
        case certifications
    }
    
    @IBOutlet weak var editProfileTableView: UITableView!
    
    var dashBoardVC:TabBarVC?
    
    var license:License?
    var affliations = [Affiliation]()
    var skills = [Skill]()
    var certifications = [Certification]()
    var dentalStateBoardURL = "test"

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
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.editProfileTableView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    func setup() {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.editProfileTableView.register(UINib(nibName: "EditProfileHeaderTableCell", bundle: nil), forCellReuseIdentifier: "EditProfileHeaderTableCell")
        self.editProfileTableView.register(UINib(nibName: "SectionHeadingTableCell", bundle: nil), forCellReuseIdentifier: "SectionHeadingTableCell")
        self.editProfileTableView.register(UINib(nibName: "AddProfileOptionTableCell", bundle: nil), forCellReuseIdentifier: "AddProfileOptionTableCell")
        self.editProfileTableView.register(UINib(nibName: "EditLicenseTableCell", bundle: nil), forCellReuseIdentifier: "EditLicenseTableCell")
        self.editProfileTableView.register(UINib(nibName: "EmptyCertificateTableViewCell", bundle: nil), forCellReuseIdentifier: "EmptyCertificateTableViewCell")
        self.editProfileTableView.register(UINib(nibName: "EditCertificateTableCell", bundle: nil), forCellReuseIdentifier: "EditCertificateTableCell")
        self.editProfileTableView.register(UINib(nibName: "EditProfileAffiliationBrickCell", bundle: nil), forCellReuseIdentifier: "EditProfileAffiliationBrickCell")
    }
    
    func openEditLicenseScreen() {
            self.performSegue(withIdentifier: Constants.StoryBoard.SegueIdentifier.goToEditLicense, sender: self)
    }
    
    func openEditPublicProfileScreen() {
        self.performSegue(withIdentifier: Constants.StoryBoard.SegueIdentifier.goToPublicProfile, sender: self)

    }

    func openSettingScreen() {
        self.performSegue(withIdentifier: Constants.StoryBoard.SegueIdentifier.goToSetting, sender: self)
        
    }
    
    func openAffiliationsScreen() {
        
    }
    
    func openCertificateScreen(sender:UIButton) {
        let editCertificateVC = UIStoryboard.dashBoardStoryBoard().instantiateViewController(type: DMEditCertificateVC.self)!
        editCertificateVC.certificate = certifications[sender.tag]
        self.navigationController?.pushViewController(editCertificateVC, animated: true)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.StoryBoard.SegueIdentifier.goToEditLicense {
            let destinationVC = segue.destination as! DMEditLicenseVC
            destinationVC.license = self.license
            destinationVC.hidesBottomBarWhenPushed = true
        } else if segue.identifier == Constants.StoryBoard.SegueIdentifier.goToPublicProfile {
            let destinationVC = segue.destination as! DMPublicProfileVC
            destinationVC.hidesBottomBarWhenPushed = true

        }else if segue.identifier == Constants.StoryBoard.SegueIdentifier.goToSetting
        {
            let destinationVC = segue.destination as! DMSettingVC
            destinationVC.hidesBottomBarWhenPushed = true

        }
    }
    

}

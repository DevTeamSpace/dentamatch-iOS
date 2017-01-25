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
    var affiliations = [Affiliation]()
    var skills = [Skill]()
    var certifications = [Certification]()
    var experiences = [ExperienceModel]()
    var dentalStateBoardURL = ""

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
        self.editProfileTableView.reloadData()
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    func setup() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateProfileScreen), name: NSNotification.Name(rawValue: "updateProfileScreen"), object: nil)
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.editProfileTableView.register(UINib(nibName: "EditProfileHeaderTableCell", bundle: nil), forCellReuseIdentifier: "EditProfileHeaderTableCell")
        self.editProfileTableView.register(UINib(nibName: "SectionHeadingTableCell", bundle: nil), forCellReuseIdentifier: "SectionHeadingTableCell")
        self.editProfileTableView.register(UINib(nibName: "AddProfileOptionTableCell", bundle: nil), forCellReuseIdentifier: "AddProfileOptionTableCell")
        self.editProfileTableView.register(UINib(nibName: "EditLicenseTableCell", bundle: nil), forCellReuseIdentifier: "EditLicenseTableCell")
        self.editProfileTableView.register(UINib(nibName: "EmptyCertificateTableViewCell", bundle: nil), forCellReuseIdentifier: "EmptyCertificateTableViewCell")
        self.editProfileTableView.register(UINib(nibName: "EditCertificateTableCell", bundle: nil), forCellReuseIdentifier: "EditCertificateTableCell")
        self.editProfileTableView.register(UINib(nibName: "EditProfileAffiliationBrickCell", bundle: nil), forCellReuseIdentifier: "EditProfileAffiliationBrickCell")
        self.editProfileTableView.register(UINib(nibName: "EditProfileSkillBrickCell", bundle: nil), forCellReuseIdentifier: "EditProfileSkillBrickCell")
        
        self.editProfileTableView.register(UINib(nibName: "EditProfileReferenceCell", bundle: nil), forCellReuseIdentifier: "EditProfileReferenceCell")
        self.editProfileTableView.register(UINib(nibName: "EditProfileExperienceCell", bundle: nil), forCellReuseIdentifier: "EditProfileExperienceCell")
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
        let affiliationVC = UIStoryboard.profileStoryBoard().instantiateViewController(type: DMAffiliationsVC.self)!
        affiliationVC.isEditMode = true
        affiliationVC.hidesBottomBarWhenPushed = true
        affiliationVC.selectedAffiliationsFromProfile = self.affiliations
        self.navigationController?.pushViewController(affiliationVC, animated: true)
    }
    
    func openSkillsScreen() {
        let skillsVC = UIStoryboard.profileStoryBoard().instantiateViewController(type: DMSkillsVC.self)!
        skillsVC.selectedSkills = self.skills
        skillsVC.isEditMode = true
        
        let selectSkillsVC = UIStoryboard.profileStoryBoard().instantiateViewController(type: DMSelectSkillsVC.self)!
        
        let sideMenu = SSASideMenu(contentViewController: skillsVC, rightMenuViewController: selectSkillsVC)
        sideMenu.panGestureEnabled = false
        sideMenu.delegate = skillsVC
        sideMenu.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(sideMenu, animated: true)
        

    }
    
    func openDentalStateBoardScreen(sender:UIButton) {
        let dentalStateboardVC = UIStoryboard.dashBoardStoryBoard().instantiateViewController(type: DMEditDentalStateBoardVC.self)!
        dentalStateboardVC.dentalStateBoardImageURL = self.dentalStateBoardURL
        dentalStateboardVC.hidesBottomBarWhenPushed = true
        dentalStateboardVC.isEditMode = true
        self.navigationController?.pushViewController(dentalStateboardVC, animated: true)
    }
    
    func openCertificateScreen(sender:UIButton) {
        let editCertificateVC = UIStoryboard.dashBoardStoryBoard().instantiateViewController(type: DMEditCertificateVC.self)!
        editCertificateVC.certificate = certifications[sender.tag]
        editCertificateVC.hidesBottomBarWhenPushed = true
        editCertificateVC.isEditMode = true
        self.navigationController?.pushViewController(editCertificateVC, animated: true)
    }
    
    func updateProfileScreen(userInfo:Notification) {
        let dict = userInfo.userInfo
        
        //Upload for affiliation
        if let affiliation = dict?["affiliations"] {
            self.affiliations = affiliation as! [Affiliation]
        }
        
        //Update for certificate
        if let certification = dict?["certification"] {
            let certificateObj = certification as! Certification
            for certificate in self.certifications {
                if certificateObj.certificationId == certificate.certificationId {
                    certificate.certificateImageURL = certificateObj.certificateImageURL
                }
            }
        }
        
        if let dentalStateBoardURL = dict?["dentalStateBoardImageURL"] {
            let url = dentalStateBoardURL as! String
            self.dentalStateBoardURL = url
        }
        self.editProfileTableView.reloadData()
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.StoryBoard.SegueIdentifier.goToEditLicense {
            let destinationVC = segue.destination as! DMEditLicenseVC
            destinationVC.license = self.license
            destinationVC.hidesBottomBarWhenPushed = true
        } else if segue.identifier == Constants.StoryBoard.SegueIdentifier.goToPublicProfile {
            let destinationVC = segue.destination as! DMPublicProfileVC
            destinationVC.hidesBottomBarWhenPushed = true
        } else if segue.identifier == Constants.StoryBoard.SegueIdentifier.goToSetting {
            let destinationVC = segue.destination as! DMSettingVC
            destinationVC.hidesBottomBarWhenPushed = true
        }
    }
}

//
//  DMEditProfileVC.swift
//  DentaMatch
//
//  Created by Rajan Maheshwari on 17/01/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

class DMEditProfileVC: DMBaseVC {
    enum EditProfileOptions: Int {
        case profileHeader
        case dentalStateboard
        case experience
        case schooling
        case keySkills
        case affiliations
        case licenseNumber
        case certifications
    }

    @IBOutlet var editProfileTableView: UITableView!

    var isJobSeekerVerified = ""
    var isProfileCompleted = ""
    var license: License?
    var affiliations = [Affiliation]()
    var skills = [Skill]()
    var schoolCategories = [SelectedSchool]()
    var certifications = [Certification]()
    var experiences = [ExperienceModel]()
    var dentalStateBoardURL = ""
    var jobTitles = [JobTitle]()
    var currentJobTitle: JobTitle!

    var popOverLabel: UILabel!
    var popOverView: UIView!
    var popover: Popover!
    var popoverOptions: [PopoverOption] = [
        .type(.down),
        .blackOverlayColor(UIColor(white: 0.0, alpha: 0.6)),
    ]
    
    weak var moduleOutput: DMEditProfileModuleOutput?

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        // To remove the top white line which came in iOS 11
        if #available(iOS 11.0, *) {
            editProfileTableView.contentInsetAdjustmentBehavior = .never
        }
        
//        self.userProfileAPI()
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        editProfileTableView.reloadData()
        userProfileAPI()
        navigationController?.setNavigationBarHidden(true, animated: true)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }

    func setup() {
        NotificationCenter.default.addObserver(self, selector: #selector(updateProfileScreen), name: .updateProfileScreen, object: nil)
       NotificationCenter.default.addObserver(self, selector: #selector(psuhRediectNotificationForProfile), name: .pushRedirectNotificationForProfile, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateBadgeCount), name: .updateBadgeCount, object: nil)
        navigationController?.setNavigationBarHidden(true, animated: true)
        editProfileTableView.register(UINib(nibName: "EditProfileHeaderTableCell", bundle: nil), forCellReuseIdentifier: "EditProfileHeaderTableCell")
        editProfileTableView.register(UINib(nibName: "SectionHeadingTableCell", bundle: nil), forCellReuseIdentifier: "SectionHeadingTableCell")
        editProfileTableView.register(UINib(nibName: "AddProfileOptionTableCell", bundle: nil), forCellReuseIdentifier: "AddProfileOptionTableCell")
        editProfileTableView.register(UINib(nibName: "EditLicenseTableCell", bundle: nil), forCellReuseIdentifier: "EditLicenseTableCell")
        editProfileTableView.register(UINib(nibName: "EditProfileSchoolCell", bundle: nil), forCellReuseIdentifier: "EditProfileSchoolCell")
        editProfileTableView.register(UINib(nibName: "EmptyCertificateTableViewCell", bundle: nil), forCellReuseIdentifier: "EmptyCertificateTableViewCell")
        editProfileTableView.register(UINib(nibName: "EditCertificateTableCell", bundle: nil), forCellReuseIdentifier: "EditCertificateTableCell")
        editProfileTableView.register(UINib(nibName: "EditProfileAffiliationBrickCell", bundle: nil), forCellReuseIdentifier: "EditProfileAffiliationBrickCell")
        editProfileTableView.register(UINib(nibName: "EditProfileSkillBrickCell", bundle: nil), forCellReuseIdentifier: "EditProfileSkillBrickCell")

        editProfileTableView.register(UINib(nibName: "EditProfileReferenceCell", bundle: nil), forCellReuseIdentifier: "EditProfileReferenceCell")
        editProfileTableView.register(UINib(nibName: "EditProfileExperienceCell", bundle: nil), forCellReuseIdentifier: "EditProfileExperienceCell")
        setupPopOver()
    }

    func setupPopOver() {
        popover = Popover(options: popoverOptions)
        popOverView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - 30, height: 96))
        popOverView.backgroundColor = UIColor.color(withHexCode: "fafafa")

        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        button.setTitle("GOT IT", for: .normal)
        button.setTitleColor(UIColor.color(withHexCode: "0480dc"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont.fontRegular(fontSize: 14.0)
        button.addTarget(self, action: #selector(gotItButtonPressed), for: .touchUpInside)

        popOverLabel = UILabel(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - 35, height: 40))
        popOverLabel.textColor = Constants.Color.textFieldTextColor
        popOverLabel.font = UIFont.fontRegular(fontSize: 14.0)
        popOverLabel.translatesAutoresizingMaskIntoConstraints = false
        popOverLabel.textAlignment = .center
        popOverLabel.text = "Your profile is pending admin’s approval. You will be able to apply for jobs once its approved."
        popOverLabel.numberOfLines = 3

        popOverLabel.center = popOverView.center
        popOverView.addSubview(popOverLabel)
        popOverView.addSubview(button)

        popOverLabel.topAnchor.constraint(equalTo: popOverView.topAnchor, constant: 18.0).isActive = true
        popOverLabel.centerXAnchor.constraint(equalTo: popOverView.centerXAnchor).isActive = true
        popOverLabel.leadingAnchor.constraint(equalTo: popOverView.leadingAnchor, constant: 6.0).isActive = true
        popOverLabel.trailingAnchor.constraint(equalTo: popOverView.trailingAnchor, constant: -6.0).isActive = true

        button.bottomAnchor.constraint(equalTo: popOverView.bottomAnchor, constant: -10.0).isActive = true
        button.trailingAnchor.constraint(equalTo: popOverView.trailingAnchor, constant: -10.0).isActive = true
    }
    
    @objc func updateBadgeCount () {
        let indexPath = IndexPath(item: 0, section: 0)
       editProfileTableView.reloadRows(at: [indexPath], with: .none)
    }

    @objc func gotItButtonPressed() {
        popover.dismiss()
    }

    @objc func statusButtonPressed() {
        if let cell = editProfileTableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? EditProfileHeaderTableCell {
            if  isJobSeekerVerified == "0" || isJobSeekerVerified == "2"  {
                popOverLabel.text = "Your profile is pending approval. Once we confirm your license, you’ll be able to apply for jobs."
                popover.show(popOverView, fromView: cell.statusButton) // Pending

            } else if isProfileCompleted == "0" {
                popOverLabel.text = "Your Profile is incomplete, please select the availability to be able to apply for jobs."
                popover.show(popOverView, fromView: cell.statusButton) // Needs Attention
            }
        }
    }

    @objc func psuhRediectNotificationForProfile(userInfo _: Notification) {
        navigationController?.popToRootViewController(animated: false)
        tabBarController?.selectedIndex = 4
        userProfileAPI()
    }

    @objc func openEditLicenseScreen(editMode: Bool = false) {
        assertionFailure("Removed da84dbd")
    }

    @objc func openEditPublicProfileScreen() {
        moduleOutput?.showEditProfile(jobTitles: jobTitles, selectedJob: JobTitle(jobTitle: currentJobTitle))
    }

    @objc func openSettingScreen() {
        moduleOutput?.showSettings()
    }

    @objc func openAffiliationsScreen() {
        moduleOutput?.showEditAffiliations(selectedAffiliations: affiliations, isEditMode: true)
    }

    @objc func openSchoolsScreen() {
        moduleOutput?.showEditStudy(selectedSchoolCategories: schoolCategories)
    }

    @objc func openSkillsScreen() {
        moduleOutput?.showEditSkills(skills: skills)
    }

    @objc func openDentalStateBoardScreen(isEditMode: Bool = true) {
        assertionFailure("Removed e38190f")
    }

    @objc func openWorkExperienceScreen() {
        moduleOutput?.showEditWorkExperience(jobTitles: jobTitles, isEditMode: true)
    }

    @objc func openCertificateScreen(sender: UIButton) {
        moduleOutput?.showEditCertificate(certificate: certifications[sender.tag], isEditMode: true)
    }

    @objc func updateProfileScreen(userInfo: Notification) {
        let dict = userInfo.userInfo

        if let license = dict?["license"] {
            self.license = license as? License
        }

        // For Work Experience
        if let experiences = dict?["workExperiences"]  as? [ExperienceModel] {
            self.experiences = experiences
        }

        // Upload for affiliation
        if let affiliation = dict?["affiliations"] as? [Affiliation]{
            affiliations = affiliation
        }

        // For Schools
        if let schools = dict?["schools"] as? [SelectedSchool]{
            schoolCategories = schools
        }

        // For Skills
        if let skills = dict?["skills"] as? [Skill]{
            self.skills = skills
        }

        // Update for certificate
        if let certification = dict?["certification"], let certificateObj = certification as? Certification {
            for certificate in certifications {
                if certificateObj.certificationId == certificate.certificationId {
                    certificate.certificateImageURL = certificateObj.certificateImageURL
                }
            }
        }

        if let dentalStateBoardURL = dict?["dentalStateBoardImageURL"], let url = dentalStateBoardURL as? String {
            self.dentalStateBoardURL = url
        }
        editProfileTableView.reloadData()
        userProfileAPI(checkForCompletion: true)
    }
}



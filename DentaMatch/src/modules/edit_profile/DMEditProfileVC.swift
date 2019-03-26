import UIKit

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

class DMEditProfileVC: DMBaseVC {
    @IBOutlet var editProfileTableView: UITableView!
    var popOverLabel: UILabel!
    var popOverView: UIView!
    var popover: Popover!
    var popoverOptions: [PopoverOption] = [
        .type(.down),
        .blackOverlayColor(UIColor(white: 0.0, alpha: 0.6)),
    ]
    
    var viewOutput: DMEditProfileViewOutput?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 11.0, *) {
            editProfileTableView.contentInsetAdjustmentBehavior = .never
        }
        
        setup()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        editProfileTableView.reloadData()
        viewOutput?.getUserProfile()
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
        
        let templateView = UIView(frame: CGRect(x: editProfileTableView.frame.minX, y: editProfileTableView.frame.minY - 500, width: editProfileTableView.frame.width, height: 500))
        templateView.backgroundColor = UIColor(red: 1.0 / 255.0, green: 44.0 / 255.0, blue: 108.0 / 255.0, alpha: 1)
        editProfileTableView.addSubview(templateView)
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
        guard let viewOutput = viewOutput else { return }
        if let cell = editProfileTableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? EditProfileHeaderTableCell {
            if  viewOutput.isJobSeekerVerified == "0" || viewOutput.isJobSeekerVerified == "2"  {
                popOverLabel.text = "Your profile is pending approval. Once we confirm your license, you’ll be able to apply for jobs."
                popover.show(popOverView, fromView: cell.statusButton) // Pending

            } else if viewOutput.isProfileCompleted == "0" {
                popOverLabel.text = "Your Profile is incomplete, please select the availability to be able to apply for jobs."
                popover.show(popOverView, fromView: cell.statusButton) // Needs Attention
            }
        }
    }

    @objc func psuhRediectNotificationForProfile(userInfo _: Notification) {
        navigationController?.popToRootViewController(animated: false)
        tabBarController?.selectedIndex = 4
        viewOutput?.getUserProfile()
    }

    @objc func openEditLicenseScreen(editMode: Bool = false) {
        assertionFailure("Removed da84dbd")
    }

    @objc func openEditPublicProfileScreen() {
        viewOutput?.openEditPublicProfileScreen()
    }

    @objc func openSettingScreen() {
        viewOutput?.openSettings()
    }

    @objc func openAffiliationsScreen() {
        viewOutput?.openAffiliationsScreen()
    }

    @objc func openSchoolsScreen() {
        viewOutput?.openSchoolsScreen()
    }

    @objc func openSkillsScreen() {
        viewOutput?.openSkillsScreen()
    }

    @objc func openWorkExperienceScreen() {
        viewOutput?.openWorkExperienceScreen()
    }

    @objc func openCertificateScreen(sender: UIButton) {
        viewOutput?.openCertificateScreen(index: sender.tag)
    }

    @objc func updateProfileScreen(userInfo: Notification) {
        viewOutput?.updateProfileScreen(dict: userInfo.userInfo)
    }
}

extension DMEditProfileVC: DMEditProfileViewInput {
    
    func reloadData() {
        editProfileTableView.reloadData()
    }
}



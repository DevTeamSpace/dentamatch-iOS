//
//  DMSkillsVC.swift
//  DentaMatch
//
//  Created by Rajan Maheshwari on 10/01/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

class DMSkillsVC: DMBaseVC {
    enum Skills: Int {
        case profileHeader
        case skills
        case other
    }

    let profileProgress: CGFloat = 0.65
    var skills = [Skill]()
    var otherSkill: Skill?
    var whiteView: UIView!

    @IBOutlet var skillsTableView: UITableView!

    var isEditMode = false
    var selectedSkills = [Skill]()

    // MARK: - View LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        getSkillListAPI()
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }

    // MARK: - Private Methods

    func setup() {
        whiteView = UIView(frame: CGRect(x: 0, y: 0, width: Utilities.ScreenSize.SCREEN_WIDTH, height: Utilities.ScreenSize.SCREEN_HEIGHT))
        whiteView.backgroundColor = UIColor.white
        view.addSubview(whiteView)
        whiteView.isHidden = true

        navigationItem.leftBarButtonItem = backBarButton()
        skillsTableView.register(UINib(nibName: "PhotoNameCell", bundle: nil), forCellReuseIdentifier: "PhotoNameCell")
        skillsTableView.register(UINib(nibName: "SectionHeadingTableCell", bundle: nil), forCellReuseIdentifier: "SectionHeadingTableCell")
        skillsTableView.register(UINib(nibName: "SkillsTableCell", bundle: nil), forCellReuseIdentifier: "SkillsTableCell")
        skillsTableView.register(UINib(nibName: "OtherSkillCell", bundle: nil), forCellReuseIdentifier: "OtherSkillCell")
    }

    // MARK: - IBActions

    @IBAction func nextButtonClicked(_: Any) {
        let params = prepareSkillUpdateData()
        guard let others = params["other"] as? [[String: AnyObject]], let skills = params["skills"] as? [String] else { return }
        if skills.count > 0 {
            updateSkillsAPI(params: params)
        } else {
            if others.count > 1 {
                updateSkillsAPI(params: params)
            } else if others.count == 1 {
                if otherSkill?.otherText == "" {
                    makeToast(toastString: "Please select atleast one skill")
                } else {
                    updateSkillsAPI(params: params)
                }
            } else {
                makeToast(toastString: "Please select atleast one skill")
            }
        }
    }

    func openAffiliationScreen() {
        guard let vc = DMAffiliationsInitializer.initialize() as? DMAffiliationsVC else { return }
        navigationController?.pushViewController(vc, animated: true)
    }

    @IBAction func backButtonPressed(_: Any) {
        _ = navigationController?.popViewController(animated: true)
    }
}

extension DMSkillsVC: SSASideMenuDelegate {
    func sideMenuWillShowMenuViewController(_: SSASideMenu, menuViewController _: UIViewController) {
        // side menu
        // TODO: - Will See
//        whiteView.isHidden = false
    }

    func sideMenuWillHideMenuViewController(_: SSASideMenu, menuViewController _: UIViewController) {
//        whiteView.isHidden = true
        if let selectedIndex = self.skillsTableView.indexPathForSelectedRow {
            skillsTableView.deselectRow(at: selectedIndex, animated: true)
        }
        skillsTableView.reloadData()
    }
}

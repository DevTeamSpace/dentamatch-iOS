//
//  DMEditSkillsVC.swift
//  DentaMatch
//
//  Created by Rajan Maheshwari on 26/01/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

class DMEditSkillsVC: DMBaseVC {
    enum Skills: Int {
        case skills
        case other
    }

    @IBOutlet var navigationView: UIView!

    @IBOutlet var skillsTableView: UITableView!
    @IBOutlet weak var customNavBarHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomSaveButtonConstraint: NSLayoutConstraint!

    var skills = [Skill]()
    var otherSkill: Skill?
    var selectedSkills = [Skill]()

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        getSkillListAPI()
    }

    func setup() {
        skillsTableView.register(UINib(nibName: "SkillsTableCell", bundle: nil), forCellReuseIdentifier: "SkillsTableCell")
        skillsTableView.register(UINib(nibName: "OtherSkillCell", bundle: nil), forCellReuseIdentifier: "OtherSkillCell")
        
        var bottomInset: CGFloat = 0
        
        if #available(iOS 11.0, *) {
            bottomInset = navigationController?.view.safeAreaInsets.bottom ?? 0
        }
        
        customNavBarHeightConstraint.constant = 44 + UIApplication.shared.statusBarFrame.height
        bottomSaveButtonConstraint.constant = -bottomInset
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }

    func updateProfileScreen() {
        selectedSkills.removeAll()
        for skillObj in skills {
            let selectedSubSkills = skillObj.subSkills.filter({ $0.isSelected == true })
            if selectedSubSkills.count > 0 {
                let skill = Skill()
                skill.skillId = skillObj.skillId
                skill.skillName = skillObj.skillName
                skill.subSkills = selectedSubSkills
                skill.isOther = skillObj.isOther
                skill.otherText = skillObj.otherText
                selectedSkills.append(skill)
            }
        }

        if let otherSkill = otherSkill {
            let skill = Skill()
            skill.skillId = otherSkill.skillId
            skill.skillName = otherSkill.skillName
            let subSkill = SubSkill()
            subSkill.subSkillName = otherSkill.otherText
            skill.subSkills = [subSkill]
            skill.isOther = otherSkill.isOther
            skill.otherText = otherSkill.otherText
            if !skill.otherText.isEmptyField {
                selectedSkills.append(skill)
            }
        }

        NotificationCenter.default.post(name: .updateProfileScreen, object: nil, userInfo: ["skills": self.selectedSkills])
    }

    @IBAction func backButtonPressed(_: Any) {
        _ = navigationController?.popViewController(animated: true)
    }

    @IBAction func saveButtonPressed(_: Any) {
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
            } else if others.count == 0 {
                makeToast(toastString: "Please select atleast one skill")
            }
        }
    }
}

extension DMEditSkillsVC: SSASideMenuDelegate {
    func sideMenuWillShowMenuViewController(_: SSASideMenu, menuViewController _: UIViewController) {
        // side menu
    }

    func sideMenuWillHideMenuViewController(_: SSASideMenu, menuViewController _: UIViewController) {
        //        whiteView.isHidden = true

        if let selectedIndex = self.skillsTableView.indexPathForSelectedRow {
            skillsTableView.deselectRow(at: selectedIndex, animated: true)
        }
        skillsTableView.reloadData()
    }
}

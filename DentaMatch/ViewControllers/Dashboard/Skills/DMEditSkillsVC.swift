//
//  DMEditSkillsVC.swift
//  DentaMatch
//
//  Created by Rajan Maheshwari on 26/01/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

class DMEditSkillsVC: DMBaseVC {

    enum Skills:Int {
        case skills
        case other
    }
    @IBOutlet weak var navigationView: UIView!
    
    @IBOutlet weak var skillsTableView: UITableView!
    
    var skills = [Skill]()
    var otherSkill:Skill?
    var selectedSkills = [Skill]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        self.getSkillListAPI()
    }
    
    func setup() {
        self.skillsTableView.register(UINib(nibName: "SkillsTableCell", bundle: nil), forCellReuseIdentifier: "SkillsTableCell")
        self.skillsTableView.register(UINib(nibName: "OtherSkillCell", bundle: nil), forCellReuseIdentifier: "OtherSkillCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
    }
    
    func updateProfileScreen() {
        self.selectedSkills.removeAll()
        for skillObj in skills {
            let selectedSubSkills  = skillObj.subSkills.filter({$0.isSelected == true})
            if selectedSubSkills.count > 0 {
                let skill = Skill()
                skill.skillId = skillObj.skillId
                skill.skillName = skillObj.skillName
                skill.subSkills = selectedSubSkills
                skill.isOther = skillObj.isOther
                skill.otherText = skillObj.otherText
                self.selectedSkills.append(skill)
            }
        }
        NotificationCenter.default.post(name: .updateProfileScreen, object: nil, userInfo: ["skills":self.selectedSkills])
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    @IBAction func saveButtonPressed(_ sender: Any) {
        let params  = prepareSkillUpdateData()
        let others = params["other"] as! [[String:AnyObject]]
        let skills = params["skills"] as! [String]
        
        if skills.count > 0 {
            self.updateSkillsAPI(params: params)
            
        } else {
            if others.count > 1 {
                self.updateSkillsAPI(params: params)
            } else if others.count == 1 {
                if otherSkill?.otherText == "" {
                    self.makeToast(toastString: "Please select atleast one skill")
                } else {
                    self.updateSkillsAPI(params: params)
                }
            }
        }
    }
}

extension DMEditSkillsVC: SSASideMenuDelegate {
    
    func sideMenuWillShowMenuViewController(_ sideMenu: SSASideMenu, menuViewController: UIViewController) {
        //side menu        
    }
    
    
    func sideMenuWillHideMenuViewController(_ sideMenu: SSASideMenu, menuViewController: UIViewController) {
        //        whiteView.isHidden = true
        
        if let selectedIndex = self.skillsTableView.indexPathForSelectedRow {
            self.skillsTableView.deselectRow(at: selectedIndex, animated: true)
        }
        self.skillsTableView.reloadData()
    }
}

//
//  DMSelectSkillsVC.swift
//  DentaMatch
//
//  Created by Rajan Maheshwari on 10/01/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

class DMSelectSkillsVC: UIViewController {

    @IBOutlet weak var subSkillTableView: UITableView!
    var skill:Skill?
    var subSkills = [SubSkill]()
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        NotificationCenter.default.addObserver(self, selector: #selector(getSubSkillData), name: NSNotification.Name(rawValue: "getSubSkillData"), object: nil)
        // Do any additional setup after loading the view.
    }
    
    func getSubSkillData(info:Notification) {
        let userInfo = info.userInfo
        skill = userInfo?["skill"] as? Skill
        subSkills.removeAll()
        subSkills = (skill?.subSkills)!
        self.subSkillTableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let skill = skill {
            subSkills.removeAll()
            subSkills = skill.subSkills
            self.subSkillTableView.reloadData()
        }
    }

    func setup() {
        self.subSkillTableView.register(UINib(nibName: "SubSkillCell", bundle: nil), forCellReuseIdentifier: "SubSkillCell")
        self.subSkillTableView.rowHeight = UITableViewAutomaticDimension
        self.subSkillTableView.estimatedRowHeight = 50.0
    }
    
}

extension DMSelectSkillsVC:UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return subSkills.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SubSkillCell") as! SubSkillCell
        cell.subSkillLabel.text = subSkills[indexPath.row].subSkillName
        if subSkills[indexPath.row].isSelected {
            cell.tickButton.setTitle(Constants.DesignFont.acceptTermsSelected, for: .normal)
//            cell.tickButton.setTitleColor(Constants.Color.textFieldColorSelected, for: .normal)
        } else {
            cell.tickButton.setTitle(Constants.DesignFont.acceptTermsDeSelected, for: .normal)
//            cell.tickButton.setTitleColor(Constants.Color.textFieldPlaceHolderColor, for: .normal)
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        subSkills[indexPath.row].isSelected = subSkills[indexPath.row].isSelected ? false: true
        self.subSkillTableView.reloadRows(at: [indexPath], with: .automatic)
    }
}

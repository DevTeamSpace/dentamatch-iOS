//
//  DMSelectSkillsVC.swift
//  DentaMatch
//
//  Created by Rajan Maheshwari on 10/01/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

class DMSelectSkillsVC: UIViewController {

    enum SubSkillOption:Int {
        case subSkill
        case other
    }
    
    @IBOutlet weak var subSkillTableView: UITableView!
    var skill:Skill?
    var subSkills = [SubSkill]()
    var subSkillWithoutOther = [SubSkill]()
    var otherSkill:SubSkill?
    var otherText = ""
    
    //MARK:- View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        NotificationCenter.default.addObserver(self, selector: #selector(getSubSkillData), name: NSNotification.Name(rawValue: "getSubSkillData"), object: nil)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let skill = skill {
            subSkills.removeAll()
            subSkills = skill.subSkills
            subSkillWithoutOther = subSkills.filter({$0.isOther == false})
            otherSkill = subSkills.filter({$0.isOther == true}).first
            subSkills = subSkillWithoutOther
            if let _ = otherSkill {
                subSkills.append(otherSkill!)
                self.otherText = (otherSkill?.otherText)!
                if self.otherText.isEmptyField {
                    self.otherSkill?.isSelected = false
                    self.otherSkill?.otherText = ""
                }
            }
            self.subSkillTableView.reloadData()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }

    //MARK:- Private Methods
    @objc func getSubSkillData(info:Notification) {
        let userInfo = info.userInfo
        skill = userInfo?["skill"] as? Skill
        subSkills.removeAll()
        subSkills = (skill?.subSkills)!
        self.subSkillTableView.reloadData()
    }
    
    func setup() {
        self.view.backgroundColor = UIColor.color(withHexCode: "0470C0")
        self.subSkillTableView.backgroundColor = UIColor.color(withHexCode: "0470C0")
        self.subSkillTableView.register(UINib(nibName: "SubSkillCell", bundle: nil), forCellReuseIdentifier: "SubSkillCell")
        self.subSkillTableView.register(UINib(nibName: "OtherSubSkillTableCell", bundle: nil), forCellReuseIdentifier: "OtherSubSkillTableCell")
        self.subSkillTableView.rowHeight = UITableViewAutomaticDimension
        self.subSkillTableView.estimatedRowHeight = 50.0
    }
}

extension DMSelectSkillsVC:UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if let _ = skill {
            return 2
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let subSkillOption = SubSkillOption(rawValue: section)!
        switch subSkillOption {
        case .subSkill:
            return subSkillWithoutOther.count
        case .other:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let subSkillOption = SubSkillOption(rawValue: indexPath.section)!
        
        switch subSkillOption {
        case .subSkill:
            return UITableViewAutomaticDimension
        case .other:
            var otherHeight = 0
            if let otherSkill = otherSkill {
                otherHeight = otherSkill.isSelected ? 120 : 50
            }
            return CGFloat(otherHeight)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let subSkillOption = SubSkillOption(rawValue: indexPath.section)!
        
        switch subSkillOption {
        case .subSkill:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SubSkillCell") as! SubSkillCell
            cell.subSkillLabel.text = subSkillWithoutOther[indexPath.row].subSkillName
            if subSkills[indexPath.row].isSelected {
                cell.tickButton.setTitle(Constants.DesignFont.acceptTermsSelected, for: .normal)
            } else {
                cell.tickButton.setTitle(Constants.DesignFont.acceptTermsDeSelected, for: .normal)
            }
            return cell
        case .other:
            let cell = tableView.dequeueReusableCell(withIdentifier: "OtherSubSkillTableCell") as! OtherSubSkillTableCell
            cell.otherTextView.text = otherSkill?.otherText
            if let _ = otherSkill {
                if (otherSkill?.isSelected)! {
                    cell.tickButton.setTitle(Constants.DesignFont.acceptTermsSelected, for: .normal)
                    cell.tickButton.setTitleColor(UIColor.white, for: .normal)
                } else {
                    cell.tickButton.setTitle(Constants.DesignFont.acceptTermsDeSelected, for: .normal)
                    cell.tickButton.setTitleColor(UIColor.white, for: .normal)
                    
                }
            }
            cell.otherTextView.delegate = self
            return cell
        }

    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.view.endEditing(true)
        let subSkillOption = SubSkillOption(rawValue: indexPath.section)!
        
        switch subSkillOption {
        case .subSkill:
            subSkills[indexPath.row].isSelected = subSkills[indexPath.row].isSelected ? false: true
            self.subSkillTableView.reloadRows(at: [indexPath], with: .automatic)
        case .other:
            if let _ = otherSkill {
                self.otherSkill?.isSelected = (self.otherSkill?.isSelected)! ? false : true
                self.otherSkill?.isOpenForOther = (self.otherSkill?.isOpenForOther)! ? false : true
                self.subSkillTableView.reloadRows(at: [indexPath], with: .automatic)
                DispatchQueue.main.async {
                    self.subSkillTableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
                }
            }
            
        }
    }
}

extension DMSelectSkillsVC : UITextViewDelegate {
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        self.subSkillTableView.contentInset =  UIEdgeInsetsMake(0, 0, 200, 0)
        DispatchQueue.main.async {
            self.subSkillTableView.scrollToRow(at: IndexPath(row: 0, section: 1), at: .bottom, animated: true)
        }
        return true
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        self.subSkillTableView.contentInset =  UIEdgeInsetsMake(0, 0, 0, 0)
        return true
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        self.otherText = textView.text.trim()
        otherSkill?.otherText = self.otherText
    }
}

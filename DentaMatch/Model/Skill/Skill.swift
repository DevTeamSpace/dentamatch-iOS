//
//  Skill.swift
//  DentaMatch
//
//  Created by Rajan Maheshwari on 12/01/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit
import SwiftyJSON

class Skill: NSObject {

    var skillId = ""
    var skillName = ""
    var subSkills = [SubSkill]()
    
    override init () {
    }
    
    init(skills:JSON,subSkills:[SubSkill]) {
        self.skillId = skills["id"].stringValue
        self.skillName = skills["skillName"].stringValue
        self.subSkills = subSkills
    }
}

class SubSkill:NSObject {
    var subSkillId = ""
    var subSkillName = ""
    var isSelected = false
    var isOther = false
    var isOpenForOther = false
    var otherText = ""
    
    override init() {
    }
    
    init(subSkill:JSON) {
        self.subSkillId = subSkill[Constants.ServerKey.id].stringValue
        self.subSkillName = subSkill[Constants.ServerKey.skillName].stringValue
        self.isSelected = subSkill[Constants.ServerKey.isSkillSelected].boolValue
        if subSkill[Constants.ServerKey.skillName].stringValue.lowercased() == "Other".lowercased() {
            self.isOther = true
            self.otherText = subSkill[Constants.ServerKey.otherSkill].stringValue
        }
    }
}

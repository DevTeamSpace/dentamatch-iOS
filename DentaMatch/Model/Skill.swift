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
    
    override init() {
    }
    
    init(subSkill:JSON) {
        self.subSkillId = subSkill[Constants.ServerKey.id].stringValue
        self.subSkillName = subSkill[Constants.ServerKey.skillName].stringValue
        self.isSelected = subSkill[Constants.ServerKey.isSkillSelected].boolValue
    }
}

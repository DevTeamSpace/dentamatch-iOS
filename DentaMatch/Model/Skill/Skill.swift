//
//  Skill.swift
//  DentaMatch
//
//  Created by Rajan Maheshwari on 12/01/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import SwiftyJSON
import UIKit

class Skill: NSObject {
    var skillId = ""
    var skillName = ""
    var isOther = false
    var otherText = ""
    var subSkills = [SubSkill]()

    override init() {
        // for empty object
    }

    init(skills: JSON, subSkills: [SubSkill]) {
        skillId = skills[Constants.ServerKey.id].stringValue
        skillName = skills[Constants.ServerKey.skillName].stringValue
        if skills[Constants.ServerKey.skillName].stringValue.lowercased().trim() == "other" || skills[Constants.ServerKey.skillName].stringValue.lowercased().trim() == "Other" {
            isOther = true
            otherText = skills[Constants.ServerKey.otherSkill].stringValue
        }
        self.subSkills = subSkills
    }
}

class SubSkill: NSObject {
    var subSkillId = ""
    var subSkillName = ""
    var isSelected = false
    var isOther = false
    var isOpenForOther = false
    var otherText = ""

    override init() {
        // for empty object
    }

    init(subSkill: JSON) {
        subSkillId = subSkill[Constants.ServerKey.id].stringValue
        subSkillName = subSkill[Constants.ServerKey.skillName].stringValue
        isSelected = subSkill[Constants.ServerKey.isSkillSelected].boolValue
        if subSkill[Constants.ServerKey.skillName].stringValue.lowercased().trim() == "Other" || subSkill[Constants.ServerKey.skillName].stringValue.lowercased().trim() == "other" {
            isOther = true
            otherText = subSkill[Constants.ServerKey.otherSkill].stringValue
        }
    }
}

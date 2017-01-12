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
    
    init(skills:JSON) {
    }
}


class SubSkill:NSObject {
    var subSkillId = ""
    var subSkillName = ""
}

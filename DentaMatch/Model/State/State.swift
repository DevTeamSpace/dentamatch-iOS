//
//  State.swift
//  DentaMatch
//
//  Created by Prashant Gautam on 01/11/18.
//  Copyright © 2018 Appster. All rights reserved.
//

import Foundation
import SwiftyJSON
class State: NSObject {
    var stateId: Int?
    var stateName: String!
    var isActive: Int?
    var isSelected: Bool = false
    init(_ state: JSON) {
        stateId = state["stateId"].intValue
        isActive = state["isActive"].intValue
        stateName = state["stateName"].stringValue
    }
}

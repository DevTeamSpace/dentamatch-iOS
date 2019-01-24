//
//  MixpanelOperations.swift
//  DentaMatch
//
//  Created by Sanjay Kumar Yadav on 07/03/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import Mixpanel
import UIKit
class MixpanelOperations: NSObject {
    
    class func startSessionForMixpanelWithToken() {
        if ConfigurationManager.sharedManager().trackingEnabled() {
            Mixpanel.initialize(token: ConfigurationManager.sharedManager().analyticsKey())
        }
    }

    class func registerMixpanelUser() {
        if ConfigurationManager.sharedManager().trackingEnabled() {
            
            let dictForUser: [String: MixpanelType] = [ "userID": UserManager.shared().activeUser.userId,
                                                        "email": UserManager.shared().activeUser.email,
                                                        "Name": UserManager.shared().activeUser.fullName() ?? "",
                                                        "Time": Date() ]
            
            Mixpanel.mainInstance().identify(distinctId: UserManager.shared().activeUser.userId)
            Mixpanel.mainInstance().people.set(properties: dictForUser)
            Mixpanel.mainInstance().registerSuperProperties(dictForUser)
        }
    }

    class func manageMixpanelUserIdentity() {
        if ConfigurationManager.sharedManager().trackingEnabled() {
            
            let dictForUser: [String: MixpanelType] = [ "userID": UserManager.shared().activeUser.userId,
                                                        "email": UserManager.shared().activeUser.email,
                                                        "Name": UserManager.shared().activeUser.fullName() ?? "",
                                                        "Time": Date() ]
            
            Mixpanel.mainInstance().identify(distinctId: UserManager.shared().activeUser.userId)
            Mixpanel.mainInstance().registerSuperProperties(dictForUser)
        }
    }

    class func trackMixpanelEvent(eventName: String) {
        if ConfigurationManager.sharedManager().trackingEnabled() {
            
            Mixpanel.mainInstance().track(event: eventName)
        }
    }

    class func trackMixpanelEventWithProperties(eventName: String, dict: [String: Any]) {
        if ConfigurationManager.sharedManager().trackingEnabled() {
            
            Mixpanel.mainInstance().track(event: eventName, properties: dict as? [String: MixpanelType])
        }
    }

    class func mixpanepanelLogout() {
        if ConfigurationManager.sharedManager().trackingEnabled() {
            Mixpanel.mainInstance().track(event: "Logout")
        }
    }
}

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
            Mixpanel.sharedInstance(withToken: ConfigurationManager.sharedManager().analyticsKey())
        }
    }

    class func registerMixpanelUser() {
        if ConfigurationManager.sharedManager().trackingEnabled() {
            let dictForUser = ["userID": UserManager.shared().activeUser.userId!, "email": UserManager.shared().activeUser.email!, "Name": UserManager.shared().activeUser.fullName()!, "Time": NSDate()] as [String: Any]
            Mixpanel.sharedInstance().identify(UserManager.shared().activeUser.userId!)
            Mixpanel.sharedInstance().people.set(dictForUser)
            Mixpanel.sharedInstance().registerSuperProperties(dictForUser)
        }
    }

    class func manageMixpanelUserIdentity() {
        if ConfigurationManager.sharedManager().trackingEnabled() {
            let dictForUser = ["userID": UserManager.shared().activeUser.userId!, "email": UserManager.shared().activeUser.email!, "Name": UserManager.shared().activeUser.fullName()!, "Time": NSDate()] as [String: Any]
            Mixpanel.sharedInstance().identify(UserManager.shared().activeUser.userId!)
            Mixpanel.sharedInstance().registerSuperProperties(dictForUser)
        }
    }

    class func trackMixpanelEvent(eventName: String) {
        if ConfigurationManager.sharedManager().trackingEnabled() {
            Mixpanel.sharedInstance().track(eventName)
        }
    }

    class func trackMixpanelEventWithProperties(eventName: String, dict: NSDictionary) {
        if ConfigurationManager.sharedManager().trackingEnabled() {
            Mixpanel.sharedInstance().track(eventName, properties: dict as [NSObject: AnyObject])
        }
    }

    class func mixpanepanelLogout() {
        if ConfigurationManager.sharedManager().trackingEnabled() {
            Mixpanel.sharedInstance().track("Logout")
//            Mixpanel.sharedInstance().reset()
        }
    }
}

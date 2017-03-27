//
//  MixpanelOperations.swift
//  DentaMatch
//
//  Created by Sanjay Kumar Yadav on 07/03/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit
import Mixpanel
class MixpanelOperations: NSObject {
    class func startSessionForMixpanelWithToken()
    {
        if ConfigurationManager.sharedManager.isAnalyticsTrackingEnabled() {
            Mixpanel.sharedInstance(withToken: ConfigurationManager.sharedManager.mixpanelToken())
        }
    }
    
    class func registerMixpanelUser()
    {
        if ConfigurationManager.sharedManager.isAnalyticsTrackingEnabled() {
            let dictForUser  = ["userID":UserManager.shared().activeUser.userId,"email":UserManager.shared().activeUser.email,"Name":UserManager.shared().activeUser.userName,"Time":NSDate()] as [String : Any]
            Mixpanel.sharedInstance().people.set(dictForUser)
        }
        
    }
    
    class func manageMixpanelUserIdentity(){
        if ConfigurationManager.sharedManager.isAnalyticsTrackingEnabled() {
            let dictForUser  = ["userID":UserManager.shared().activeUser.userId,"email":UserManager.shared().activeUser.email,"Name":UserManager.shared().activeUser.userName,"Time":NSDate()] as [String : Any]
            Mixpanel.sharedInstance().identify(UserManager.shared().activeUser.userId)
            Mixpanel.sharedInstance().registerSuperProperties(dictForUser)
        }
    }
    
    class func trackMixpanelEvent(eventName:String)  {
        if ConfigurationManager.sharedManager.isAnalyticsTrackingEnabled() {
            Mixpanel.sharedInstance().track(eventName)
        }
    }
    
    class func trackMixpanelEventWithProperties(eventName:String,dict:NSDictionary) {
        if ConfigurationManager.sharedManager.isAnalyticsTrackingEnabled() {
            Mixpanel.sharedInstance().track(eventName, properties: dict as [NSObject : AnyObject])
        }
    }
    
    class func mixpanepanelLogout() {
        if ConfigurationManager.sharedManager.isAnalyticsTrackingEnabled() {
            Mixpanel.sharedInstance().reset()
        }
    }
}

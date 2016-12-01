//
//  ConfigurationManager.swift
//  DentaMatch
//
//  Created by Rajan Maheshwari on 12/10/16.
//  Copyright © 2016 Appster. All rights reserved.
//

import Foundation
import UIKit

let kEnvironmentsPlist:NSString? = "Environments"
let kConfigurationKey:NSString? = "ActiveConfiguration"
let kAPIEndpointKey:NSString? = "APIEndPoint"
let kLoggingEnabledKey:NSString? = "LoggingEnabled"
let kAnalyticsTrackingEnabled:NSString? = "AnalyticsTrackingEnabled"

class ConfigurationManager:NSObject {
    
    var environment : NSDictionary?
    
    //Singleton Method
    
    static let sharedManager: ConfigurationManager = {
        let instance = ConfigurationManager()
        // setup code
        return instance
    }()
       
    override init() {
        super.init()
        initialize()
    }
    
    // Private method
    
    func initialize ()   {
        
        var environments: NSDictionary?
        if let envsPlistPath = Bundle.main.path(forResource: "Environments", ofType: "plist") {
            environments = NSDictionary(contentsOfFile: envsPlistPath)
        }
        self.environment = environments!.object(forKey: currentConfiguration()) as? NSDictionary
        if self.environment == nil {
            assertionFailure(NSLocalizedString("Unable to load application configuration", comment: "Unable to load application configuration"))
        }
    }
    
    // currentConfiguration
    
    func currentConfiguration () -> String   {
        let configuration = Bundle.main.infoDictionary?[kConfigurationKey! as String] as? String
        return configuration!
    }
    
    // APIEndpoint
    
    func APIEndpoint () -> String  {
        let configuration = self.environment![kAPIEndpointKey!]
        return (configuration)! as! String
    }
    
    // isLoggingEnabled
    
    func isLoggingEnabled () -> Bool  {
        
        let configuration = self.environment![kLoggingEnabledKey!]
        return (configuration)! as! Bool
    }
    
    // isAnalyticsTrackingEnabled
    
    func isAnalyticsTrackingEnabled () -> String  {
        
        let configuration = self.environment![kAnalyticsTrackingEnabled!]
        return (configuration)! as! String
    }
    
    func applicationName()->String{
        let bundleDict = Bundle.main.infoDictionary! as NSDictionary
        return bundleDict.object(forKey: "CFBundleName") as! String
    }
}

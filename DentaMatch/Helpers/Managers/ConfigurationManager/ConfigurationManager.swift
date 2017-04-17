//
//  ConfigurationManager.swift
//
//  Created by Arvind Singh on 07/04/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

final class ConfigurationManager: NSObject {
    
    /*
     Open your Project Build Settings and search for “Swift Compiler – Custom Flags” … “Other Swift Flags”.
     Add “-DDEVELOPMENT” to the Debug section
     Add “-DQA” to the QA section
     Add “-DSTAGING” to the Staging section
     Add “-DPRODUCTION” to the Release section
     */
    fileprivate enum AppEnvironment: String {
        case development = "Development"
        case qA = "QA"
        case staging = "Staging"
        case production = "Production"
    }
    
    fileprivate struct AppConfiguration {
        var apiEndPoint: String
        var socketEndPoint:String
        var loggingEnabled: Bool
        
        var analyticsKey: String
        var trackingEnabled: Bool
        
        var environment: AppEnvironment
    }

    
    fileprivate var activeConfiguration: AppConfiguration!
    

    // MARK: - Singleton Instance
    private static let _sharedManager = ConfigurationManager()
    
    class func sharedManager() -> ConfigurationManager {
        return _sharedManager
    }
    
    private override init() {
        super.init()
        
        // Load application selected environment and its configuration
        if let environment = self.currentEnvironment() {
            
            self.activeConfiguration = self.configuration(environment: environment)
            
            if self.activeConfiguration == nil {
                assertionFailure(NSLocalizedString("Unable to load application configuration", comment: "Unable to load application configuration"))
            }
        } else {
            assertionFailure(NSLocalizedString("Unable to load application flags", comment: "Unable to load application flags"))
        }
    }
    
    private func currentEnvironment() -> AppEnvironment? {
        
        #if QA
            return AppEnvironment.qA
        #elseif STAGING
            return AppEnvironment.staging
        #elseif PRODUCTION
            return AppEnvironment.production
        #else // Default configuration DEVELOPMENT
            return AppEnvironment.development
        #endif
        
        /*let environment = Bundle.main.infoDictionary?["ActiveConfiguration"] as? String
         return environment*/
    }
    
    /**
     Returns application active configuration
     
     - parameter environment: An application selected environment
     
     - returns: An application configuration structure based on selected environment
     */
    private func configuration(environment: AppEnvironment) -> AppConfiguration {
        
        switch environment {
        case .development:
            return debugConfiguration()
        case .qA:
            return qaConfiguration()
        case .staging:
            return stagingConfiguration()
        case .production:
            return productionConfiguration()
        }
    }
    
    private func debugConfiguration() -> AppConfiguration {
        
        return AppConfiguration(apiEndPoint: "http://dev.dentamatch.co/api/",
                                socketEndPoint: "",
                                loggingEnabled: true,
                                analyticsKey: "baeda2003ca1585a7828ce1d02833836",
                                trackingEnabled: false,
                                environment: .development)
    }
    
    //TODO: Please change the key values
    private func qaConfiguration() -> AppConfiguration {
        
        return AppConfiguration(apiEndPoint: "https://qa.dentamatch.co/api/",
                                socketEndPoint: "https://qanode.dentamatch.co:8443",
                                loggingEnabled: true,
                                analyticsKey: "baeda2003ca1585a7828ce1d02833836",
                                trackingEnabled: false,
                                environment: .qA)
    }
    
    //TODO: Please change the key values
    private func stagingConfiguration() -> AppConfiguration {
        
        return AppConfiguration(apiEndPoint: "https://staging.dentamatch.co/api/",
                                socketEndPoint: "https://staging.dentamatch.co:8443",
                                loggingEnabled: true,
                                analyticsKey: "3fd78d535c8e6d65ade83460a9272f66",
                                trackingEnabled: true,
                                environment: .staging)
    }
    
    //TODO: Please change the key values
    private func productionConfiguration() -> AppConfiguration {
        
        return AppConfiguration(apiEndPoint: "https://production",
                                socketEndPoint: "",
                                loggingEnabled: false,
                                analyticsKey: "3fd78d535c8e6d65ade83460a9272f66",
                                trackingEnabled: true,
                                environment: .production)
    }
}

extension ConfigurationManager {
    
    // MARK: - Public Methods
    
    func applicationEnvironment() -> String {
        return self.activeConfiguration.environment.rawValue
    }
    
    func socketEndPoint() -> String {
        return self.activeConfiguration.socketEndPoint
    }
    
    func applicationEndPoint() -> String {
        return self.activeConfiguration.apiEndPoint
    }
    
    func loggingEnabled() -> Bool {
        return self.activeConfiguration.loggingEnabled
    }
    
    func analyticsKey() -> String {
        return self.activeConfiguration.analyticsKey
    }
    
    func trackingEnabled() -> Bool {
        return self.activeConfiguration.trackingEnabled
    }
}

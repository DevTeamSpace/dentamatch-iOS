//
//  ConfigurationManager.swift
//   DentaMatch

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
        var socketEndPoint: String
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
            activeConfiguration = configuration(environment: environment)

            if activeConfiguration == nil {
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

        /* let environment = Bundle.main.infoDictionary?["ActiveConfiguration"] as? String
         return environment */
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
        return AppConfiguration(apiEndPoint: "https://dev.dentamatch.co/api/v1/",
                                socketEndPoint: "https://dev.dentamatch.co:3000",
                                loggingEnabled: true,
                                analyticsKey: "baeda2003ca1585a7828ce1d02833836",
                                trackingEnabled: false,
                                environment: .development)
        /*apiEndPoint: "https://dev.dentamatch.co/api/v1/",
        socketEndPoint: "http://dev.dentamatch.co:3000",*/
    }

    // TODO: Please change the key values
    private func qaConfiguration() -> AppConfiguration {
        return AppConfiguration(apiEndPoint: "https://qa.dentamatch.co/api/v1/",
                                socketEndPoint: "https://qanode.dentamatch.co:8443",
                                loggingEnabled: true,
                                analyticsKey: "baeda2003ca1585a7828ce1d02833836",
                                trackingEnabled: false,
                                environment: .qA)
    }

    // TODO: Please change the key values
    private func stagingConfiguration() -> AppConfiguration {
        return AppConfiguration(apiEndPoint: "https://staging.dentamatch.co/api/v1/",
                                socketEndPoint: "https://staging.dentamatch.co:8443",
                                loggingEnabled: true,
                                analyticsKey: "3fd78d535c8e6d65ade83460a9272f66",
                                trackingEnabled: true,
                                environment: .staging)
    }

    // TODO: Please change the key values
    private func productionConfiguration() -> AppConfiguration {
        return AppConfiguration(apiEndPoint: "https://dentamatch.co/api/v1/",
                                socketEndPoint: "https://dentamatch.co:8443",
                                loggingEnabled: false,
                                analyticsKey: "3fd78d535c8e6d65ade83460a9272f66",
                                trackingEnabled: true,
                                environment: .production)
    }
}

extension ConfigurationManager {

    // MARK: - Public Methods

    func applicationEnvironment() -> String {
        return activeConfiguration.environment.rawValue
    }

    func socketEndPoint() -> String {
        return activeConfiguration.socketEndPoint
    }

    func applicationEndPoint() -> String {
        return activeConfiguration.apiEndPoint
    }

    func loggingEnabled() -> Bool {
        return activeConfiguration.loggingEnabled
    }

    func analyticsKey() -> String {
        return activeConfiguration.analyticsKey
    }

    func trackingEnabled() -> Bool {
        return activeConfiguration.trackingEnabled
    }
}

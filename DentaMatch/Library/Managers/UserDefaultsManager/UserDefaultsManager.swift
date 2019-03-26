//
//  UserDefaults.swift
//  DentaMatch
//
//  Created by Rajan Maheshwari on 12/10/16.
//  Copyright © 2016 Appster. All rights reserved.
//

import Foundation
import UIKit

let SEARCH_PARAMETR_KEY = "searchParameter"

class UserDefaultsManager: NSObject {
    static let sharedInstance = UserDefaultsManager()

    var isLoggedIn: Bool {
        get {
            if kUserDefaults.value(forKey: Constants.UserDefaultsKey.isLoggedIn) != nil {
                return kUserDefaults.value(forKey: Constants.UserDefaultsKey.isLoggedIn) as? Bool ?? false
            }
            // Default is not logged in
            return false
        }
        set {
            kUserDefaults.setValue(newValue, forKey: Constants.UserDefaultsKey.isLoggedIn)
            kUserDefaults.synchronize()
        }
    }

    var isLoggedOut: Bool {
        get {
            if kUserDefaults.value(forKey: Constants.UserDefaultsKey.isLoggedOut) != nil {
                return kUserDefaults.value(forKey: Constants.UserDefaultsKey.isLoggedOut) as? Bool ?? false
            }
            return false
        }
        set {
            kUserDefaults.setValue(newValue, forKey: Constants.UserDefaultsKey.isLoggedOut)
            kUserDefaults.synchronize()
        }
    }

    var isOnBoardingDone: Bool {
        get {
            if kUserDefaults.value(forKey: Constants.UserDefaultsKey.isOnBoardingDone) != nil {
                return kUserDefaults.value(forKey: Constants.UserDefaultsKey.isOnBoardingDone)  as? Bool ?? false
            }
            return false
        }
        set {
            kUserDefaults.setValue(newValue, forKey: Constants.UserDefaultsKey.isOnBoardingDone)
            kUserDefaults.synchronize()
        }
    }

    var isHistoryRetrieved: Bool {
        get {
            if kUserDefaults.value(forKey: Constants.UserDefaultsKey.isHistoryRetrieved) != nil {
                return kUserDefaults.value(forKey: Constants.UserDefaultsKey.isHistoryRetrieved) as? Bool ?? false
            }
            return false
        }
        set {
            kUserDefaults.setValue(newValue, forKey: Constants.UserDefaultsKey.isHistoryRetrieved)
            kUserDefaults.synchronize()
        }
    }

    var isProfileSkipped: Bool {
        get {
            if kUserDefaults.value(forKey: Constants.UserDefaultsKey.isProfileSkipped) != nil {
                return kUserDefaults.value(forKey: Constants.UserDefaultsKey.isProfileSkipped) as? Bool ?? false
            }
            return false
        }
        set {
            kUserDefaults.setValue(newValue, forKey: Constants.UserDefaultsKey.isProfileSkipped)
            kUserDefaults.synchronize()
        }
    }

    var isProfileCompleted: Bool {
        get {
            if kUserDefaults.value(forKey: Constants.UserDefaultsKey.isProfileCompleted) != nil {
                return kUserDefaults.value(forKey: Constants.UserDefaultsKey.isProfileCompleted) as? Bool ?? false
            }
            return false
        }
        set {
            kUserDefaults.setValue(newValue, forKey: Constants.UserDefaultsKey.isProfileCompleted)
            kUserDefaults.synchronize()
        }
    }

    var deviceToken: String {
        get {
            if kUserDefaults.value(forKey: Constants.UserDefaultsKey.deviceToken) != nil {
                return kUserDefaults.value(forKey: Constants.UserDefaultsKey.deviceToken) as? String ?? ""
            }
            return ""
        }
        set {
            kUserDefaults.setValue(newValue, forKey: Constants.UserDefaultsKey.deviceToken)
            kUserDefaults.synchronize()
        }
    }

    var accessToken: String {
        get {
            if kUserDefaults.value(forKey: Constants.UserDefaultsKey.accessToken) != nil {
                return kUserDefaults.value(forKey: Constants.UserDefaultsKey.accessToken) as? String ?? ""
            }
            return ""
        }
        set {
            kUserDefaults.setValue(newValue, forKey: Constants.UserDefaultsKey.accessToken)
            kUserDefaults.synchronize()
        }
    }

    var profileImageURL: String {
        get {
            if kUserDefaults.value(forKey: Constants.UserDefaultsKey.profileImageURL) != nil {
                return kUserDefaults.value(forKey: Constants.UserDefaultsKey.profileImageURL) as? String ?? ""
            }
            return ""
        }
        set {
            kUserDefaults.setValue(newValue, forKey: Constants.UserDefaultsKey.profileImageURL)
            kUserDefaults.synchronize()
        }
    }

    var licenseImageURL: String {
        get {
            if kUserDefaults.value(forKey: Constants.UserDefaultsKey.licenseImageURL) != nil {
                return kUserDefaults.value(forKey: Constants.UserDefaultsKey.licenseImageURL) as? String ?? ""
            }
            return ""
        }
        set {
            kUserDefaults.setValue(newValue, forKey: Constants.UserDefaultsKey.licenseImageURL)
            kUserDefaults.synchronize()
        }
    }

    func clearCache() {
        let tempDeviceToken = UserDefaultsManager.sharedInstance.deviceToken
        let tempOnboardingCheck = UserDefaultsManager.sharedInstance.isOnBoardingDone
        UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
        UserDefaultsManager.sharedInstance.deviceToken = tempDeviceToken
        UserDefaultsManager.sharedInstance.isOnBoardingDone = tempOnboardingCheck
    }

    // Load last searched parameter user data, if any
    func loadSearchParameter() -> [String: AnyObject]? {
        if let decodedUser = kUserDefaults.object(forKey: SEARCH_PARAMETR_KEY) as? Data {
            let searchParamter = NSKeyedUnarchiver.unarchiveObject(with: decodedUser)
            return searchParamter as? [String: AnyObject]
        }
        return nil
    }

    // Save SearchParameter
    func saveSearchParameter(seachParam: Any) {
        kUserDefaults.set(NSKeyedArchiver.archivedData(withRootObject: seachParam) as Any?, forKey: SEARCH_PARAMETR_KEY)
        kUserDefaults.synchronize()
    }

    // Delete Search Parameter
    func deleteSearchParameter() {
        // remove Search Parameter from storage
        kUserDefaults.removeObject(forKey: SEARCH_PARAMETR_KEY)
        // free user object memory
        kUserDefaults.synchronize()
    }
}

//
//  UIDevice.swift
//
//  Created by Arvind Singh on 13/06/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import Foundation
import UIKit

extension UIDevice {

    // MARK: API helper methods
    var iPhone: Bool {
        return UIDevice().userInterfaceIdiom == .phone
    }

    enum ScreenType: String {
        case iPhone4
        case iPhone5
        case iPhone6
        case iPhone6Plus
        case iPhoneX
        case unknown
    }

    var screenType: ScreenType {
        guard iPhone else { return .unknown }
        switch UIScreen.main.nativeBounds.height {
        case 960:
            return .iPhone4
        case 1136:
            return .iPhone5
        case 1334:
            return .iPhone6
        case 1920:
            return .iPhone6Plus
        case 2208:
            return .iPhone6Plus
        case 2436:
            return .iPhoneX
        default:
            return .unknown
        }
    }

    public class func deviceID() -> String {

        if let deviceID = UserDefaults.objectForKey("deviceID") {
            return deviceID as! String
        } else {
            let deviceID = UIDevice.current.identifierForVendor?.uuidString ?? ""
            UserDefaults.setObject(deviceID as AnyObject?, forKey: "deviceID")
            return deviceID
        }
    }

    public class func deviceInfo() -> [String: String] {

        var deviceInfo = [String: String]()
        deviceInfo["deviceID"] = deviceID()
        deviceInfo["deviceType"] = "iOS"
        return deviceInfo
    }

    /**
     Detect that the app is running on a jailbroken device or not

     - returns: bool value for jailbroken device or not
     */
    public class func isDeviceJailbroken() -> Bool {
        #if arch(i386) || arch(x86_64)
            return false
        #else
            let fileManager = FileManager.default

            if (fileManager.fileExists(atPath: "/bin/bash") ||
                fileManager.fileExists(atPath: "/usr/sbin/sshd") ||
                fileManager.fileExists(atPath: "/etc/apt")) ||
                fileManager.fileExists(atPath: "/private/var/lib/apt/") ||
                fileManager.fileExists(atPath: "/Applications/Cydia.app") ||
                fileManager.fileExists(atPath: "/Library/MobileSubstrate/MobileSubstrate.dylib") {
                return true
            } else {
                return false
            }
        #endif
    }
}

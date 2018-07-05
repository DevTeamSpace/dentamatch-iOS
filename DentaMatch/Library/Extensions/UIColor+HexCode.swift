//
//  UIColor+HexCode.swift
//  DentaMatch
//
//  Created by Rajan Maheshwari on 12/10/16.
//  Copyright © 2016 Appster. All rights reserved.
//

import Foundation

import Foundation
import UIKit

extension UIColor {
    /**
     Returns the UIColor with the hex code provided
     - returns: UIColor
     - parameter String
     - Throws: nil
     */
    class func color(withHexCode: String) -> UIColor {
        var cString = withHexCode.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()
        cString = cString.replacingOccurrences(of: "#", with: "")
        if cString.characters.count < 6 {
            // Return Default Color
            return UIColor.gray
        }
        if cString.hasPrefix("0X") {
            cString = (cString as NSString).substring(from: 2)
        }
        if cString.characters.count != 6 {
            // Return Default Color
            return UIColor.gray
        }
        var range: NSRange = NSRange()
        range.location = 0
        range.length = 2
        let rString: String = (cString as NSString).substring(with: range)
        range.location = 2
        let gString: String = (cString as NSString).substring(with: range)
        range.location = 4
        let bString: String = (cString as NSString).substring(with: range)
        var r: UInt32 = 0
        var g: UInt32 = 0
        var b: UInt32 = 0

        Scanner(string: rString).scanHexInt32(&r)
        Scanner(string: gString).scanHexInt32(&g)
        Scanner(string: bString).scanHexInt32(&b)

        return UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: 1.0)
    }
}

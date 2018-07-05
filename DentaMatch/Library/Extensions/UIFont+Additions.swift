//
//  UIFont+Additions.swift
//  DentaMatch
//
//  Created by Rajan Maheshwari on 12/10/16.
//  Copyright © 2016 Appster. All rights reserved.
//

import Foundation
import UIKit

extension UIFont {
    class func designFont(fontSize: CGFloat) -> UIFont? {
        return UIFont(name: kCustomDesignFont, size: fontSize)
    }

    class func fontRegular(fontSize: CGFloat) -> UIFont? {
        return UIFont(name: "SFUIText-Regular", size: fontSize)
    }

    class func fontHeavy(fontSize: CGFloat) -> UIFont? {
        return UIFont(name: "SFUIText-Heavy", size: fontSize)
    }

    class func fontLight(fontSize: CGFloat) -> UIFont? {
        return UIFont(name: "SFUIText-Light", size: fontSize)
    }

    class func fontSemiBold(fontSize: CGFloat) -> UIFont? {
        return UIFont(name: "SFUIText-Semibold", size: fontSize)
    }

    class func fontMedium(fontSize: CGFloat) -> UIFont? {
        return UIFont(name: "SFUIText-Medium", size: fontSize)
    }
}

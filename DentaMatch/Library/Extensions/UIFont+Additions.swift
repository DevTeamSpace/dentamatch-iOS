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
    class func designFont(fontSize: CGFloat) -> UIFont {
        return UIFont(name: kCustomDesignFont, size: fontSize) ?? UIFont.systemFont(ofSize: fontSize)
    }

    class func fontRegular(fontSize: CGFloat) -> UIFont {
        return UIFont(name: "SFUIText-Regular", size: fontSize) ?? UIFont.systemFont(ofSize: fontSize, weight: .regular)
    }

    class func fontHeavy(fontSize: CGFloat) -> UIFont {
        return UIFont(name: "SFUIText-Heavy", size: fontSize) ?? UIFont.systemFont(ofSize: fontSize, weight: .heavy)
    }

    class func fontLight(fontSize: CGFloat) -> UIFont {
        return UIFont(name: "SFUIText-Light", size: fontSize) ?? UIFont.systemFont(ofSize: fontSize, weight: .light)
    }

    class func fontSemiBold(fontSize: CGFloat) -> UIFont {
        return UIFont(name: "SFUIText-Semibold", size: fontSize) ?? UIFont.systemFont(ofSize: fontSize, weight: .semibold)
    }

    class func fontMedium(fontSize: CGFloat) -> UIFont {
        return UIFont(name: "SFUIText-Medium", size: fontSize) ?? UIFont.systemFont(ofSize: fontSize, weight: .medium)
    }
}

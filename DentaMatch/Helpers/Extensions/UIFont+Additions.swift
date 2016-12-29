//
//  UIFont+Additions.swift
//  DentaMatch
//
//  Created by Rajan Maheshwari on 12/10/16.
//  Copyright © 2016 Appster. All rights reserved.
//

import Foundation
import UIKit

extension UIFont{
    
    class func designFont(fontSize:CGFloat)->UIFont?{
        return UIFont(name: "untitled-font-6", size: fontSize)
    }
    
    class func fontRegular(fontSize:CGFloat)->UIFont?{
        return UIFont(name: "Montserrat-Regular", size: fontSize)
    }
    
}

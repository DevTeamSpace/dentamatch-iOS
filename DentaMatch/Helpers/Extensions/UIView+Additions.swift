//
//  UIView+Additions.swift
//  DentaMatch
//
//  Created by Rajan Maheshwari on 12/10/16.
//  Copyright © 2016 Appster. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
    static func instanceFromNib<T:UIView>(type: T.Type) -> T?  {
        var fullName: String = NSStringFromClass(T.self)
        if let range = fullName.range(of: ".", options: .backwards, range: nil, locale: nil) {
            fullName = fullName.substring(from: range.upperBound)
        }
        return UINib(nibName: fullName, bundle: nil).instantiate(withOwner: nil, options: nil)[0] as? T
    }
}

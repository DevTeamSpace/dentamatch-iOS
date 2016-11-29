//
//  UIStoryBoard+Additions.swift
//  DentaMatch
//
//  Created by Rajan Maheshwari on 12/10/16.
//  Copyright © 2016 Appster. All rights reserved.
//

import Foundation
import UIKit

extension UIStoryboard {
    
    func instantiateViewController<T:UIViewController>(type: T.Type) -> T? {
        var fullName: String = NSStringFromClass(T.self)
        if let range = fullName.range(of:".", options:.backwards, range:nil, locale: nil){
            fullName = fullName.substring(from: range.upperBound)
        }
        return self.instantiateViewController(withIdentifier:fullName) as? T
    }
    
    class func registrationStoryBoard()->UIStoryboard{
        return UIStoryboard(name: Constants.StoryBoard.registrationStoryboard, bundle: nil)
    }
    
    
}

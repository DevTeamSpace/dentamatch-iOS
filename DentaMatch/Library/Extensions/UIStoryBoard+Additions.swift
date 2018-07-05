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
        //debugPrint(type)
        var fullName: String = NSStringFromClass(T.self)
        if let range = fullName.range(of:".", options:.backwards, range:nil, locale: nil){
            fullName = fullName.substring(from: range.upperBound)
        }
        return self.instantiateViewController(withIdentifier:fullName) as? T
    }
    
    class func registrationStoryBoard()->UIStoryboard{
        return UIStoryboard(name: Constants.StoryBoard.registrationStoryboard, bundle: nil)
    }
    class func notificationStoryBoard()->UIStoryboard{
        return UIStoryboard(name: Constants.StoryBoard.notificationStoryboard, bundle: nil)
    }
    class func calenderStoryBoard()->UIStoryboard{
        return UIStoryboard(name: Constants.StoryBoard.calenderStoryboard, bundle: nil)
    }
    
    class func messagesStoryBoard()->UIStoryboard{
        return UIStoryboard(name: Constants.StoryBoard.messagesStoryboard, bundle: nil)
    }

    
    class func profileStoryBoard()->UIStoryboard{
        return UIStoryboard(name: Constants.StoryBoard.profileStoryboard, bundle: nil)
    }
    
    class func trackStoryBoard()->UIStoryboard{
        return UIStoryboard(name: Constants.StoryBoard.trackStoryboard, bundle: nil)
    }
    
    class func jobSearchStoryBoard()->UIStoryboard{
        return UIStoryboard(name: Constants.StoryBoard.jobSearchStoryboard, bundle: nil)
    }
    
    class func onBoardingStoryBoard()->UIStoryboard{
        return UIStoryboard(name: Constants.StoryBoard.onBoardingStoryboard, bundle: nil)
    }
    
    class func dashBoardStoryBoard()->UIStoryboard{
        return UIStoryboard(name: Constants.StoryBoard.dashboardStoryboard, bundle: nil)
    }
}

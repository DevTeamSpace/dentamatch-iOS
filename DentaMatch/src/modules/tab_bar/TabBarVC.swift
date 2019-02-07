//
//  TabBarVC.swift
//  DentaMatch
//
//  Created by Sanjay Kumar Yadav on 20/01/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

class TabBarVC: UITabBarController, UITabBarControllerDelegate {
    enum TabBarOptions: Int {
        case jobs = 1
        case track
        case calender
        case messages
        case profile
    }
    
    weak var moduleOutput: TabBarModuleOutput?
    // MARK: - View LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(setTabBarToProfile), name: NSNotification.Name(rawValue: "setTabBarToProfile"), object: nil)
        // Do any additional setup after loading the view.
        let appearance = UITabBarItem.appearance()
        UITabBarItem.appearance().titlePositionAdjustment = UIOffset(horizontal: 0, vertical: -4)
        let attributes: [NSAttributedString.Key: AnyObject] = [NSAttributedString.Key(rawValue: NSAttributedString.Key.font.rawValue): UIFont.fontRegular(fontSize: 10), NSAttributedString.Key(rawValue: NSAttributedString.Key.foregroundColor.rawValue): UIColor(red: 170.0 / 255.0, green: 175.0 / 255.0, blue: 184.0 / 255.0, alpha: 1)]
        appearance.setTitleTextAttributes(attributes, for: UIControl.State())
        let attributesSelected: [NSAttributedString.Key: AnyObject] = [NSAttributedString.Key(rawValue: NSAttributedString.Key.font.rawValue): UIFont.fontRegular(fontSize: 10), NSAttributedString.Key(rawValue: NSAttributedString.Key.foregroundColor.rawValue): UIColor(red: 4.0 / 255.0, green: 128.0 / 255.0, blue: 220.0 / 255.0, alpha: 1)]
        appearance.setTitleTextAttributes(attributesSelected, for: .selected)
        delegate = self
        tabBar.tintColor = UIColor(red: 4.0 / 255.0, green: 128.0 / 255.0, blue: 220.0 / 255.0, alpha: 1)
    }
    
    func setTabBarIcons() {
        let titles = ["Jobs", "Track", "Calendar", "Messages", "Profile"]
        let images = titles.compactMap({ UIImage(named: $0.lowercased()) })
        
        for (idx, item) in (tabBar.items ?? []).enumerated() {
            item.title = titles[idx]
            item.image = images[idx]
        }
    }

    @objc func setTabBarToProfile() {
        selectedIndex = 4
    }
    
    func updateBadgeOnProfileTab(value: Int?) {
        if let tabItems = self.tabBar.items, let profileTab = tabItems.last {
            // In this case we want to modify the badge number of the third tab:
            if let newValue = value, newValue > 0 {
                profileTab.badgeValue = "\(newValue)"
            }else{
               profileTab.badgeValue = nil
            }
            
        }
    }

    // TODO: - Will Implement Later
    func tabBarController(_: UITabBarController, didSelect viewController: UIViewController) {
        // self.tabBar.alpha = 1.0
        let index = selectedIndex
        let tabBarOptions = TabBarOptions(rawValue: (index + 1))!

        switch tabBarOptions {
        case .jobs, .track, .messages: break
        case .calender : NotificationCenter.default.post(name: .tabChanged, object: nil, userInfo: nil)
        case .profile:
            //if let navController = viewController as? UINavigationController, let profileVC = navController.viewControllers.first as? DMEditProfileVC  {
                //if profileVC.dashBoardVC != nil {
                    //  profileVC.userProfileAPI()
                //}
            //}
            // print("profile \(profileVC)")
            break
        }
    }

    override func removeFromParent() {
        // debugPrint("removeFromParentViewController")
    }
}

//
//  TabBarVC.swift
//  DentaMatch
//
//  Created by Sanjay Kumar Yadav on 20/01/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

class TabBarVC: UITabBarController,UITabBarControllerDelegate {
    
    enum TabBarOptions:Int {
        case jobs = 1
        case track
        case calender
        case messages
        case profile

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        let appearance = UITabBarItem.appearance()
        UITabBarItem.appearance().titlePositionAdjustment = UIOffset(horizontal: 0, vertical:-4)
        let attributes: [String: AnyObject] = [NSFontAttributeName:UIFont.fontRegular(fontSize: 10)!, NSForegroundColorAttributeName: UIColor(red:170.0/255.0, green: 175.0/255.0, blue: 184.0/255.0, alpha: 1)]
        appearance.setTitleTextAttributes(attributes, for: UIControlState())
        let attributesSelected: [String: AnyObject] = [NSFontAttributeName:UIFont.fontRegular(fontSize: 10)!, NSForegroundColorAttributeName: UIColor(red:4.0/255.0, green: 128.0/255.0, blue: 220.0/255.0, alpha: 1)]
        appearance.setTitleTextAttributes(attributesSelected, for: .selected)
        self.delegate=self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
//        self.tabBar.alpha = 1.0
//        let tabBarOptions = TabBarOptions(rawValue: (self.tabBar.selectedItem?.tag)!)!
//        
//        switch tabBarOptions {
//            
//        case .jobs:
//            print("jobs")
//            
//        case .track:
//            print("track")
//
//        case .calender:
//            print("calender")
//
//        case .messages:
//            print("messages")
//
//        case .profile:
//            print("profile")
//
//        }
//    }
    
    override func viewWillDisappear(_ animated: Bool) {
        debugPrint("viewWillDisappear")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        debugPrint("viewWillAppear")
        
    }
    
    override func viewDidLayoutSubviews() {
        debugPrint("viewDidLayoutSubviews")
        
    }
    override func removeFromParentViewController() {
        debugPrint("removeFromParentViewController")
        
    }
    
    override var childViewControllerForStatusBarStyle : UIViewController?
    {
        return nil
    }
}

//
//  AppDelegate.swift
//  DentaMatch
//
//  Created by Rajan Maheshwari on 12/10/16.
//  Copyright © 2016 Appster. All rights reserved.
//

import UIKit
import CoreData
import GoogleMaps
import GooglePlaces
import Crashlytics
import Fabric
import SwiftyJSON

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    private var reachability:Reachability!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        //configureCrashlytics()
        
        configureSocket()
        
        configureGoogleServices()
        
        registerForPushNotifications()
        
        //configureRichNotifications()
        
        changeNavBarAppearance()
        
        configureNetworkReachability()
        
        if UserDefaultsManager.sharedInstance.isProfileCompleted {
            self.goToDashBoard()
            return true
        }
        
        if !UserDefaultsManager.sharedInstance.isProfileSkipped {
            if UserDefaultsManager.sharedInstance.isLoggedIn {
                self.goToProfile()
            } else {
                if UserDefaultsManager.sharedInstance.isOnBoardingDone {
                    self.goToRegistration()
                }
            }
        } else {
            self.goToDashBoard()
            
            if let remoteNotification = launchOptions?[UIApplicationLaunchOptionsKey.remoteNotification] as? NSDictionary {
                if remoteNotification.allKeys.count > 0
                {
//                    self.tabIndex = 4
                    if let noti = remoteNotification["data"] as? NSDictionary {
                        let newObjMSG = noti["jobDetails"]
                        let jobJson = JSON(newObjMSG ?? [:])
                        let jobObj = Job(job: jobJson)

                        let newObj = noti["data"]
                        let josnObj = JSON(newObj ?? [:])
                        let userNotiObj = UserNotification(dict: josnObj)
                        NotificationHandler.notificationHandleforBackground(notiObj: userNotiObj, jobObj:jobObj, app: application)
                    }

                }
            }
            
        }
        
        
        
        return true
    }
   
    func goToRegistration() {
        let registrationVC = UIStoryboard.registrationStoryBoard().instantiateViewController(withIdentifier: Constants.StoryBoard.Identifer.registrationNav) as! UINavigationController
        self.window?.rootViewController = registrationVC
    }
    
    func goToProfile() {
        let profileVC = UIStoryboard.profileStoryBoard().instantiateViewController(withIdentifier: Constants.StoryBoard.Identifer.profileNav) as! UINavigationController
        self.window?.rootViewController = profileVC
    }
    
    func goToDashBoard() {
        let dashboardVC = UIStoryboard.dashBoardStoryBoard().instantiateViewController(type: TabBarVC.self)!
        self.window?.rootViewController = dashboardVC
    }
    
    func goToSearch() {
        let jobSearchVC = UIStoryboard.jobSearchStoryBoard().instantiateViewController(withIdentifier: Constants.StoryBoard.Identifer.jobSearchNav) as! UINavigationController
        self.window?.rootViewController = jobSearchVC
    }
    
    func changeNavBarAppearance() {
        UIApplication.shared.statusBarStyle = .lightContent
        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().isTranslucent = false
        UINavigationBar.appearance().barTintColor = Constants.Color.navBarColor
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName:UIColor.white,NSFontAttributeName:UIFont.fontRegular(fontSize: 14.0)!]
    }
    
    // MARK: - Configure Crashlytics
    func configureSocket() {
//        if let _ = UserManager.shared().activeUser {
        if UserDefaultsManager.sharedInstance.isLoggedIn {
            SocketManager.sharedInstance.establishConnection()
        }
    }
    
    func destroySocket() {
        if let _ = UserManager.shared().activeUser {
            SocketManager.sharedInstance.closeConnection()
        }
    }
    
    // MARK: - Configure Crashlytics
    func configureCrashlytics() {
        Fabric.with([Crashlytics.self])
    }
    
    // MARK: - Configure GoogleServices
    func configureGoogleServices() {
        GMSServices.provideAPIKey(kGoogleAPIKey)
        GMSPlacesClient.provideAPIKey(kGoogleAPIKey)
    }
    
    // MARK: - Network Reachability Notification Setup
    func configureNetworkReachability() {
        NotificationCenter.default.addObserver(self, selector: #selector(reachabilityChanged), name: ReachabilityChangedNotification, object: nil)
        self.reachability = Reachability.init()
        do {
            try self.reachability.startNotifier()
        } catch let error {
            debugPrint(error.localizedDescription)
        }
    }
    
    func reachabilityChanged(notification:Notification) {
        let reachability = notification.object as! Reachability
        if reachability.isReachable {
            if reachability.isReachableViaWiFi {
                debugPrint("Reachable via WiFi")
            } else {
                debugPrint("Reachable via Cellular")
            }
        } else {
            debugPrint("Network not reachable")
        }
    }
    
    // MARK: - UIApplication Delegates
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        self.destroySocket()
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        self.configureSocket()
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func chatSocketNotificationTap(recruiterId:String) {
        if let tabbar = ((UIApplication.shared.delegate) as! AppDelegate).window?.rootViewController as? TabBarVC {
            tabbar.selectedIndex = 3
            NotificationCenter.default.post(name: .chatRedirect, object: nil, userInfo: ["recruiterId":recruiterId])
        }
    }

    // MARK: - Core Data stack
    lazy var applicationDocumentsDirectory: NSURL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "com.test.CoreData_13Aug" in the application's documents Application Support directory.
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        debugPrint(urls)
        return urls[urls.count-1] as NSURL
    }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = Bundle.main.url(forResource: "DentaMatch", withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.appendingPathComponent("SingleViewCoreData.sqlite")
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: nil)
        } catch {
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data" as AnyObject?
            dict[NSLocalizedFailureReasonErrorKey] = failureReason as AnyObject?
            
            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }
        
        return coordinator
    }()
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()
    
    // MARK: - Core Data Saving support
    func saveContext () {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                abort()
            }
        }
    }
}


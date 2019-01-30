import Crashlytics
import Fabric
import GoogleMaps
import GooglePlaces
import Mixpanel
import UIKit
import Swinject
import SwinjectStoryboard
import SwiftyJSON
import Instabug
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    private var reachability: Reachability!
    
    class func delegate() -> AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    lazy var container: Container = {
        return defaultContainer()
    }()
    
    lazy var rootFlowCoordinator: RootFlowCoordinatorProtocol? = {
        return appContainer.resolve(RootFlowCoordinatorProtocol.self)
    }()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        setUpApplication()
        makeRoot(viewController: rootFlowCoordinator?.launchViewController())

        if !UserDefaultsManager.sharedInstance.isProfileSkipped {
            checkForNotificationTapAction(application, launchOptions)
        }
        
        return true
    }
    
    func setUpApplication() {
        MixpanelOperations.startSessionForMixpanelWithToken()
        //Instabug.start(withToken: kInstaBugKey, invocationEvents: [.shake])

        configureCrashlytics()

        configureSocket()

        configureGoogleServices()

        registerForPushNotifications()

        // configureRichNotifications()

        changeNavBarAppearance()

        configureNetworkReachability()
    }
    
    func makeRoot(viewController: UIViewController?) {
        guard let viewController = viewController else { return }
        
        defer {
            window?.rootViewController = viewController
            window?.makeKeyAndVisible()
        }
        
        if window == nil {
            window = UIWindow(frame: UIScreen.main.bounds)
        }
    }
    
    private func checkForNotificationTapAction(_ application: UIApplication, _ launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        if let remoteNotification = launchOptions?[UIApplication.LaunchOptionsKey.remoteNotification] as? NSDictionary {
            if remoteNotification.allKeys.count > 0 {
                //                    self.tabIndex = 4
                if let noti = remoteNotification["data"] as? NSDictionary {
                    guard let megCheck = noti["data"] as? NSDictionary else {return}
                    if megCheck["messageId"] != nil {
                        NotificationHandler.notificationHandleforChat(fromId: (megCheck["fromId"] as? String), toId: (megCheck["toId"] as? String), messgaeId: (megCheck["messageId"] as? String), recurterId: (megCheck["recurterId"] as? String))
                    } else {
                        let newObjMSG = noti["jobDetails"]
                        let jobJson = JSON(newObjMSG ?? "")
                        let jobObj = Job(job: jobJson)
                        let newObj = noti["data"]
                        let josnObj = JSON(newObj ?? [:])
                        let userNotiObj = UserNotification(dict: josnObj)
                        NotificationHandler.notificationHandleforBackground(notiObj: userNotiObj, jobObj: jobObj, app: application)
                    }
                }
            }
        }
    }
    
    func configureRealm() {
        var config = Realm.Configuration.defaultConfiguration
        config.schemaVersion = 0
        config.deleteRealmIfMigrationNeeded = true
        Realm.Configuration.defaultConfiguration = config
        let realm = try! Realm()
        print(realm.configuration.fileURL?.absoluteString ?? "")
    }

    func changeNavBarAppearance() {
        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().isTranslucent = false
        UINavigationBar.appearance().barTintColor = Constants.Color.navBarColor
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.fontRegular(fontSize: 14.0)]
    }

    // MARK: - Configure Crashlytics

    func configureSocket() {
        if UserDefaultsManager.sharedInstance.isLoggedIn {
            SocketIOManager.sharedInstance.establishConnection()
        }
    }

    func destroySocket() {
        if let _ = UserManager.shared().activeUser {
            SocketIOManager.sharedInstance.closeConnection()
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
        reachability = Reachability()
        do {
            try reachability.startNotifier()
        } catch _ {
            // debugPrint(error.localizedDescription)
        }
    }

    @objc func reachabilityChanged(notification: Notification) {
        guard let reachability = notification.object as? Reachability else { return }
        if reachability.isReachable {
            if reachability.isReachableViaWiFi {
                LogManager.logDebug("Reachable via WiFi")
            } else {
                LogManager.logDebug("Reachable via Cellular")
            }
        } else {
            LogManager.logDebug("Network not reachable")
        }
    }

    // MARK: - UIApplication Delegates

    func applicationWillResignActive(_: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        // self.destroySocket()
        if let _ = UserManager.shared().activeUser {
            SocketIOManager.sharedInstance.closeConnection()
        }
    }

    func applicationWillEnterForeground(_: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        NotificationCenter.default.post(name: .fetchBadgeCount, object: nil, userInfo: nil)
        configureSocket()
    }

    func applicationDidBecomeActive(_: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    func chatSocketNotificationTap(recruiterId: String) {
        if let tabbar = ((UIApplication.shared.delegate) as? AppDelegate)?.window?.rootViewController as? TabBarVC {
            tabbar.selectedIndex = 3
            NotificationCenter.default.post(name: .chatRedirect, object: nil, userInfo: ["recruiterId": recruiterId])
        }
    }

    func showOverlay(isJobSeekerVerified: Bool = false) {
        guard let commonSuccessFailureVC = DMCommonSuccessFailureInitializer.initialize() as? DMCommonSuccessFailureVC else { return }
        commonSuccessFailureVC.isJobSeekerVerified = isJobSeekerVerified
        commonSuccessFailureVC.modalPresentationStyle = .overCurrentContext
        commonSuccessFailureVC.modalTransitionStyle = .coverVertical
        window?.rootViewController?.present(commonSuccessFailureVC, animated: true, completion: nil)
    }
}

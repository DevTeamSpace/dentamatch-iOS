import Foundation
import UIKit
import Swinject

protocol TabBarFlowCoordinatorProtocol: BaseFlowProtocol {
    
    func currentSelectedIndex() -> Int
    func showTab(withIndex index: Int)
    func updateMessagesTabBadge(count: Int)
}

protocol TabBarFlowCoordinatorDelegate: class {
    
    func logout()
}

class TabBarFlowCoordinator: BaseFlowCoordinator, TabBarFlowCoordinatorProtocol {
    
    weak var viewController: UITabBarController?
    unowned let delegate: TabBarFlowCoordinatorDelegate
    
    init(delegate: TabBarFlowCoordinatorDelegate) {
        self.delegate = delegate
    }
    
    func launchViewController() -> UIViewController? {
        guard let mainController = TabBarInitializer.initialize(moduleOutput: self) as? TabBarVC,
            let jobsCoordinator = appContainer.resolve(JobsFlowCoordinatorProtocol.self, argument: self as JobsFlowCoordinatorDelegate),
            let trackCoordinator = appContainer.resolve(TrackFlowCoordinatorProtocol.self, argument: self as TrackFlowCoordinatorDelegate),
            let calendarCoordinator = appContainer.resolve(CalendarFlowCoordinatorProtocol.self, argument: self as CalendarFlowCoordinatorDelegate),
            let messagesCoordinator = appContainer.resolve(MessagesFlowCoordinatorProtocol.self, argument: self as MessagesFlowCoordinatorDelegate),
            let profileCoordinator = appContainer.resolve(ProfileFlowCoordinatorProtocol.self, argument: self as ProfileFlowCoordinatorDelegate) else { return nil }
        
        viewController = mainController
        
        addChildFlowCoordinator(jobsCoordinator)
        addChildFlowCoordinator(trackCoordinator)
        addChildFlowCoordinator(calendarCoordinator)
        addChildFlowCoordinator(messagesCoordinator)
        addChildFlowCoordinator(profileCoordinator)
        
        let controllers = [jobsCoordinator.launchViewController(),
                           trackCoordinator.launchViewController(),
                           calendarCoordinator.launchViewController(),
                           messagesCoordinator.launchViewController(),
                           profileCoordinator.launchViewController()]
        
        mainController.viewControllers = controllers.compactMap({ $0 })
        
        mainController.setTabBarIcons()
        updateMessagesTabBadge(count: DatabaseManager.getUnreadedMessages())
        
        return mainController
    }
    
    func currentSelectedIndex() -> Int {
        return viewController?.selectedIndex ?? 3
    }
    
    func showTab(withIndex index: Int) {
        viewController?.selectedIndex = index
    }
    
    func updateMessagesTabBadge(count: Int) {
        guard let index = viewController?.viewControllers?.firstIndex(where: { (vc) -> Bool in
            if let vc = vc as? UINavigationController, vc.viewControllers.first is DMMessagesVC {
                return true
            }
            
            return false
        }) else { return }
        
        viewController?.tabBar.items?[index].badgeValue = count == 0 ? nil : String(count)
    }
}

extension TabBarFlowCoordinator: TabBarModuleOutput {
    
    
}

extension TabBarFlowCoordinator: JobsFlowCoordinatorDelegate {
    
    func selectTabBarIndex(_ idx: Int) {
        viewController?.selectedIndex = idx
    }
}

extension TabBarFlowCoordinator: TrackFlowCoordinatorDelegate {
    
    
}

extension TabBarFlowCoordinator: CalendarFlowCoordinatorDelegate {
    
    
}

extension TabBarFlowCoordinator: MessagesFlowCoordinatorDelegate {
    
}

extension TabBarFlowCoordinator: ProfileFlowCoordinatorDelegate {
    
    func logoutFromSettings() {
        
        delegate.logout()
    }
}


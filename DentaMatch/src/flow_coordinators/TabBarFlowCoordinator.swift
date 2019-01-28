import Foundation
import UIKit
import Swinject

protocol TabBarFlowCoordinatorProtocol: BaseFlowProtocol {
    
}

protocol TabBarFlowCoordinatorDelegate: class {
    
}

class TabBarFlowCoordinator: BaseFlowCoordinator, TabBarFlowCoordinatorProtocol {
    
    weak var viewController: UIViewController?
    unowned let delegate: TabBarFlowCoordinatorDelegate
    
    init(delegate: TabBarFlowCoordinatorDelegate) {
        self.delegate = delegate
    }
    
    func launchViewController() -> UIViewController? {
        guard let mainController = TabBarInitializer.initialize(moduleOutput: self) as? TabBarVC,
            let jobsCoordinator = appContainer.resolve(JobsFlowCoordinatorProtocol.self, argument: self as JobsFlowCoordinatorDelegate),
            let trackCoordinator = appContainer.resolve(TrackFlowCoordinatorProtocol.self, argument: self as TrackFlowCoordinatorDelegate),
            let calendarCoordinator = appContainer.resolve(CalendarFlowCoordinatorProtocol.self, argument: self as CalendarFlowCoordinatorDelegate) else { return nil }
        
        viewController = mainController
        
        addChildFlowCoordinator(jobsCoordinator)
        addChildFlowCoordinator(trackCoordinator)
        addChildFlowCoordinator(calendarCoordinator)
        
        let controllers = [jobsCoordinator.launchViewController(),
                           trackCoordinator.launchViewController(),
                           calendarCoordinator.launchViewController()]
        
        mainController.viewControllers = controllers.compactMap({ $0 })
        
        mainController.setTabBarIcons()
        
        return mainController
    }
}

extension TabBarFlowCoordinator: TabBarModuleOutput {
    
    
}

extension TabBarFlowCoordinator: JobsFlowCoordinatorDelegate {
    
    
}

extension TabBarFlowCoordinator: TrackFlowCoordinatorDelegate {
    
    
}

extension TabBarFlowCoordinator: CalendarFlowCoordinatorDelegate {
    
    
}


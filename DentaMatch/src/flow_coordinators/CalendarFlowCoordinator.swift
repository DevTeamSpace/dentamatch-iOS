import Foundation
import UIKit
import Swinject

protocol CalendarFlowCoordinatorProtocol: BaseFlowProtocol {
    
}

protocol CalendarFlowCoordinatorDelegate: class {
    
}

class CalendarFlowCoordinator: BaseFlowCoordinator, CalendarFlowCoordinatorProtocol {
    
    weak var navigationController: UINavigationController?
    unowned let delegate: CalendarFlowCoordinatorDelegate
    
    init(delegate: CalendarFlowCoordinatorDelegate) {
        self.delegate = delegate
    }
    
    func launchViewController() -> UIViewController? {
        guard let vc = DMCalendarInitializer.initialize(moduleOutput: self) else { return nil }
        
        let navController = UINavigationController(rootViewController: vc)
        navigationController = navController
        return navController
    }
}

extension CalendarFlowCoordinator: DMCalendarModuleOutput {
    
    func showCalendar() {
        guard let vc = DMCalendarSetAvailabilityInitializer.initialize(moduleOutput: self) else { return }
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension CalendarFlowCoordinator: DMCalendarSetAvailabilityModuleOutput {
    
    func showTabBar() {
        
    }
}

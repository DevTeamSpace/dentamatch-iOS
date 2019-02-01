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
        guard let moduleInput = DMCalendarSetAvailabilityInitializer.initialize(moduleOutput: self) else { return }
        let vc = moduleInput.viewController()
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func showJobDetail(job: Job?) {
        guard let vc = DMJobDetailInitializer.initialize(job: job, moduleOutput: self) else { return }
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func showCancelJob(job: Job?, fromApplied: Bool, delegate: CancelledJobDelegate) {
        guard let vc = DMCancelJobInitializer.initialize(job: job, fromApplied: fromApplied, delegate: delegate, moduleOutput: self) else { return }
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension CalendarFlowCoordinator: DMCalendarSetAvailabilityModuleOutput {
    
    func showTabBar() {
        
    }
}

extension CalendarFlowCoordinator: DMJobDetailModuleOutput {
    
    
}

extension CalendarFlowCoordinator: DMCancelJobModuleOutput {
    
    
}

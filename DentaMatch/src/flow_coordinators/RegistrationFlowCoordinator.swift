import Foundation
import UIKit
import Swinject

protocol RegistrationFlowCoordinatorProtocol: BaseFlowProtocol {
    
    func launchViewControllerFromPending() -> UIViewController?
}

protocol RegistrationFlowCoordinatorDelegate: class {
    
}

class RegistrationFlowCoordinator: BaseFlowCoordinator, RegistrationFlowCoordinatorProtocol {
    
    weak var navigationController: UINavigationController?
    unowned let delegate: RegistrationFlowCoordinatorDelegate
    
    init(delegate: RegistrationFlowCoordinatorDelegate) {
        self.delegate = delegate
    }
    
    func launchViewController() -> UIViewController? {
        guard let vc = DMJobTitleSelectionInitializer.initialize(moduleOutput: self) else { return nil }
        
        let navController = UINavigationController(rootViewController: vc)
        navigationController = navController
        return navController
    }
    
    func launchViewControllerFromPending() -> UIViewController? {
        guard let vc = DMProfileSuccessPendingInitializer.initialize(fromRoot: true, moduleOutput: self) else { return nil }
        
        let navController = UINavigationController(rootViewController: vc)
        navigationController = navController
        return navController
    }
}

extension RegistrationFlowCoordinator: DMJobTitleSelectionModuleOutput {
    
    func showTabBar() {
        navigationController?.dismiss(animated: true)
    }
    
    func showStates(preselectedState: String?, delegate: SearchStateViewControllerDelegate?) {
        guard let vc = SearchStateInitializer.initialize(preselectedState: preselectedState, delegate: delegate, moduleOutput: self) else { return }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func showSuccessPending(isEmailVerified: Bool, isLicenseRequired: Bool, fromRoot: Bool) {
        guard let vc = DMProfileSuccessPendingInitializer.initialize(isEmailVerified: isEmailVerified, isLicenseRequired: isLicenseRequired, fromRoot: fromRoot, moduleOutput: self) else { return }
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension RegistrationFlowCoordinator: SearchStateModuleOutput {
    
    
}

extension RegistrationFlowCoordinator: DMProfileSuccessPendingModuleOutput {
    
    func showCalendar(fromJobSelection: Bool) {
        guard let vc = DMCalendarSetAvailabilityInitializer.initialize(fromJobSelection: fromJobSelection, moduleOutput: self) else { return }
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension RegistrationFlowCoordinator: DMCalendarSetAvailabilityModuleOutput {
    
    
}

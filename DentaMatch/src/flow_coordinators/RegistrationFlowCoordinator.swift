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
        guard let moduleInput = DMJobTitleSelectionInitializer.initialize(moduleOutput: self) else { return nil }
        
        let navController = DMBaseNC(rootViewController: moduleInput.viewController())
        navigationController = navController
        return navController
    }
    
    func launchViewControllerFromPending() -> UIViewController? {
        guard let moduleInput = DMProfileSuccessPendingInitializer.initialize(fromRoot: true, moduleOutput: self) else { return nil }
        
        let navController = DMBaseNC(rootViewController: moduleInput.viewController())
        navigationController = navController
        return navController
    }
}

extension RegistrationFlowCoordinator: DMJobTitleSelectionModuleOutput {
    
    func showTabBar() {
        navigationController?.dismiss(animated: true)
    }
    
    func showStates(preselectedState: String?, delegate: SearchStateViewControllerDelegate?) {
        guard let moduleInput = SearchStateInitializer.initialize(preselectedState: preselectedState, delegate: delegate, moduleOutput: self) else { return }
        navigationController?.pushViewController(moduleInput.viewController(), animated: true)
    }
    
    func showSuccessPending(isEmailVerified: Bool, isLicenseRequired: Bool, fromRoot: Bool) {
        guard let moduleInput = DMProfileSuccessPendingInitializer.initialize(isEmailVerified: isEmailVerified, isLicenseRequired: isLicenseRequired, fromRoot: fromRoot, moduleOutput: self) else { return }
        navigationController?.pushViewController(moduleInput.viewController(), animated: true)
    }
}

extension RegistrationFlowCoordinator: SearchStateModuleOutput {
    
    
}

extension RegistrationFlowCoordinator: DMProfileSuccessPendingModuleOutput {
    
    func showCalendar(fromJobSelection: Bool) {
        guard let moduleInput = DMCalendarSetAvailabilityInitializer.initialize(fromJobSelection: fromJobSelection, moduleOutput: self) else { return }
        navigationController?.pushViewController(moduleInput.viewController(), animated: true)
    }
}

extension RegistrationFlowCoordinator: DMCalendarSetAvailabilityModuleOutput {
    
    
}

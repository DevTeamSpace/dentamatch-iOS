import Foundation
import UIKit
import Swinject

protocol RootFlowCoordinatorProtocol: BaseFlowProtocol {
}

class RootFlowCoordinator: BaseFlowCoordinator, RootFlowCoordinatorProtocol {

    weak var viewController: UIViewController?

    func launchViewController() -> UIViewController? {
        
        guard let vc = RootScreenInitializer.initialize(moduleOutput: self) else { return nil }
        viewController = vc
        return vc
    }
}

extension RootFlowCoordinator: RootScreenModuleOutput {
    
    func showSuccessPendingScreen() {
        childCoordinators.removeAll()
        
        guard let registrationCoordinator = appContainer.resolve(RegistrationFlowCoordinatorProtocol.self, argument: self as RegistrationFlowCoordinatorDelegate),
            let vc = registrationCoordinator.launchViewControllerFromPending() else { return }
        
        addChildFlowCoordinator(registrationCoordinator)
        viewController?.present(vc, animated: true)
    }
    
    func showProfile() {
        childCoordinators.removeAll()
        
        guard let registrationCoordinator = appContainer.resolve(RegistrationFlowCoordinatorProtocol.self, argument: self as RegistrationFlowCoordinatorDelegate),
            let vc = registrationCoordinator.launchViewController() else { return }
        
        addChildFlowCoordinator(registrationCoordinator)
        viewController?.present(vc, animated: true)
    }
    
    func showDashboard() {
        childCoordinators.removeAll()
        
        guard let tabbarCoordinator = appContainer.resolve(TabBarFlowCoordinatorProtocol.self, argument: self as TabBarFlowCoordinatorDelegate),
            let vc = tabbarCoordinator.launchViewController() else { return }
        
        addChildFlowCoordinator(tabbarCoordinator)
        viewController?.present(vc, animated: true)
    }
    
    func showOnboarding() {
        guard let vc = DMOnboardingInitializer.initialize(moduleOutput: self) else { return }
        viewController?.present(vc, animated: true)
    }
    
    func showRegistration() {
        childCoordinators.removeAll()
        
        guard let authorizationCoordinator = appContainer.resolve(AuthorizationFlowCoordinatorProtocol.self, argument: self as AuthorizationFlowCoordinatorDelegate),
            let vc = authorizationCoordinator.launchViewController() else { return }
        
        addChildFlowCoordinator(authorizationCoordinator)
        viewController?.present(vc, animated: true)
    }
}

extension RootFlowCoordinator: AuthorizationFlowCoordinatorDelegate {
    
    
}

extension RootFlowCoordinator: RegistrationFlowCoordinatorDelegate {
    
    
}

extension RootFlowCoordinator: TabBarFlowCoordinatorDelegate {
    
    
}

extension RootFlowCoordinator: DMOnboardingModuleOutput {
    
    
}

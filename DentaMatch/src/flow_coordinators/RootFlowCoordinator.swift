import Foundation
import UIKit
import Swinject

protocol RootFlowCoordinatorProtocol: BaseFlowProtocol {
    
    func logout()
    func canShowChatNotification() -> Bool
    func showMessagesTab()
}

class RootFlowCoordinator: BaseFlowCoordinator, RootFlowCoordinatorProtocol {

    weak var viewController: UIViewController?
    
    weak var tabbarCoordinator: TabBarFlowCoordinatorProtocol?

    func launchViewController() -> UIViewController? {
        
        guard let vc = RootScreenInitializer.initialize(moduleOutput: self) else { return nil }
        viewController = vc
        return vc
    }
    
    func canShowChatNotification() -> Bool {
        return tabbarCoordinator?.currentSelectedIndex() != 3
    }
    
    func showMessagesTab() {
        tabbarCoordinator?.showTab(withIndex: 3)
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
        
        self.tabbarCoordinator = tabbarCoordinator
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
    
    func logout() {
        viewController?.dismiss(animated: true, completion: {
            DatabaseManager.clearDB()
        })
    }
}

extension RootFlowCoordinator: DMOnboardingModuleOutput {
    
    
}
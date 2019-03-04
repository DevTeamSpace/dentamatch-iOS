import Foundation
import UIKit
import Swinject

protocol RootFlowCoordinatorProtocol: BaseFlowProtocol {
    
    func logout()
    func canShowChatNotification() -> Bool
    func showMessagesTab()
    func updateMessagesBadgeValue(count: Int)
    func presentChat(chatObject: ChatObject)
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
    
    func updateMessagesBadgeValue(count: Int) {
        tabbarCoordinator?.updateMessagesTabBadge(count: count)
    }
    
    func presentChat(chatObject: ChatObject) {
        tabbarCoordinator?.presentChat(chatObj: chatObject)
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
        guard let moduleInput = DMOnboardingInitializer.initialize(moduleOutput: self) else { return }
        viewController?.present(moduleInput.viewController(), animated: true)
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
        guard !(childCoordinators.first is AuthorizationFlowCoordinator) else { return }
        viewController?.dismiss(animated: true, completion: {
            DatabaseManager.clearDB()
        })
    }
}

extension RootFlowCoordinator: DMOnboardingModuleOutput {
    
    
}

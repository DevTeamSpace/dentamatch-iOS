import Foundation
import UIKit
import Swinject

protocol AuthorizationFlowCoordinatorProtocol: BaseFlowProtocol {
    
}

protocol AuthorizationFlowCoordinatorDelegate: class {
    
}

class AuthorizationFlowCoordinator: BaseFlowCoordinator, AuthorizationFlowCoordinatorProtocol {
    
    weak var navigationController: UINavigationController?
    unowned let delegate: AuthorizationFlowCoordinatorDelegate
    
    init(delegate: AuthorizationFlowCoordinatorDelegate) {
        self.delegate = delegate
    }
    
    func launchViewController() -> UIViewController? {
        guard let vc = DMRegistrationContainerInitializer.initialize(moduleOutput: self) else { return nil }
        
        let navController = UINavigationController(rootViewController: vc)
        navController.setNavigationBarHidden(true, animated: false)
        navigationController = navController
        return navController
    }
}

extension AuthorizationFlowCoordinator: DMRegistrationContainerModuleOutput {
    
    func getLoginController() -> DMLoginVC? {
        return DMLoginInitializer.initialize(moduleOutput: self) as? DMLoginVC
    }
    
    func getRegistrationController() -> DMRegistrationVC? {
        return DMRegistrationInitializer.initialize(moduleOutput: self) as? DMRegistrationVC
    }
}

extension AuthorizationFlowCoordinator: DMLoginModuleOutput {
    
    func showForgotPassword() {
        guard let vc = DMForgotPasswordInitializer.initialize(moduleOutput: self) else { return }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func showTabBar() {
        navigationController?.dismiss(animated: true)
    }
    
    func showJobTitleSelection() {
        navigationController?.dismiss(animated: true)
    }
}

extension AuthorizationFlowCoordinator: DMRegistrationModuleOutput {
    
    func showTermsAndConditions(isPrivacyPolicy: Bool) {
        guard let vc = DMTermsAndConditionsInitializer.initialize(isPrivacyPolicy: isPrivacyPolicy, moduleOutput: self) else { return }
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension AuthorizationFlowCoordinator: DMForgotPasswordModuleOutput {
    
    
}

extension AuthorizationFlowCoordinator: DMTermsAndConditionsModuleOutput {
    
    
}

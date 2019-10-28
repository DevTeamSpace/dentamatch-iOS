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
        guard let moduleInput = DMRegistrationContainerInitializer.initialize(moduleOutput: self) else { return nil }
        
        let navController = DMBaseNC(rootViewController: moduleInput.viewController())
        navController.setNavigationBarHidden(true, animated: false)
        navigationController = navController
        return navController
    }
}

extension AuthorizationFlowCoordinator: DMRegistrationContainerModuleOutput {
    
    func getLoginController() -> DMLoginModuleInput? {
        return DMLoginInitializer.initialize(moduleOutput: self)
    }
    
    func getRegistrationController() -> DMRegistrationModuleInput? {
        return DMRegistrationInitializer.initialize(moduleOutput: self)
    }
}

extension AuthorizationFlowCoordinator: DMLoginModuleOutput {
    
    func showForgotPassword() {
        guard let moduleInput = DMForgotPasswordInitializer.initialize(moduleOutput: self) else { return }
        navigationController?.pushViewController(moduleInput.viewController(), animated: true)
    }
    
    func showTabBar() {
        UserDefaultsManager.sharedInstance.isProfileSkipped = true
        navigationController?.dismiss(animated: true)
    }
    
    func showJobTitleSelection() {
        navigationController?.dismiss(animated: true)
    }
}

extension AuthorizationFlowCoordinator: DMRegistrationModuleOutput {
    
    func showTermsAndConditions(isPrivacyPolicy: Bool) {
        guard let moduleInput = DMTermsAndConditionsInitializer.initialize(isPrivacyPolicy: isPrivacyPolicy, moduleOutput: self) else { return }
        navigationController?.pushViewController(moduleInput.viewController(), animated: true)
    }
}

extension AuthorizationFlowCoordinator: DMForgotPasswordModuleOutput {
    
    
}

extension AuthorizationFlowCoordinator: DMTermsAndConditionsModuleOutput {
    
    
}

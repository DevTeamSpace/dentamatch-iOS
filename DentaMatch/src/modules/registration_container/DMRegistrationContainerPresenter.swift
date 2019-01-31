import Foundation

class DMRegistrationContainerPresenter: DMRegistrationContainerPresenterProtocol {
    
    unowned let viewInput: DMRegistrationContainerViewInput
    unowned let moduleOutput: DMRegistrationContainerModuleOutput
    
    init(viewInput: DMRegistrationContainerViewInput, moduleOutput: DMRegistrationContainerModuleOutput) {
        self.viewInput = viewInput
        self.moduleOutput = moduleOutput
    }
}

extension DMRegistrationContainerPresenter: DMRegistrationContainerModuleInput {
    
    func viewController() -> UIViewController {
        return viewInput.viewController()
    }
}

extension DMRegistrationContainerPresenter: DMRegistrationContainerViewOutput {
    
    func getLoginController() -> DMLoginVC? {
        return moduleOutput.getLoginController()?.viewController() as? DMLoginVC
    }
    
    func getRegistrationController() -> DMRegistrationVC? {
        return moduleOutput.getRegistrationController()?.viewController() as? DMRegistrationVC
    }
}

extension DMRegistrationContainerPresenter {
    
}

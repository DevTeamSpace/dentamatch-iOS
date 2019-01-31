import Foundation

class DMOnboardingPresenter: DMOnboardingPresenterProtocol {
    
    unowned let viewInput: DMOnboardingViewInput
    unowned let moduleOutput: DMOnboardingModuleOutput
    
    init(viewInput: DMOnboardingViewInput, moduleOutput: DMOnboardingModuleOutput) {
        self.viewInput = viewInput
        self.moduleOutput = moduleOutput
    }
}

extension DMOnboardingPresenter: DMOnboardingModuleInput {
    
    func viewController() -> UIViewController {
        return viewInput.viewController()
    }
}

extension DMOnboardingPresenter: DMOnboardingViewOutput {
    
}

extension DMOnboardingPresenter {
    
}

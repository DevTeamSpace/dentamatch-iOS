import Foundation

class DMTermsAndConditionsPresenter: DMTermsAndConditionsPresenterProtocol {
    
    unowned let viewInput: DMTermsAndConditionsViewInput
    unowned let moduleOutput: DMTermsAndConditionsModuleOutput
    
    let isPrivacyPolicy: Bool
    
    init(isPrivacyPolicy: Bool, viewInput: DMTermsAndConditionsViewInput, moduleOutput: DMTermsAndConditionsModuleOutput) {
        self.isPrivacyPolicy = isPrivacyPolicy
        self.viewInput = viewInput
        self.moduleOutput = moduleOutput
    }
}

extension DMTermsAndConditionsPresenter: DMTermsAndConditionsModuleInput {
    
    func viewController() -> UIViewController {
        return viewInput.viewController()
    }
}

extension DMTermsAndConditionsPresenter: DMTermsAndConditionsViewOutput {
    
    func didLoad() {
        
        viewInput.configureWebView(isPrivacyPolicy: isPrivacyPolicy)
    }
}

extension DMTermsAndConditionsPresenter {
    
}

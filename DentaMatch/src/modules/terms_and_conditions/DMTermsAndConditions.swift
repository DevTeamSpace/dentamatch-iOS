import Foundation

protocol DMTermsAndConditionsModuleInput: BaseModuleInput {
    
}

protocol DMTermsAndConditionsModuleOutput: BaseModuleOutput {
    
}

protocol DMTermsAndConditionsViewInput: BaseViewInput {
    var viewOutput: DMTermsAndConditionsViewOutput? { get set }
    
    func configureWebView(isPrivacyPolicy: Bool)
}

protocol DMTermsAndConditionsViewOutput: BaseViewOutput {
    
    func didLoad()
}

protocol DMTermsAndConditionsPresenterProtocol: DMTermsAndConditionsModuleInput, DMTermsAndConditionsViewOutput {
    
}

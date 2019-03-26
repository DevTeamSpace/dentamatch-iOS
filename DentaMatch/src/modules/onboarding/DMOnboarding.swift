import Foundation

protocol DMOnboardingModuleInput: BaseModuleInput {
    
}

protocol DMOnboardingModuleOutput: BaseModuleOutput {
    
}

protocol DMOnboardingViewInput: BaseViewInput {
    var viewOutput: DMOnboardingViewOutput? { get set }
    
}

protocol DMOnboardingViewOutput: BaseViewOutput {
    
}

protocol DMOnboardingPresenterProtocol: DMOnboardingModuleInput, DMOnboardingViewOutput {
    
}

import Foundation

protocol DMRegistrationContainerModuleInput: BaseModuleInput {
    
}

protocol DMRegistrationContainerModuleOutput: BaseModuleOutput {
    
    func getLoginController() -> DMLoginModuleInput?
    func getRegistrationController() -> DMRegistrationModuleInput?
}

protocol DMRegistrationContainerViewInput: BaseViewInput {
    var viewOutput: DMRegistrationContainerViewOutput? { get set }
}

protocol DMRegistrationContainerViewOutput: BaseViewOutput {
    
    func getLoginController() -> DMLoginVC?
    func getRegistrationController() -> DMRegistrationVC?
}

protocol DMRegistrationContainerPresenterProtocol: DMRegistrationContainerModuleInput, DMRegistrationContainerViewOutput {
    
}

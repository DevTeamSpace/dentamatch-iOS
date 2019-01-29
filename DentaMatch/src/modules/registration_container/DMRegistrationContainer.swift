import Foundation

protocol DMRegistrationContainerModuleOutput: BaseModuleOutput {
    
    func getLoginController() -> DMLoginVC?
    func getRegistrationController() -> DMRegistrationVC?
}

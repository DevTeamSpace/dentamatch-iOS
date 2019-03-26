import Foundation

protocol DMLoginModuleInput: BaseModuleInput {
    
}

protocol DMLoginModuleOutput: BaseModuleOutput {
    
    func showForgotPassword()
    func showTabBar()
    func showJobTitleSelection()
}

protocol DMLoginViewInput: BaseViewInput {
    var viewOutput: DMLoginViewOutput? { get set }
    
}

protocol DMLoginViewOutput: BaseViewOutput {
    
    func openForgotPassword()
    func onLoginButtonTap(params: [String: String])
}

protocol DMLoginPresenterProtocol: DMLoginModuleInput, DMLoginViewOutput {
    
}

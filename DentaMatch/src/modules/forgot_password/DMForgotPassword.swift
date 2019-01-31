import Foundation

protocol DMForgotPasswordModuleInput: BaseModuleInput {
    
}

protocol DMForgotPasswordModuleOutput: BaseModuleOutput {
    
}

protocol DMForgotPasswordViewInput: BaseViewInput {
    var viewOutput: DMForgotPasswordViewOutput? { get set }
    
}

protocol DMForgotPasswordViewOutput: BaseViewOutput {
    
    func onSendButtonTap(params: [String: String])
}

protocol DMForgotPasswordPresenterProtocol: DMForgotPasswordModuleInput, DMForgotPasswordViewOutput {
    
}

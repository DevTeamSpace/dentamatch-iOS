import Foundation

protocol DMChangePasswordModuleInput: BaseModuleInput {
    
}

protocol DMChangePasswordModuleOutput: BaseModuleOutput {
    
}

protocol DMChangePasswordViewInput: BaseViewInput {
    var viewOutput: DMChangePasswordViewOutput? { get set }
}

protocol DMChangePasswordViewOutput: BaseViewOutput {
    
    func changePassword(passwords: [String])
}

protocol DMChangePasswordPresenterProtocol: DMChangePasswordModuleInput, DMChangePasswordViewOutput {
    
}

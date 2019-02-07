import Foundation

protocol DMSettingsModuleInput: BaseModuleInput {
    
}

protocol DMSettingsModuleOutput: BaseModuleOutput {
    
    func showLoginScreen()
    func showTermsAndConditions(isPrivacyPolicy: Bool)
    func showResetPassword()
    func showRegisterMaps(delegate: LocationAddressDelegate?)
}

protocol DMSettingsViewInput: BaseViewInput {
    var viewOutput: DMSettingsViewOutput? { get set }
}

protocol DMSettingsViewOutput: BaseViewOutput {
    
    func openLoginScreen()
    func openTermsAndConditions(isPrivacyPolicy: Bool)
    func openResetPassword()
    func openRegisterMaps(delegate: LocationAddressDelegate?)
    func signOut()
}

protocol DMSettingsPresenterProtocol: DMSettingsModuleInput, DMSettingsViewOutput {
    
}

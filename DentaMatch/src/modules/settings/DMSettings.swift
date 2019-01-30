import Foundation

protocol DMSettingsModuleOutput: BaseModuleOutput {
    
    func showLoginScreen()
    func showTermsAndConditions(isPrivacyPolicy: Bool)
    func showResetPassword()
    func showRegisterMaps(delegate: LocationAddressDelegate?)
}

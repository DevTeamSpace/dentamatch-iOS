import Foundation

protocol DMRegistrationModuleInput: BaseModuleInput {
    
}

protocol DMRegistrationModuleOutput: BaseModuleOutput {
    
    func showTermsAndConditions(isPrivacyPolicy: Bool)
    func showJobTitleSelection()
}

protocol DMRegistrationViewInput: BaseViewInput {
    var viewOutput: DMRegistrationViewOutput? { get set }
    
    func configurePickerView()
}

protocol DMRegistrationViewOutput: BaseViewOutput {
    var preferredLocations: [PreferredLocation] { get }
    var selectedPreferredLocation: PreferredLocation? { get set }
    
    func didLoad()
    func openTermsAndConditions(isPrivacyPolicy: Bool)
    func onRegisterButtonTap(params: [String: String])
}

protocol DMRegistrationPresenterProtocol: DMRegistrationModuleInput, DMRegistrationViewOutput {
    
}

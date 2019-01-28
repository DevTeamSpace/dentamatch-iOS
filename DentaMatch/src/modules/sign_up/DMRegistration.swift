import Foundation

protocol DMRegistrationModuleOutput: BaseModuleOutput {
    
    func showTermsAndConditions(isPrivacyPolicy: Bool)
    func showJobTitleSelection()
}

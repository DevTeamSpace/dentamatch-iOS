import Foundation

protocol DMJobTitleSelectionModuleOutput: BaseModuleOutput {
    
    func showTabBar()
    func showStates(preselectedState: String?, delegate: SearchStateViewControllerDelegate?)
    func showSuccessPending(isEmailVerified: Bool, isLicenseRequired: Bool, fromRoot: Bool)
}

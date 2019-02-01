import Foundation

protocol DMJobTitleSelectionModuleInput: BaseModuleInput {
    
}

protocol DMJobTitleSelectionModuleOutput: BaseModuleOutput {
    
    func showTabBar()
    func showStates(preselectedState: String?, delegate: SearchStateViewControllerDelegate?)
    func showSuccessPending(isEmailVerified: Bool, isLicenseRequired: Bool, fromRoot: Bool)
}

protocol DMJobTitleSelectionViewInput: BaseViewInput {
    var viewOutput: DMJobTitleSelectionViewOutput? { get set }
    
    func configureView(jobTitles: [JobTitle])
}

protocol DMJobTitleSelectionViewOutput: BaseViewOutput {
    var jobTitles: [JobTitle] { get }
    var selectedJobTitle: JobTitle? { get set }
    
    func didLoad()
    func onCreateProfileButtonTap(profileImage: UIImage?, params: [String: Any])
    func openStates(preselectedState: String?, delegate: SearchStateViewControllerDelegate?)
}

protocol DMJobTitleSelectionPresenterProtocol: DMJobTitleSelectionModuleInput, DMJobTitleSelectionViewOutput {
    
}

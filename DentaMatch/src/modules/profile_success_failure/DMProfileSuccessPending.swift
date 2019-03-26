import Foundation

protocol  DMProfileSuccessPendingModuleInput: BaseModuleInput {
    
}

protocol DMProfileSuccessPendingModuleOutput: BaseModuleOutput {
    
    func showCalendar(fromJobSelection: Bool)
}

protocol  DMProfileSuccessPendingViewInput: BaseViewInput {
    var viewOutput:  DMProfileSuccessPendingViewOutput? { get set }
    
    func configure(isEmailVerified: Bool, isLicenseRequired: Bool, fromRoot: Bool)
    func configureViewOnVerify(isVerified: Bool, message: String, silent: Bool)
}

protocol  DMProfileSuccessPendingViewOutput: BaseViewOutput {
    
    func didLoad()
    func verifyEmail(silent: Bool)
    func openCalendar()
}

protocol  DMProfileSuccessPendingPresenterProtocol:  DMProfileSuccessPendingModuleInput,  DMProfileSuccessPendingViewOutput {
    
}

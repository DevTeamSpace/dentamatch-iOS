import Foundation

protocol RootScreenModuleInput: BaseModuleInput {
    
}

protocol RootScreenModuleOutput: BaseModuleOutput {
    
    func showSuccessPendingScreen()
    func showProfile()
    func showDashboard()
    func showOnboarding()
    func showRegistration()
}

protocol RootScreenViewInput: BaseViewInput {
    var viewOutput: RootScreenViewOutput? { get set }
}

protocol RootScreenViewOutput: BaseViewOutput {
    
    func didAppear()
}

protocol RootScreenPresenterProtocol: RootScreenModuleInput, RootScreenViewOutput {
    
}

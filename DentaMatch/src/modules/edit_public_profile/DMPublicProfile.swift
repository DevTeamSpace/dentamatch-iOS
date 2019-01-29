import Foundation

protocol DMPublicProfileModuleOutput: BaseModuleOutput {
    
    func showStates(preselectedState: String?, delegate: SearchStateViewControllerDelegate?)
}

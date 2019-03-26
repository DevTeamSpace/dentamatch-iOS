import Foundation

protocol SearchStateModuleInput: BaseModuleInput {
    
}

protocol SearchStateModuleOutput: BaseModuleOutput {
    
}

protocol SearchStateViewInput: BaseViewInput {
    var viewOutput: SearchStateViewOutput? { get set }
    
    func configureView(preselectedState: String?, delegate: SearchStateViewControllerDelegate?)
    func updateStates(_ states: [State])
}

protocol SearchStateViewOutput: BaseViewOutput {
    var states: [State] { get }
    
    func didLoad()
}

protocol SearchStatePresenterProtocol: SearchStateModuleInput, SearchStateViewOutput {
    
}

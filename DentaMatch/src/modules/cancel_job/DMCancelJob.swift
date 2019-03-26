import Foundation

protocol DMCancelJobModuleInput: BaseModuleInput {
    
}

protocol DMCancelJobModuleOutput: BaseModuleOutput {
    
}

protocol DMCancelJobViewInput: BaseViewInput {
    var viewOutput: DMCancelJobViewOutput? { get set }
}

protocol DMCancelJobViewOutput: BaseViewOutput {
    
    func cancelJob(reason: String)
}

protocol DMCancelJobPresenterProtocol: DMCancelJobModuleInput, DMCancelJobViewOutput {
    
}

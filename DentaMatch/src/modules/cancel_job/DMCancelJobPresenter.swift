import Foundation
import SwiftyJSON

class DMCancelJobPresenter: DMCancelJobPresenterProtocol {
    
    unowned let viewInput: DMCancelJobViewInput
    unowned let moduleOutput: DMCancelJobModuleOutput
    
    let job: Job
    let fromApplied: Bool
    weak var delegate: CancelledJobDelegate?
    
    init(job: Job, fromApplied: Bool, delegate: CancelledJobDelegate, viewInput: DMCancelJobViewInput, moduleOutput: DMCancelJobModuleOutput) {
        self.job = job
        self.fromApplied = fromApplied
        self.delegate = delegate
        self.viewInput = viewInput
        self.moduleOutput = moduleOutput
    }
}

extension DMCancelJobPresenter: DMCancelJobModuleInput {
    
    func viewController() -> UIViewController {
        return viewInput.viewController()
    }
}

extension DMCancelJobPresenter: DMCancelJobViewOutput {
    
    func cancelJob(reason: String) {
        
        let params = [
            Constants.ServerKey.jobId: job.jobId,
            Constants.ServerKey.cancelReason: reason,
            ] as [String: Any]
        
        viewInput.showLoading()
        APIManager.apiPost(serviceName: Constants.API.cancelJob, parameters: params) { [weak self] (response: JSON?, error: NSError?) in
            
            self?.viewInput.hideLoading()
            if let error = error {
                self?.viewInput.show(toastMessage: error.localizedDescription)
                return
            }
            
            guard let response = response else {
                self?.viewInput.show(toastMessage: Constants.AlertMessage.somethingWentWrong)
                return
            }
            
            if response[Constants.ServerKey.status].boolValue {
                if let delegate = self?.delegate, let job = self?.job, let fromApplied = self?.fromApplied {
                    delegate.cancelledJob(job: job, fromApplied: fromApplied)
                }
                
                self?.viewInput.popViewController()
            }
        }
    }
}

extension DMCancelJobPresenter {
    
}

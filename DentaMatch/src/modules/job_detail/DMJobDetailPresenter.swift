import Foundation
import SwiftyJSON

class DMJobDetailPresenter: DMJobDetailPresenterProtocol {
    
    unowned let viewInput: DMJobDetailViewInput
    unowned let moduleOutput: DMJobDetailModuleOutput
    
    var job: Job?
    let fromTrack: Bool
    weak var delegate: JobSavedStatusUpdateDelegate?
    
    init(job: Job?, fromTrack: Bool, delegate: JobSavedStatusUpdateDelegate?, viewInput: DMJobDetailViewInput, moduleOutput: DMJobDetailModuleOutput) {
        self.job = job
        self.fromTrack = fromTrack
        self.delegate = delegate
        self.viewInput = viewInput
        self.moduleOutput = moduleOutput
    }
}

extension DMJobDetailPresenter: DMJobDetailModuleInput {
    
    func viewController() -> UIViewController {
        return viewInput.viewController()
    }
}

extension DMJobDetailPresenter: DMJobDetailViewOutput {
    
    func didLoad() {
        
        viewInput.configureView(job: job, fromTrack: fromTrack, delegate: delegate)
    }
    
    func fetchJob(params: [String : Any]) {
        
        viewInput.showLoading()
        APIManager.apiPost(serviceName: Constants.API.jobDetail, parameters: params) { [weak self] (response: JSON?, error: NSError?) in
            
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
                self?.viewInput.configureFetch(job: Job(job: response[Constants.ServerKey.result]))
            } else {
                self?.viewInput.show(toastMessage: response[Constants.ServerKey.message].stringValue)
            }
        }
    }
    
    func applyJob(params: [String : Any]) {
        
        // debugPrint("Search Parameters\n\(params.description))")
        viewInput.showLoading()
        APIManager.apiPost(serviceName: Constants.API.applyJob, parameters: params) { [weak self] (response: JSON?, error: NSError?) in
            
            self?.viewInput.hideLoading()
            if let error = error {
                self?.viewInput.show(toastMessage: error.localizedDescription)
                return
            }
            guard let response = response else {
                self?.viewInput.show(toastMessage: Constants.AlertMessage.somethingWentWrong)
                return
            }
            
            self?.viewInput.configureJobApply(response: response)
            NotificationCenter.default.post(name: .refreshMessageList, object: nil)
        }
    }
    
    func saveUnsave(job: Job?) {
        guard let job = job else { return }
        
        let status = job.isSaved == 1 ? 0 : 1
        
        let params = [
            Constants.ServerKey.jobId: job.jobId,
            Constants.ServerKey.status: status,
            ]
        
        viewInput.showLoading()
        APIManager.apiPost(serviceName: Constants.API.saveJob, parameters: params) { [weak self] (response: JSON?, error: NSError?) in
            
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
                
                self?.viewInput.configureSaveUnsave(status: status)
            }
        }
    }
}

extension DMJobDetailPresenter {
    
}

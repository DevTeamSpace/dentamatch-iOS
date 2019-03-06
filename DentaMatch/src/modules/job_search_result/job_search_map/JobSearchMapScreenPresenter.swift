import Foundation
import SwiftyJSON

class JobSearchMapScreenPresenter: JobSearchMapScreenPresenterProtocol {

    unowned let viewInput: JobSearchMapScreenViewInput
    unowned let moduleOutput: JobSearchMapScreenModuleOutput

    init(viewInput: JobSearchMapScreenViewInput, moduleOutput: JobSearchMapScreenModuleOutput) {
        self.viewInput = viewInput
        self.moduleOutput = moduleOutput
    }
    
    var jobs = [Job]()
}

extension JobSearchMapScreenPresenter: JobSearchMapScreenModuleInput {
    
    func viewController() -> UIViewController {
        return viewInput.viewController()
    }
    
    func populateWithJobs(jobs: [Job]) {
        self.jobs = jobs
        viewInput.reloadData()
    }
}

extension JobSearchMapScreenPresenter: JobSearchMapScreenViewOutput {

    func didLoad() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(saveUnsave(notification:)), name: .jobSavedUnsaved, object: nil)
    }
}

extension JobSearchMapScreenPresenter: JobMapDetailViewDelegate {
    
    func onFavoriteButtonTapped(jobIndex: Int) {
        guard jobIndex != -1 else { return }
        
        saveOrUnsaveJob(index: jobIndex)
    }
    
    func onDetailViewTapped(jobIndex: Int) {
        guard jobIndex != -1 else { return }
        
        moduleOutput.openJobDetail(job: jobs[jobIndex])
    }
}

extension JobSearchMapScreenPresenter {
    
    @objc private func saveUnsave(notification: Notification) {
        guard let job = notification.object as? Job, job.jobId != 0,
            let index = jobs.firstIndex(where: { $0.jobId == job.jobId }) else { return }
        
        viewInput.updateDetailView(with: job, index: index)
    }
    
    private func saveOrUnsaveJob(index: Int) {
        let job = jobs[index]
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
                job.isSaved = status
                self?.jobs.remove(at: index)
                self?.jobs.insert(job, at: index)
                NotificationCenter.default.post(name: .refreshSavedJobs, object: nil, userInfo: nil)
                NotificationCenter.default.post(name: .jobSavedUnsaved, object: job, userInfo: nil)
            }
        }
    }
}


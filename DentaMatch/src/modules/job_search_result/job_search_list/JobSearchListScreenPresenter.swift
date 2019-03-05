import Foundation
import SwiftyJSON

class JobSearchListScreenPresenter: JobSearchListScreenPresenterProtocol {

    unowned let viewInput: JobSearchListScreenViewInput
    unowned let moduleOutput: JobSearchListScreenModuleOutput

    init(viewInput: JobSearchListScreenViewInput, moduleOutput: JobSearchListScreenModuleOutput) {
        self.viewInput = viewInput
        self.moduleOutput = moduleOutput
    }
    
    var page = 1
    var jobs = [Job]()
    var totalJobs = 0
    var loadingMoreJobs = false
}

extension JobSearchListScreenPresenter: JobSearchListScreenModuleInput {
    
    func viewController() -> UIViewController {
        return viewInput.viewController()
    }
}

extension JobSearchListScreenPresenter: JobSearchListScreenViewOutput {

    func didLoad() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(saveUnsave(notification:)), name: .jobSavedUnsaved, object: nil)
        getJobs(true)
    }
    
    func refreshData(_ showLoading: Bool) {
        page = 1
        getJobs(showLoading)
    }
    
    func openJobDetail(job: Job?, delegate: JobSavedStatusUpdateDelegate?) {
        moduleOutput.openJobDetail(job: job, delegate: delegate)
    }
    
    func loadMore(willDisplay index: Int) {
        guard index == jobs.count - 2, !loadingMoreJobs, totalJobs > jobs.count else { return }
        
        loadingMoreJobs = true
        viewInput.addLoaderFooter()
        getJobs(false)
    }
}

extension JobSearchListScreenPresenter {
    
    private func getJobs(_ showLoading: Bool) {
        var params: [String: Any] = UserDefaultsManager.sharedInstance.loadSearchParameter() ?? [:]
        params[Constants.JobDetailKey.page] = "\(page)"
        
        if showLoading {
            viewInput.showLoading()
        }
        
        APIManager.apiPostWithJSONEncode(serviceName: Constants.API.JobSearchResultAPI, parameters: params) { [weak self] (response: JSON?, error: NSError?) in
            
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
                
                let result = response[Constants.ServerKey.result]
                
                if result["isJobSeekerVerified"].stringValue == "0" || result["isJobSeekerVerified"].stringValue == "2"{
                    self?.moduleOutput.showWarningView(status: 1)
                } else if result["profileCompleted"].stringValue == "0" {
                    self?.moduleOutput.showWarningView(status: 2)
                }
                
                if result["isJobSeekerVerified"].stringValue == "1" && result["profileCompleted"].stringValue == "1" {
                    self?.moduleOutput.hideWarningView()
                }
                
                let skillList = response[Constants.ServerKey.result][Constants.ServerKey.joblist].array
                
                if self?.page == 1 {
                    self?.jobs.removeAll()
                }
                
                for jobObject in skillList! {
                    let job = Job(job: jobObject)
                    self?.jobs.append(job)
                }
                
                self?.totalJobs = response[Constants.ServerKey.result]["total"].intValue
                self?.page += 1
            } else {
                self?.totalJobs = 0
                self?.viewInput.show(toastMessage: response[Constants.ServerKey.message].stringValue)
            }
            
            if let jobs = self?.jobs {
                self?.moduleOutput.currentJobList(jobs: jobs)
            }
            self?.loadingMoreJobs = false
            self?.updateUI()
        }
    }
    
    private func updateUI() {
        
        viewInput.reloadData()
    }
    
    @objc private func saveUnsave(notification: Notification) {
        guard let job = notification.object as? Job, job.jobId != 0 else { return }
        jobUpdate(job: job)
    }
}

extension JobSearchListScreenPresenter: JobSavedStatusUpdateDelegate {
    
    func jobUpdate(job: Job) {
        guard let jobForUpdate = jobs.enumerated().first(where: { $1.jobId == job.jobId }) else { return }
        jobForUpdate.element.isSaved = job.isSaved
        viewInput.reloadAt([IndexPath(row: jobForUpdate.offset, section: 0)])
    }
}

extension JobSearchListScreenPresenter: JobSearchResultCellDelegate {
    
    func saveOrUnsaveJob(index: Int) {
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
                self?.viewInput.reloadAt([IndexPath(row: index, section: 0)])
                NotificationCenter.default.post(name: .refreshSavedJobs, object: nil, userInfo: nil)
            }
        }
    }
}


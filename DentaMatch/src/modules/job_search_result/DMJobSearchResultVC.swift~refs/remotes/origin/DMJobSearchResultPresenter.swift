import Foundation
import SwiftyJSON

class DMJobSearchResultPresenter: DMJobSearchResultPresenterProtocol {
    
    unowned let viewInput: DMJobSearchResultViewInput
    unowned let moduleOutput: DMJobSearchResultModuleOutput
    
    init(viewInput: DMJobSearchResultViewInput, moduleOutput: DMJobSearchResultModuleOutput) {
        self.viewInput = viewInput
        self.moduleOutput = moduleOutput
    }
    
    var jobs = [Job]()
    var totalJobsFromServer = 0
    var jobsPageNo = 0
    var bannerStatus = -1
}

extension DMJobSearchResultPresenter: DMJobSearchResultModuleInput {
    
    func viewController() -> UIViewController {
        return viewInput.viewController()
    }
}

extension DMJobSearchResultPresenter: DMJobSearchResultViewOutput {
    
    func openNotifications() {
        moduleOutput.showNotifications()
    }
    
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
    
    func openJobDetail(job: Job?, delegate: JobSavedStatusUpdateDelegate?) {
        moduleOutput.showJobDetail(job: job, delegate: delegate)
    }
    
    func fetchSearchResult(params: [String : Any]) {
        
        if jobsPageNo == 1 {
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
                    self?.viewInput.showBanner(status: 1)
                } else if result["profileCompleted"].stringValue == "0" {
                    self?.viewInput.showBanner(status: 2)
                }
                
                if result["isJobSeekerVerified"].stringValue == "1" && result["profileCompleted"].stringValue == "1" {
                    self?.bannerStatus = 3 // approved
                    self?.viewInput.hideBanner()
                }
                
                let skillList = response[Constants.ServerKey.result][Constants.ServerKey.joblist].array
                
                if self?.jobsPageNo == 1 {
                    self?.jobs.removeAll()
                }
                
                for jobObject in skillList! {
                    let job = Job(job: jobObject)
                    self?.jobs.append(job)
                }
                
                
                
                self?.totalJobsFromServer = response[Constants.ServerKey.result]["total"].intValue
                self?.jobsPageNo += 1
                
                self?.viewInput.configureTableView(jobsCount: self?.jobs.count ?? 0, totalJobsCount: self?.totalJobsFromServer ?? 0, status: true)
            } else {
                
                self?.jobs.removeAll()
                self?.viewInput.configureTableView(jobsCount: 0, totalJobsCount: 0, status: false)
                self?.viewInput.show(toastMessage: response[Constants.ServerKey.message].stringValue)
            }
        }
    }
    
    func openJobSearch(fromJobResult: Bool, delegate: SearchJobDelegate) {
        moduleOutput.showJobSearch(fromJobResult: fromJobResult, delegate: delegate)
    }
    
    func getUnreadedNotifications() {
        
        APIManager.apiGet(serviceName: Constants.API.unreadNotificationCount, parameters: nil) { [weak self] (response: JSON?, error: NSError?) in
            
            if let error = error {
                self?.viewInput.show(toastMessage: error.localizedDescription)
                return
            }
            
            if let response = response, let resultDic = response[Constants.ServerKey.result].dictionary {
                let count = resultDic["notificationCount"]?.intValue
                AppDelegate.delegate().setAppBadgeCount(count ?? 0)
                self?.viewInput.updateBadge(count: count ?? 0)
            }
        }
    }
}

extension DMJobSearchResultPresenter {
    
}

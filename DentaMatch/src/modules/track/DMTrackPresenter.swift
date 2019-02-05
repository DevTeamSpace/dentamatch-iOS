import Foundation
import SwiftyJSON

enum PTRType {
    case saved
    case applied
    case shortlisted
}

class DMTrackPresenter: DMTrackPresenterProtocol {
    
    unowned let viewInput: DMTrackViewInput
    unowned let moduleOutput: DMTrackModuleOutput
    
    init(viewInput: DMTrackViewInput, moduleOutput: DMTrackModuleOutput) {
        self.viewInput = viewInput
        self.moduleOutput = moduleOutput
    }
    
    var loadingMoreSavedJobs = false
    var loadingMoreAppliedJobs = false
    var loadingMoreShortListedJobs = false
    
    var savedJobs = [Job]()
    var appliedJobs = [Job]()
    var shortListedJobs = [Job]()
    var savedJobsPageNo = 1
    var appliedJobsPageNo = 1
    var shortListedJobsPageNo = 1
    var totalSavedJobsFromServer = 0
    var totalAppliedJobsFromServer = 0
    var totalShortListedJobsFromServer = 0
    
    var isFromJobDetailApplied = false
    var lat = ""
    var long = ""
    
    var jobParams = [String: String]()
}

extension DMTrackPresenter: DMTrackModuleInput {
    
    func viewController() -> UIViewController {
        return viewInput.viewController()
    }
}

extension DMTrackPresenter: DMTrackViewOutput {
    
    func didLoad() {
        
        if let params = UserDefaultsManager.sharedInstance.loadSearchParameter() {
            lat = params[Constants.JobDetailKey.lat] as? String ?? "0"
            long = params[Constants.JobDetailKey.lng] as? String ?? "0"
        }
        
        jobParams = [
            "type": "1",
            "page": "1",
            "lat": lat,
            "lng": long,
        ]
        
        getJobList(params: jobParams)
    }
    
    func refreshData(type: PTRType) {
        
        switch type {
            
        case .saved:
            savedJobsPageNo = 1
            jobParams["type"] = "1"
            jobParams["page"] = "1"
            jobParams["lat"] = lat
            jobParams["lng"] = long
            loadingMoreSavedJobs = false
        case .applied:
            appliedJobsPageNo = 1
            jobParams["type"] = "2"
            jobParams["page"] = "1"
            jobParams["lat"] = lat
            jobParams["lng"] = long
            loadingMoreAppliedJobs = false
        case .shortlisted:
            shortListedJobsPageNo = 1
            jobParams["type"] = "3"
            jobParams["page"] = "1"
            jobParams["lat"] = lat
            jobParams["lng"] = long
            loadingMoreShortListedJobs = false
        }
        
        getJobList(params: jobParams)
    }
    
    func switchToType(_ type: PTRType) {
        
        switch type {
            
        case .saved:
            viewInput.configureEmptyView(isHidden: savedJobs.count != 0, message: nil)
            
            if savedJobsPageNo == 1 {
                jobParams["type"] = "1"
                jobParams["page"] = "1"
                getJobList(params: jobParams)
            } else {
                viewInput.reloadData()
            }
        case .applied:
            viewInput.configureEmptyView(isHidden: appliedJobs.count != 0, message: nil)
            if appliedJobsPageNo == 1 {
                jobParams["type"] = "2"
                jobParams["page"] = "1"
                getJobList(params: jobParams)
            } else {
                viewInput.reloadData()
            }
        case .shortlisted:
            viewInput.configureEmptyView(isHidden: shortListedJobs.count != 0, message: nil)
            if shortListedJobsPageNo == 1 {
                jobParams["type"] = "3"
                jobParams["page"] = "1"
                getJobList(params: jobParams)
            } else {
                viewInput.reloadData()
            }
        }
    }
    
    func openCancelJob(index: Int, type: PTRType, fromApplied: Bool, delegate: CancelledJobDelegate) {
        var job: Job
        
        switch type {
        case .saved:
            job = savedJobs[index]
        case .applied:
            job = appliedJobs[index]
        case .shortlisted:
            job = shortListedJobs[index]
        }
        
        moduleOutput.showCancelJob(job: job, fromApplied: fromApplied, delegate: delegate)
    }
    
    func openJobDetails(index: Int, type: PTRType, delegate: JobSavedStatusUpdateDelegate) {
        var job: Job
        
        switch type {
        case .saved:
            job = savedJobs[index]
        case .applied:
            job = appliedJobs[index]
        case .shortlisted:
            job = shortListedJobs[index]
        }
        
        moduleOutput.showJobDetails(job: job, delegate: delegate)
    }
    
    func jobUpdate(_ job: Job) {
        guard let firstJob = savedJobs.filter({ $0.jobId == job.jobId }).first else { return }
        
        firstJob.isSaved = job.isSaved
        savedJobs.removeObject(object: firstJob)
        totalSavedJobsFromServer -= 1
        viewInput.reloadData()
    }
    
    func jobApplied() {
        isFromJobDetailApplied = true
        appliedJobs.removeAll()
        appliedJobsPageNo = 1
    }
    
    func saveUnsaveJob(status: Int, index: Int) {
        
        let job = savedJobs[index]
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
                // Save Unsave success
                // debugPrint(response)
                job.isSaved = 0
                self?.savedJobs.remove(at: index)
                if self?.savedJobs.count == 0 {
                    self?.savedJobsPageNo = 1
                    self?.viewInput.configureEmptyView(isHidden: false, message: "You don’t have any saved jobs")
                }
                
                self?.totalSavedJobsFromServer -= 1
                self?.viewInput.reloadData()
                
                NotificationCenter.default.post(name: .jobSavedUnsaved, object: job, userInfo: nil)
            }
        }
    }
    
    func cancelledJob(_ job: Job, fromApplied: Bool) {
        
        if fromApplied {
            appliedJobs.removeObject(object: job)
            totalAppliedJobsFromServer -= 1
            viewInput.reloadData()
            if appliedJobs.count == 0 {
                appliedJobsPageNo = 1
                viewInput.configureEmptyView(isHidden: false, message: "You don’t have any applied jobs")
            } else {
                viewInput.configureEmptyView(isHidden: true, message: nil)
            }
        } else {
            shortListedJobs.removeObject(object: job)
            totalShortListedJobsFromServer -= 1
            viewInput.reloadData()
            if shortListedJobs.count == 0 {
                shortListedJobsPageNo = 1
                viewInput.configureEmptyView(isHidden: false, message: "You don’t have any interviewing jobs")
            } else {
                viewInput.configureEmptyView(isHidden: true, message: nil)
            }
        }
    }
    
    func callLoadMore(type: Int) {
        
        if type == 1 {
            if loadingMoreSavedJobs == true {
                return
            } else {
                if totalSavedJobsFromServer > savedJobs.count {
                    viewInput.addLoadingCell(to: .saved)
                    loadingMoreSavedJobs = true
                    jobParams["type"] = "\(type)"
                    jobParams["page"] = "\(savedJobsPageNo)"
                    getJobList(params: jobParams)
                }
            }
        } else if type == 2 {
            if loadingMoreAppliedJobs == true {
                return
            } else {
                if totalAppliedJobsFromServer > appliedJobs.count {
                    viewInput.addLoadingCell(to: .applied)
                    loadingMoreAppliedJobs = true
                    jobParams["type"] = "\(type)"
                    jobParams["page"] = "\(appliedJobsPageNo)"
                    getJobList(params: jobParams)
                }
            }
        } else {
            if loadingMoreShortListedJobs == true {
                return
            } else {
                if totalShortListedJobsFromServer > shortListedJobs.count {
                    viewInput.addLoadingCell(to: .shortlisted)
                    loadingMoreShortListedJobs = true
                    jobParams["type"] = "\(type)"
                    jobParams["page"] = "\(shortListedJobsPageNo)"
                    getJobList(params: jobParams)
                }
            }
        }
    }
}

extension DMTrackPresenter {
    
    private func getJobList(params: [String: String]) {
        
        // Loader management as we don't have to show loader in load more case
        if params["type"] == "1" {
            if savedJobsPageNo == 1 {
                viewInput.showLoading()
            }
        } else if params["type"] == "2" {
            if appliedJobsPageNo == 1 {
                viewInput.showLoading()
            }
        } else {
            if shortListedJobsPageNo == 1 {
                viewInput.showLoading()
            }
        }
        
        APIManager.apiGet(serviceName: Constants.API.jobList, parameters: params) { [weak self] (response: JSON?, error: NSError?) in
            
            self?.viewInput.hideLoading()
            
            if let error = error {
                self?.viewInput.show(toastMessage: error.localizedDescription)
                return
            }
            
            guard let response = response, let type = params["type"] else {
                self?.viewInput.show(toastMessage: Constants.AlertMessage.somethingWentWrong)
                return
            }
            
            if response[Constants.ServerKey.status].boolValue {
                if type == "1" {
                    // Saved Jobs
                    if self?.savedJobsPageNo == 1 {
                        self?.savedJobs.removeAll()
                    }
                    
                    self?.totalSavedJobsFromServer = response[Constants.ServerKey.result]["total"].intValue
                    let jobsArray = response[Constants.ServerKey.result][Constants.ServerKey.list].arrayValue
                    for job in jobsArray {
                        let job = Job(job: job)
                        self?.savedJobs.append(job)
                    }
                    
                    self?.savedJobsPageNo += 1
                    self?.loadingMoreSavedJobs = false
                    self?.viewInput.configureEmptyView(isHidden: self?.savedJobs.count != 0, message: nil)
                    self?.viewInput.reloadData()
                    
                } else if type == "2" {
                    // Applied jons
                    if self?.appliedJobsPageNo == 1 {
                        self?.appliedJobs.removeAll()
                    }
                    
                    self?.totalAppliedJobsFromServer = response[Constants.ServerKey.result]["total"].intValue
                    
                    let jobsArray = response[Constants.ServerKey.result][Constants.ServerKey.list].arrayValue
                    for job in jobsArray {
                        let job = Job(job: job)
                        self?.appliedJobs.append(job)
                    }
                    
                    self?.appliedJobsPageNo += 1
                    self?.loadingMoreAppliedJobs = false
                    self?.viewInput.configureEmptyView(isHidden: self?.appliedJobs.count != 0, message: nil)
                    self?.viewInput.reloadData()
                    
                } else if type == "3" {
                    // Shortlisted jobs
                    if self?.shortListedJobsPageNo == 1 {
                        self?.shortListedJobs.removeAll()
                    }
                    
                    self?.totalShortListedJobsFromServer = response[Constants.ServerKey.result]["total"].intValue
                    
                    let jobsArray = response[Constants.ServerKey.result][Constants.ServerKey.list].arrayValue
                    for job in jobsArray {
                        let job = Job(job: job)
                        self?.shortListedJobs.append(job)
                    }
                    
                    self?.shortListedJobsPageNo += 1
                    self?.loadingMoreShortListedJobs = false
                    self?.viewInput.configureEmptyView(isHidden: self?.shortListedJobs.count != 0, message: nil)
                    self?.viewInput.reloadData()
                }
            } else {
                if type == "1" {
                    if response[Constants.ServerKey.statusCode] == 201 {
                        
                        self?.loadingMoreSavedJobs = false
                        if self?.savedJobsPageNo == 1 {
                            self?.savedJobs.removeAll()
                        }
                        
                        
                        self?.viewInput.configureEmptyView(isHidden: self?.savedJobs.count != 0, message: nil)
                        self?.viewInput.reloadData()
                    } else {
                        self?.viewInput.show(toastMessage: response[Constants.ServerKey.message].stringValue)
                    }
                    
                } else if type == "2" {
                    if response[Constants.ServerKey.statusCode] == 201 {
                        
                        self?.loadingMoreAppliedJobs = false
                        if self?.appliedJobsPageNo == 1 {
                            self?.appliedJobs.removeAll()
                        }
                        
                        self?.viewInput.configureEmptyView(isHidden: self?.appliedJobs.count != 0, message: nil)
                        self?.viewInput.reloadData()
                    } else {
                        self?.viewInput.show(toastMessage: response[Constants.ServerKey.message].stringValue)
                    }
                    
                } else {
                    if response[Constants.ServerKey.statusCode] == 201 {
                        
                        self?.loadingMoreShortListedJobs = false
                        if self?.shortListedJobsPageNo == 1 {
                            self?.shortListedJobs.removeAll()
                        }
                        
                        self?.viewInput.configureEmptyView(isHidden: self?.shortListedJobs.count != 0, message: nil)
                        self?.viewInput.reloadData()
                    } else {
                        self?.viewInput.show(toastMessage: response[Constants.ServerKey.message].stringValue)
                    }
                }
            }
        }
    }
}

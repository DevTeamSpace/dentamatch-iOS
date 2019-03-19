import Foundation
import SwiftyJSON

class DMJobDetailPresenter: DMJobDetailPresenterProtocol {
    
    unowned let viewInput: DMJobDetailViewInput
    unowned let moduleOutput: DMJobDetailModuleOutput
    
    var job: Job?
    var fromTrack: Bool
    var notificationId: String?
    weak var delegate: JobSavedStatusUpdateDelegate?
    
    init(job: Job?, notificationId: String?, fromTrack: Bool, delegate: JobSavedStatusUpdateDelegate?, viewInput: DMJobDetailViewInput, moduleOutput: DMJobDetailModuleOutput) {
        self.job = job
        self.notificationId = notificationId
        self.fromTrack = fromTrack
        self.delegate = delegate
        self.viewInput = viewInput
        self.moduleOutput = moduleOutput
    }
    
    var jobDetailParams = [String: Any]()
}

extension DMJobDetailPresenter: DMJobDetailModuleInput {
    
    func viewController() -> UIViewController {
        return viewInput.viewController()
    }
}

extension DMJobDetailPresenter: DMJobDetailViewOutput {

    func didLoad() {
        jobDetailParams = [
            Constants.ServerKey.jobId: job?.jobId ?? 0,
        ]
        if let job = job {
            viewInput.configureFetch(job: job)
        }
        fetchJob(params: jobDetailParams)
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
                self?.job = Job(job: response[Constants.ServerKey.result])
                self?.viewInput.configureFetch(job: Job(job: response[Constants.ServerKey.result]))
            } else {
                self?.viewInput.show(toastMessage: response[Constants.ServerKey.message].stringValue)
            }
        }
    }
    
    func onBottomButtonTapped() {
        guard let job = job else { return }
        
        if job.jobType == 3, let notificationId = notificationId {
            
            viewInput.showLoading()
            APIManager.apiPost(serviceName: Constants.API.acceptRejectNotification, parameters: ["notificationId": notificationId, "acceptStatus": 1]) { [weak self] (response: JSON?, error: NSError?) in
                
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
                    self?.viewInput.showAlertMessage(title: Constants.AlertMessage.congratulations, body: Constants.AlertMessage.jobAccepted)
                    self?.job?.isApplied = 4
                    self?.viewInput.configureJobApply()
                    self?.moduleOutput.refreshNotificationList()
                    NotificationCenter.default.post(name: .decreaseBadgeCount, object: nil, userInfo: nil)
                } else {
                    
                    if response[Constants.ServerKey.statusCode].intValue == 201 {
                        
                        self?.viewInput.showAlertMessage(title: "Change Availability", body: response[Constants.ServerKey.message].stringValue)
                    } else {
                        
                        self?.viewInput.show(toastMessage: response[Constants.ServerKey.message].stringValue)
                    }
                }
            }
        } else {
            
            viewInput.showLoading()
            APIManager.apiPost(serviceName: Constants.API.applyJob, parameters: jobDetailParams) { [weak self] (response: JSON?, error: NSError?) in
                
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
                    self?.viewInput.showAlertMessage(title: Constants.AlertMessage.congratulations, body: Constants.AlertMessage.jobApplied)
                    self?.job?.isApplied = 2
                    if let delegate = self?.delegate {
                        if self?.fromTrack == true, let job = self?.job {
                            delegate.jobApplied!(job: job)
                        }
                    }
                    
                    self?.viewInput.configureJobApply()
                    
                } else {
                    if response[Constants.ServerKey.statusCode].intValue == 200 {
                        self?.viewInput.showAlertMessage(title: "", body: response[Constants.ServerKey.message].stringValue)
                    } else {
                        DispatchQueue.main.async {
                            kAppDelegate?.showOverlay(isJobSeekerVerified: true)
                        }
                    }
                }
                NotificationCenter.default.post(name: .refreshMessageList, object: nil)
            }
        }
    }
    
    func saveUnsave() {
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
                
                self?.job?.isSaved = status
                if let delegate = self?.delegate, let job = self?.job {
                    delegate.jobUpdate!(job: job)
                }
                
                self?.viewInput.reloadRows(at: [IndexPath(row: 0, section: 0)])
                NotificationCenter.default.post(name: .refreshSavedJobs, object: nil, userInfo: nil)
                NotificationCenter.default.post(name: .jobSavedUnsaved, object: self?.job, userInfo: nil)
            }
        }
    }
    
    func openChat(chatObject: ChatObject) {
        moduleOutput.presentChat(chatObject: chatObject)
    }
}

extension DMJobDetailPresenter {
    
}

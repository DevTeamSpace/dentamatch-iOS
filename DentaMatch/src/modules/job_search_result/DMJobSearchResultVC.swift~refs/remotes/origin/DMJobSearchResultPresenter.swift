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

extension DMJobSearchResultPresenter: JobSearchListScreenModuleOutput {
    
    func showWarningView(status: Int) {
        viewInput.showBanner(status: status)
    }
    
    func hideWarningView() {
        viewInput.hideBanner()
    }

    func openJobDetail(job: Job?, delegate: JobSavedStatusUpdateDelegate?) {
        moduleOutput.showJobDetail(job: job, delegate: delegate)
    }
    
    func currentJobList(jobs: [Job]) {
        viewInput.updateMapMarkers(jobs: jobs)
    }
}

extension DMJobSearchResultPresenter: DMJobSearchResultViewOutput {
    
    func didLoad() {
        NotificationCenter.default.addObserver(self, selector: #selector(pushRediectNotificationOtherAll), name: .pushRedirectNotificationAllForground, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(pushRediectNotificationOtherAllBackGround), name: .pushRedirectNotificationAllBackGround, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(pushRediectNotificationForJobDetailForground), name: .pushRedirectNotificationForground, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(pushRediectNotificationForJobDetailBacground), name: .pushRedirectNotificationBacground, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(bannerUIStatus(_:)), name: .pushRedirectNotificationForProfile, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(decreaseBadgeCount(_:)), name: .decreaseBadgeCount, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(fetchBadgeCount(_:)), name: .fetchBadgeCount, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(bannerUIStatus(_:)), name: .profileUpdated, object: nil)
        
        fetchBadgeCount()
    }
    
    func openJobSearch(fromJobResult: Bool, delegate: SearchJobDelegate) {
        moduleOutput.showJobSearch(fromJobResult: fromJobResult, delegate: delegate)
    }
}

extension DMJobSearchResultPresenter {
    
    func fetchBadgeCount () {
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
    
    @objc func bannerUIStatus(_ userInfo: Notification){
        viewInput.refreshJobList()
    }
    
    @objc func pushRediectNotificationOtherAll(userInfo _: Notification) {
        moduleOutput.showNotifications()
    }
    
    @objc func pushRediectNotificationOtherAllBackGround(userInfo _: Notification) {
        moduleOutput.showNotifications()
    }
    
    @objc func pushRediectNotificationForJobDetailForground(userInfo: Notification) {
        let dict = userInfo.userInfo
        if let notification = dict?["notificationData"], let notiObj = notification as? Job {
            moduleOutput.showJobDetail(job: notiObj, delegate: nil)
        }
    }
    
    @objc func pushRediectNotificationForJobDetailBacground(userInfo: Notification) {
        let dict = userInfo.userInfo
        if let notification = dict?["notificationData"], let notiObj = notification as? Job  {
            moduleOutput.showJobDetail(job: notiObj, delegate: nil)
        }
    }
    
    @objc func fetchBadgeCount(_ notification: Notification) {
        self.fetchBadgeCount()
    }
    
    @objc func decreaseBadgeCount(_ notification: Notification) {
        AppDelegate.delegate().decrementBadgeCount()
        self.fetchBadgeCount()
    }
}

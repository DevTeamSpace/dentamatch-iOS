import Foundation
import UIKit
import Swinject

protocol JobsFlowCoordinatorProtocol: BaseFlowProtocol {
    
}

protocol JobsFlowCoordinatorDelegate: class {
    
    func selectTabBarIndex(_ idx: Int)
}

class JobsFlowCoordinator: BaseFlowCoordinator, JobsFlowCoordinatorProtocol {
    
    weak var navigationController: UINavigationController?
    unowned let delegate: JobsFlowCoordinatorDelegate
    
    init(delegate: JobsFlowCoordinatorDelegate) {
        self.delegate = delegate
    }
    
    func launchViewController() -> UIViewController? {
        guard let moduleInput = DMJobSearchResultInitializer.initialize(moduleOutput: self) else { return nil }
        
        let navController = UINavigationController(rootViewController: moduleInput.viewController())
        navigationController = navController
        return navController
    }
}

extension JobsFlowCoordinator: DMJobSearchResultModuleOutput {
    
    func showJobDetail(job: Job?, delegate: JobSavedStatusUpdateDelegate?) {
        guard let moduleInput = DMJobDetailInitializer.initialize(job: job, delegate: delegate, moduleOutput: self) else { return }
        let vc = moduleInput.viewController()
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func showJobSearch(fromJobResult: Bool, delegate: SearchJobDelegate) {
        guard let moduleInput = DMJobSearchInitializer.initialize(fromJobResult: fromJobResult, delegate: delegate, moduleOutput: self) else { return }
        let vc = moduleInput.viewController()
        vc.hidesBottomBarWhenPushed = true
        self.delegate.selectTabBarIndex(0)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func showNotifications() {
        guard let moduleInput = DMNotificationInitializer.initialize(moduleOutput: self) else { return }
        let vc = moduleInput.viewController()
        
        vc.hidesBottomBarWhenPushed = true
        delegate.selectTabBarIndex(0)
        
        navigationController?.popToRootViewController(animated: false)
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension JobsFlowCoordinator: DMJobDetailModuleOutput {
    func refreshNotificationList() {
        
    }
}

extension JobsFlowCoordinator: DMJobSearchModuleOutput {
    
    func showJobTitle(selectedTitles: [JobTitle]?, isLocation: Bool, locations: [PreferredLocation]?, delegate: DMJobTitleVCDelegate) {
        guard let moduleInput = DMJobTitleInitializer.initialize(selectedTitles: selectedTitles, forLocation: isLocation, locations: locations, delegate: delegate, moduleOutput: self) else { return }
        let vc = moduleInput.viewController()
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension JobsFlowCoordinator: DMJobTitleModuleOutput {
    
    
}

extension JobsFlowCoordinator: DMNotificationsModuleOutput {
    func showJobDetails(job: Job?, recruiterId: String?, notificationId: String?, availableDates: [Date]?) {
        showJobDetail(job: job, delegate: nil)
    }
    
    func presentChat(chatObject: ChatObject) {
        guard let moduleInput = DMChatInitializer.initialize(chatObject: chatObject, moduleOutput: self) else { return }
        navigationController?.present(moduleInput.viewController(), animated: true)
    }
    
    func showDaySelect(selectedDates: [Date], notificationId: Int) {
        let (mI, vC) = DaySelectScreenInitializer.initialize(selectedDates: selectedDates, notificationId: notificationId, moduleOutput: self)
        guard let moduleInput = mI, let vc = vC else { return }
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension JobsFlowCoordinator: DMChatModuleOutput {
    
}

extension JobsFlowCoordinator: DaySelectScreenModuleOutput {
    func updateAfterAcception() {
        
    }
}

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
        guard let vc = DMJobSearchResultInitializer.initialize(moduleOutput: self) else { return nil }
        
        let navController = UINavigationController(rootViewController: vc)
        navigationController = navController
        return navController
    }
}

extension JobsFlowCoordinator: DMJobSearchResultModuleOutput {
    
    func showJobDetail(job: Job?, delegate: JobSavedStatusUpdateDelegate?) {
        guard let vc = DMJobDetailInitializer.initialize(job: job, delegate: delegate, moduleOutput: self) else { return }
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func showJobSearch(fromJobResult: Bool, delegate: SearchJobDelegate) {
        guard let vc = DMJobSearchInitializer.initialize(fromJobResult: fromJobResult, delegate: delegate, moduleOutput: self) else { return }
        vc.hidesBottomBarWhenPushed = true
        self.delegate.selectTabBarIndex(0)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func showNotifications() {
        guard let vc = DMNotificationInitializer.initialize(moduleOutput: self) else { return }
        
        vc.hidesBottomBarWhenPushed = true
        delegate.selectTabBarIndex(0)
        
        navigationController?.popToRootViewController(animated: false)
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension JobsFlowCoordinator: DMJobDetailModuleOutput {
    
    
}

extension JobsFlowCoordinator: DMJobSearchModuleOutput {
    
    func showJobTitle(selectedTitles: [JobTitle]?, isLocation: Bool, locations: [PreferredLocation]?, delegate: DMJobTitleVCDelegate) {
        guard let vc = DMJobTitleInitializer.initialize(selectedTitles: selectedTitles, forLocation: isLocation, locations: locations, delegate: delegate, moduleOutput: self) else { return }
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension JobsFlowCoordinator: DMJobTitleModuleOutput {
    
    
}

extension JobsFlowCoordinator: DMNotificationsModuleOutput {
    
    func showJobDetails(job: Job?) {
        showJobDetail(job: job, delegate: nil)
    }
}

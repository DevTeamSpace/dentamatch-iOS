import Foundation
import UIKit
import Swinject

protocol TrackFlowCoordinatorProtocol: BaseFlowProtocol {
    
}

protocol TrackFlowCoordinatorDelegate: class {
    
}

class TrackFlowCoordinator: BaseFlowCoordinator, TrackFlowCoordinatorProtocol {
    
    weak var navigationController: UINavigationController?
    unowned let delegate: TrackFlowCoordinatorDelegate
    
    init(delegate: TrackFlowCoordinatorDelegate) {
        self.delegate = delegate
    }
    
    func launchViewController() -> UIViewController? {
        guard let vc = DMTrackInitializer.initialize(moduleOutput: self) else { return nil }
        
        let navController = UINavigationController(rootViewController: vc)
        navigationController = navController
        return navController
    }
}

extension TrackFlowCoordinator: DMTrackModuleOutput {
    
    func showJobDetails(job: Job?, delegate: JobSavedStatusUpdateDelegate) {
        guard let moduleInput = DMJobDetailInitializer.initialize(job: job, fromTrack: true, delegate: delegate, moduleOutput: self) else { return }
        let vc = moduleInput.viewController()
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func showCancelJob(job: Job?, fromApplied: Bool, delegate: CancelledJobDelegate) {
        guard let vc = DMCancelJobInitializer.initialize(job: job, fromApplied: fromApplied, delegate: delegate, moduleOutput: self) else { return }
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension TrackFlowCoordinator: DMJobDetailModuleOutput {
    
    
}

extension TrackFlowCoordinator: DMCancelJobModuleOutput {
    
    
}

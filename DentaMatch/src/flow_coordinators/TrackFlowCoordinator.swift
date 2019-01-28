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
    
    
}

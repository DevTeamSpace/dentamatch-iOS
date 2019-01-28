import Foundation
import UIKit
import Swinject

protocol JobsFlowCoordinatorProtocol: BaseFlowProtocol {
    
}

protocol JobsFlowCoordinatorDelegate: class {
    
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
    
    
}

import Foundation
import UIKit

class BaseFlowCoordinator: NSObject {

    var childCoordinators = [BaseFlowCoordinator]()

    func addChildFlowCoordinator(_ flowCoordinator: BaseFlowProtocol) {
        if let flowCoordinator = flowCoordinator as? BaseFlowCoordinator {
            childCoordinators.append(flowCoordinator)
        }
    }

    func removeChildFlowCoordinator(_ flowCoordinator: BaseFlowProtocol) {
        if let flowCoordinator = flowCoordinator as? BaseFlowCoordinator, let index = childCoordinators.index(of: flowCoordinator) {
            childCoordinators.remove(at: index)
        }
    }
}


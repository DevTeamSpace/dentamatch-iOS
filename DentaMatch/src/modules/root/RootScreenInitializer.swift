import Foundation
import Swinject

class RootScreenInitializer {

    class func initialize(moduleOutput: RootScreenModuleOutput) -> UIViewController? {
        guard let viewInput = appContainer.resolve(RootScreenViewInput.self) else { return nil }

        viewInput.viewOutput = appContainer.resolve(RootScreenPresenterProtocol.self, arguments: viewInput, moduleOutput)
        
        return viewInput.viewController()
    }

    class func register(for container: Container) {
        
        container.register(RootFlowCoordinatorProtocol.self) { r in
            return RootFlowCoordinator()
        }

        container.register(RootScreenPresenterProtocol.self) { r, viewInput, moduleOutput in
            return RootScreenPresenter(viewInput: viewInput, moduleOutput: moduleOutput)
        }

        container.register(RootScreenViewInput.self) { r in
            RootScreenViewController(nibName: "RootScreenView", bundle: nil)
        }
    }
}

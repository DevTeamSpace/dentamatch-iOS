import Foundation
import Swinject

class JobSearchListScreenInitializer {

    class func initialize(moduleOutput: JobSearchListScreenModuleOutput) -> (JobSearchListScreenModuleInput?, UIViewController?) {
        guard let viewInput = appContainer.resolve(JobSearchListScreenViewInput.self) else { return (nil, nil) }

        let presenter = appContainer.resolve(JobSearchListScreenPresenterProtocol.self, arguments: viewInput, moduleOutput)
        viewInput.viewOutput = presenter
        
        return (presenter, viewInput.viewController())
    }

    class func register(for container: Container) {

        container.register(JobSearchListScreenPresenterProtocol.self) { r, viewInput, moduleOutput in
            return JobSearchListScreenPresenter(viewInput: viewInput, moduleOutput: moduleOutput)
        }

        container.register(JobSearchListScreenViewInput.self) { r in
            JobSearchListScreenViewController(nibName: "JobSearchListScreenView", bundle: nil)
        }
    }

}

import Foundation
import Swinject

class JobSearchMapScreenInitializer {

    class func initialize(moduleOutput: JobSearchMapScreenModuleOutput) -> (JobSearchMapScreenModuleInput?, UIViewController?) {
        guard let viewInput = appContainer.resolve(JobSearchMapScreenViewInput.self) else { return (nil, nil) }

        let presenter = appContainer.resolve(JobSearchMapScreenPresenterProtocol.self, arguments: viewInput, moduleOutput)
        viewInput.viewOutput = presenter
        
        return (presenter, viewInput.viewController())
    }

    class func register(for container: Container) {

        container.register(JobSearchMapScreenPresenterProtocol.self) { r, viewInput, moduleOutput in
            return JobSearchMapScreenPresenter(viewInput: viewInput, moduleOutput: moduleOutput)
        }

        container.register(JobSearchMapScreenViewInput.self) { r in
            JobSearchMapScreenViewController(nibName: "JobSearchMapScreenView", bundle: nil)
        }
    }

}

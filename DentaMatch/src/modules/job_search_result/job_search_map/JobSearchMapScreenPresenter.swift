import Foundation

class JobSearchMapScreenPresenter: JobSearchMapScreenPresenterProtocol {

    unowned let viewInput: JobSearchMapScreenViewInput
    unowned let moduleOutput: JobSearchMapScreenModuleOutput

    init(viewInput: JobSearchMapScreenViewInput, moduleOutput: JobSearchMapScreenModuleOutput) {
        self.viewInput = viewInput
        self.moduleOutput = moduleOutput
    }
    
    var jobs = [Job]()
}

extension JobSearchMapScreenPresenter: JobSearchMapScreenModuleInput {
    
    func viewController() -> UIViewController {
        return viewInput.viewController()
    }
    
    func populateWithJobs(jobs: [Job]) {
        self.jobs = jobs
        viewInput.reloadData()
    }
}

extension JobSearchMapScreenPresenter: JobSearchMapScreenViewOutput {

}

extension JobSearchMapScreenPresenter {
    
}


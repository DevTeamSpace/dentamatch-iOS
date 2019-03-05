import Foundation


protocol JobSearchMapScreenModuleInput: BaseModuleInput {
    
    func populateWithJobs(jobs: [Job])
}

protocol JobSearchMapScreenModuleOutput: BaseModuleOutput {
    
}

protocol JobSearchMapScreenViewInput: BaseViewInput {
    var viewOutput: JobSearchMapScreenViewOutput? { get set }
    
    func reloadData()
}

protocol JobSearchMapScreenViewOutput: BaseViewOutput {
    var jobs: [Job] { get }
}

protocol JobSearchMapScreenPresenterProtocol: JobSearchMapScreenModuleInput, JobSearchMapScreenViewOutput {
    
}

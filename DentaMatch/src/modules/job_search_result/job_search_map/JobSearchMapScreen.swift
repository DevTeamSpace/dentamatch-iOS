import Foundation


protocol JobSearchMapScreenModuleInput: BaseModuleInput {
    
    func populateWithJobs(jobs: [Job])
}

protocol JobSearchMapScreenModuleOutput: BaseModuleOutput {
    
}

protocol JobSearchMapScreenViewInput: BaseViewInput {
    var viewOutput: JobSearchMapScreenViewOutput? { get set }
    
    func reloadData()
    func updateDetailView(with job: Job, index: Int)
}

protocol JobSearchMapScreenViewOutput: BaseViewOutput, JobMapDetailViewDelegate {
    var jobs: [Job] { get }
    
    func didLoad()
}

protocol JobSearchMapScreenPresenterProtocol: JobSearchMapScreenModuleInput, JobSearchMapScreenViewOutput {
    
}

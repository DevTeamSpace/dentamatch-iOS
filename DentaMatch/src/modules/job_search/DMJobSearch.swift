import Foundation

protocol DMJobSearchModuleInput: BaseModuleInput {
    
}

protocol DMJobSearchModuleOutput: BaseModuleOutput {
    
    func showJobTitle(selectedTitles: [JobTitle]?, isLocation: Bool, locations: [PreferredLocation]?, delegate: DMJobTitleVCDelegate)
}

protocol DMJobSearchViewInput: BaseViewInput {
    var viewOutput: DMJobSearchViewOutput? { get set }
    
    func configureView(fromJobSelection: Bool, delegate: SearchJobDelegate?)
}

protocol DMJobSearchViewOutput: BaseViewOutput {
    var jobs: [Job] { get }
    var totalJobsFromServer: Int { get }
    
    func didLoad()
    func fetchSearchResults(params: [String: Any])
    func openJobTitle(selectedTitles: [JobTitle]?, isLocation: Bool, locations: [PreferredLocation]?, delegate: DMJobTitleVCDelegate)
    func goToSearchResult(params: [String: Any])
}

protocol DMJobSearchPresenterProtocol: DMJobSearchModuleInput, DMJobSearchViewOutput {
    
}

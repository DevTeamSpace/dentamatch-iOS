import Foundation

protocol DMJobTitleModuleInput: BaseModuleInput {
    
}

protocol DMJobTitleModuleOutput: BaseModuleOutput {
    
}

protocol DMJobTitleViewInput: BaseViewInput {
    var viewOutput: DMJobTitleViewOutput? { get set }
    
    func configureTitle(_ title: String, headingText: String)
    func reloadData()
}

protocol DMJobTitleViewOutput: BaseViewOutput {
    var jobTitles: [JobTitle] { get set }
    var selectedJobs: [JobTitle] { get set }
    var preferredLocations: [PreferredLocation] { get set }
    var selectedPreferredLocations: [PreferredLocation] { get set }
    var forPreferredLocations: Bool { get set }
    
    func didLoad()
    func onRightNavigationItemTap()
}

protocol DMJobTitlePresenterProtocol: DMJobTitleModuleInput, DMJobTitleViewOutput {
    
}

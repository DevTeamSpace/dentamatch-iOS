import Foundation

protocol DMWorkExperienceModuleInput: BaseModuleInput {
    
}

protocol DMWorkExperienceModuleOutput: BaseModuleOutput {

    func showStates(preselectedState: String?, delegate: SearchStateViewControllerDelegate?)
}

protocol DMWorkExperienceViewInput: BaseViewInput {
    var viewOutput: DMWorkExperienceViewOutput? { get set }
    
    func reloadData()
}

protocol DMWorkExperienceViewOutput: BaseViewOutput {
    var isEditing: Bool { get }
    var jobTitles: [JobTitle] { get }
    var exprienceArray: [ExperienceModel] { get set }
    var exprienceDetailArray: NSMutableArray { get }
    var currentExperience: ExperienceModel { get set }
    var selectedIndex: Int { get set }
    var isHiddenExperienceTable: Bool { get set }
    
    func getExperience()
    func saveUpdateExperience()
    func saveUpdateExperience(isAddExperience: Bool)
    func openStates(preselectedState: String?, delegate: SearchStateViewControllerDelegate?)
    func deleteExperience()
}

protocol DMWorkExperiencePresenterProtocol: DMWorkExperienceModuleInput, DMWorkExperienceViewOutput {
    
}

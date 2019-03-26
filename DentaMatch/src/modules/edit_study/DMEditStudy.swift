import Foundation

protocol DMEditStudyModuleInput: BaseModuleInput {
    
}

protocol DMEditStudyModuleOutput: BaseModuleOutput {
    
}

protocol DMEditStudyViewInput: BaseViewInput {
    var viewOutput: DMEditStudyViewOutput? { get set }
    
    func reloadData()
}

protocol DMEditStudyViewOutput: BaseViewOutput {
    var selectedSchoolCategories: [SelectedSchool] { get }
    var isFilledFromAutoComplete: Bool { get set }
    var schoolCategories: [SchoolCategory] { get }
    var selectedData: NSMutableArray { get }
    
    func getSchoolList()
    func addSchool()
    func checkForEmptySchoolField()
    func didSelect(schoolCategoryId: String, university: University)
    func removeEmptyYear()
    func onDoneButtonTap(year: Int, tag: Int)
}

protocol DMEditStudyPresenterProtocol: DMEditStudyModuleInput, DMEditStudyViewOutput {
    
}

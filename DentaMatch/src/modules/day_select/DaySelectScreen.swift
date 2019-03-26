import Foundation


protocol DaySelectScreenModuleInput: BaseModuleInput {
    
}

protocol DaySelectScreenModuleOutput: BaseModuleOutput {
    
}

protocol DaySelectScreenViewInput: BaseViewInput {
    var viewOutput: DaySelectScreenViewOutput? { get set }
    
    func reloadData()
}

protocol DaySelectScreenViewOutput: BaseViewOutput {
    var cellDescriptions: [TableViewCellDescription] { get }
    
    func didLoad()
    func onAcceptButtonTapped()
    func onDateTapped(index: Int)
}

protocol DaySelectScreenPresenterProtocol: DaySelectScreenModuleInput, DaySelectScreenViewOutput {
    
}

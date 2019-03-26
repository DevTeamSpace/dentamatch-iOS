import Foundation

class DaySelectScreenPresenter: DaySelectScreenPresenterProtocol {

    unowned let viewInput: DaySelectScreenViewInput
    unowned let moduleOutput: DaySelectScreenModuleOutput

    let dates: [Date]
    
    init(dates: [Date], viewInput: DaySelectScreenViewInput, moduleOutput: DaySelectScreenModuleOutput) {
        self.dates = dates
        self.viewInput = viewInput
        self.moduleOutput = moduleOutput
    }
    
    var cellDescriptions = [TableViewCellDescription]()
    var selectedDates = [Int: Bool]()
}

extension DaySelectScreenPresenter: DaySelectScreenModuleInput {
    
    func viewController() -> UIViewController {
        return viewInput.viewController()
    }
}

extension DaySelectScreenPresenter: DaySelectScreenViewOutput {

    func didLoad() {
        
        dates.enumerated().forEach({ index, _ in
            selectedDates[index] = true
        })
        
        updateUI()
    }
    
    func onAcceptButtonTapped() {
        viewInput.popViewController()
    }
    
    func onDateTapped(index: Int) {
        guard let currentValue = selectedDates[index] else { return }
        selectedDates[index] = !currentValue
        updateUI()
    }
}

extension DaySelectScreenPresenter {
    
    private func updateUI() {
        
        cellDescriptions.removeAll()
        cellDescriptions.append(contentsOf: dates.enumerated().map({
            TableViewCellDescription(cellType: DaySelectViewCell.self,
                                     height: 39,
                                     object: DaySelectViewCellObject(isSelected: selectedDates[$0.offset] ?? true,
                                                                     date: $0.element,
                                                                     delegate: self)) }))
        
        viewInput.reloadData()
    }
}

extension DaySelectScreenPresenter: DaySelectViewCellDelegate {
    
    
}


import Foundation
import SwiftyJSON

class DaySelectScreenPresenter: DaySelectScreenPresenterProtocol {

    unowned let viewInput: DaySelectScreenViewInput
    unowned let moduleOutput: DaySelectScreenModuleOutput

    let dates: [Date]
    let notificationId: Int
    init(dates: [Date], notificationId: Int, viewInput: DaySelectScreenViewInput, moduleOutput: DaySelectScreenModuleOutput) {
        self.dates = dates
        self.notificationId = notificationId
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
        
        let jobDates = cellDescriptions
            .compactMap({ ($0.object as? DaySelectViewCellObject)?.isSelected == true ? ($0.object as? DaySelectViewCellObject)?.date : nil })
            .map({ DMNotificationsPresenter.dateFormatter.string(from: $0) })
        
        if jobDates.isEmpty {
            viewInput.showAlertMessage(title: "Attention", body: "Please select at least one date")
            return
        }
        
        viewInput.showLoading()
        APIManager.apiPost(serviceName: Constants.API.acceptRejectNotification, parameters: ["notificationId": notificationId, "acceptStatus": 1, "jobDates": jobDates]) { [weak self] (response: JSON?, error: NSError?) in
            
            self?.viewInput.hideLoading()
            if let error = error {
                self?.viewInput.show(toastMessage: error.localizedDescription)
                return
            }
            
            guard let response = response else {
                self?.viewInput.show(toastMessage: Constants.AlertMessage.somethingWentWrong)
                return
            }
            
            if response[Constants.ServerKey.status].boolValue {
                self?.viewInput.showAlertMessage(title: Constants.AlertMessage.congratulations, body: Constants.AlertMessage.jobAccepted, completion: { [weak self] in
                    self?.viewInput.popViewController()
                })
                self?.moduleOutput.updateAfterAcception()
                NotificationCenter.default.post(name: .decreaseBadgeCount, object: nil, userInfo: nil)
            } else {
                
                if response[Constants.ServerKey.statusCode].intValue == 201 {
                    
                    self?.viewInput.showAlertMessage(title: "Change Availability", body: response[Constants.ServerKey.message].stringValue)
                } else {
                    
                    self?.viewInput.show(toastMessage: response[Constants.ServerKey.message].stringValue)
                }
            }
        }
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
        cellDescriptions.append(contentsOf: dates.sorted().enumerated().map({
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


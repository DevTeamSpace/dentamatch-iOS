import Foundation
import SwiftyJSON

class DMCalendarSetAvailabilityPresenter: DMCalendarSetAvailabilityPresenterProtocol {
    
    unowned let viewInput: DMCalendarSetAvailabilityViewInput
    unowned let moduleOutput: DMCalendarSetAvailabilityModuleOutput
    
    let fromJobSelection: Bool
    
    init(fromJobSelection: Bool, viewInput: DMCalendarSetAvailabilityViewInput, moduleOutput: DMCalendarSetAvailabilityModuleOutput) {
        self.fromJobSelection = fromJobSelection
        self.viewInput = viewInput
        self.moduleOutput = moduleOutput
    }
}

extension DMCalendarSetAvailabilityPresenter: DMCalendarSetAvailabilityModuleInput {
    
    func viewController() -> UIViewController {
        return viewInput.viewController()
    }
}

extension DMCalendarSetAvailabilityPresenter: DMCalendarSetAvailabilityViewOutput {
    
    func didLoad() {
        
        viewInput.configureView(fromJobSelection: fromJobSelection)
        getMyAvailabilityFromServer()
    }
    
    func setAvailability(params: [String: Any]) {
        
        viewInput.showLoading()
        APIManager.apiPostWithJSONEncode(serviceName: Constants.API.setAvailabality, parameters: params) { [weak self] (response: JSON?, error: NSError?) in
            
            self?.viewInput.hideLoading()
            
            if let error = error {
                self?.viewInput.show(toastMessage: error.localizedDescription)
            }
            
            guard let response = response else {
                self?.viewInput.show(toastMessage: Constants.AlertMessage.somethingWentWrong)
                return
            }
            
            self?.viewInput.show(toastMessage: response[Constants.ServerKey.message].stringValue)
            
            if self?.fromJobSelection == true {
                self?.moduleOutput.showTabBar()
            } else {
                self?.viewInput.popViewController()
            }
        }
        
    }
}

extension DMCalendarSetAvailabilityPresenter {
    
    private func getMyAvailabilityFromServer() {
        
        var param = [String: Any]()
        
        let firstDate = Date.getMonthBasedOnThis(date1: Date(), duration: -6)
        let lastDate = Date.getMonthBasedOnThis(date1: Date(), duration: 6)
        
        let date5 = NSCalendar(calendarIdentifier: .gregorian)?.fs_firstDay(ofMonth: firstDate)
        let date2 = NSCalendar(calendarIdentifier: .gregorian)?.fs_lastDay(ofMonth: lastDate)
        
        let strStartDate = Date.dateToString(date: date5!)
        let strEndDate = Date.dateToString(date: date2!)
        
        param["calendarStartDate"] = strStartDate
        param["calendarEndDate"] = strEndDate
        
        viewInput.showLoading()
        APIManager.apiPost(serviceName: Constants.API.getAvailabality, parameters: param) { [weak self] (response: JSON?, error: NSError?) in
            
            self?.viewInput.hideLoading()
            
            if let error = error  {
                self?.viewInput.show(toastMessage: error.localizedDescription)
            }
            
            guard let response = response else {
                self?.viewInput.show(toastMessage: Constants.AlertMessage.somethingWentWrong)
                return
            }
            
            self?.viewInput.configureWithAvailability(response: response)
        }
    }
}

import Foundation
import SwiftyJSON

class DMLoginPresenter: DMLoginPresenterProtocol {
    
    unowned let viewInput: DMLoginViewInput
    unowned let moduleOutput: DMLoginModuleOutput
    
    init(viewInput: DMLoginViewInput, moduleOutput: DMLoginModuleOutput) {
        self.viewInput = viewInput
        self.moduleOutput = moduleOutput
    }
}

extension DMLoginPresenter: DMLoginModuleInput {
    
    func viewController() -> UIViewController {
        return viewInput.viewController()
    }
}

extension DMLoginPresenter: DMLoginViewOutput {
    
    func openForgotPassword() {
        moduleOutput.showForgotPassword()
    }
    
    func onLoginButtonTap(params: [String : String]) {
        
        viewInput.showLoading()
        APIManager.apiPost(serviceName: Constants.API.login, parameters: params) { [weak self] (response: JSON?, error: NSError?) in
            
            self?.viewInput.hideLoading()
            
            if let error = error {
                self?.viewInput.show(toastMessage: error.localizedDescription)
                return
            }
            
            guard let response = response else {
                self?.viewInput.show(toastMessage: Constants.AlertMessage.somethingWentWrong)
                return
            }
            
            UserManager.shared().loginResponseHandler(response: response)
            self?.viewInput.show(toastMessage: response[Constants.ServerKey.message].stringValue)
            
            if response[Constants.ServerKey.status].boolValue {
                
                MixpanelOperations.manageMixpanelUserIdentity()
                MixpanelOperations.registerMixpanelUser()
                MixpanelOperations.trackMixpanelEvent(eventName: "Login")
                
                self?.saveSearchedData(response: response)
                
                SocketIOManager.sharedInstance.establishConnection()
                if (UserManager.shared().activeUser.jobTitleId?.isEmptyField)! {
                    self?.moduleOutput.showJobTitleSelection()
                } else {
                    self?.moduleOutput.showTabBar()
                }
            }
        }
    }
}

extension DMLoginPresenter {
    
    private func saveSearchedData(response: JSON?) {
        var searchParams = [String: Any]()
        if let searchFilters = response?[Constants.ServerKey.result][Constants.ServerKey.searchFilters] {
            if searchFilters.count == 0 {
                return
            }
            
            searchParams[Constants.JobDetailKey.lat] = searchFilters[Constants.JobDetailKey.lat].stringValue
            searchParams[Constants.JobDetailKey.lng] = searchFilters[Constants.JobDetailKey.lng].stringValue
            searchParams[Constants.JobDetailKey.zipCode] = searchFilters[Constants.JobDetailKey.zipCode].stringValue
            searchParams[Constants.JobDetailKey.city] = searchFilters[Constants.JobDetailKey.city].stringValue
            searchParams[Constants.JobDetailKey.country] = searchFilters[Constants.JobDetailKey.country].stringValue
            searchParams[Constants.JobDetailKey.state] = searchFilters[Constants.JobDetailKey.state].stringValue
            
            searchParams[Constants.JobDetailKey.isFulltime] = searchFilters[Constants.JobDetailKey.isFulltime].stringValue
            searchParams[Constants.JobDetailKey.isParttime] = searchFilters[Constants.JobDetailKey.isParttime].stringValue
            
            if let partTimeDays = searchFilters[Constants.JobDetailKey.parttimeDays].arrayObject as? [String] {
                searchParams[Constants.JobDetailKey.parttimeDays] = partTimeDays
            }
            
            if let jobTitles = searchFilters[Constants.JobDetailKey.jobTitle].arrayObject as? [String] {
                searchParams[Constants.JobDetailKey.jobTitle] = jobTitles
            }
            
            if let customJobTitlesArray = searchFilters[Constants.JobDetailKey.jobTitles].arrayObject as? [[String: Any]] {
                searchParams[Constants.JobDetailKey.jobTitles] = customJobTitlesArray
            }
            
            searchParams[Constants.JobDetailKey.address] = searchFilters[Constants.JobDetailKey.address].stringValue
            
            UserDefaultsManager.sharedInstance.deleteSearchParameter()
            UserDefaultsManager.sharedInstance.saveSearchParameter(seachParam: searchParams as Any)
        }
    }
}

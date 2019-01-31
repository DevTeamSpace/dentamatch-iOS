import Foundation
import SwiftyJSON

class DMRegistrationPresenter: DMRegistrationPresenterProtocol {
    
    unowned let viewInput: DMRegistrationViewInput
    unowned let moduleOutput: DMRegistrationModuleOutput
    
    init(viewInput: DMRegistrationViewInput, moduleOutput: DMRegistrationModuleOutput) {
        self.viewInput = viewInput
        self.moduleOutput = moduleOutput
    }
    
    var preferredLocations = [PreferredLocation]()
    var selectedPreferredLocation: PreferredLocation?
}

extension DMRegistrationPresenter: DMRegistrationModuleInput {
    
    func viewController() -> UIViewController {
        return viewInput.viewController()
    }
}

extension DMRegistrationPresenter: DMRegistrationViewOutput {
    
    func didLoad() {
        
        getPreferredLocations()
    }
    
    func openTermsAndConditions(isPrivacyPolicy: Bool) {
        moduleOutput.showTermsAndConditions(isPrivacyPolicy: isPrivacyPolicy)
    }
    
    func openJobTitleSelection() {
        
        SocketIOManager.sharedInstance.establishConnection()
        moduleOutput.showJobTitleSelection()
    }
    
    func onRegisterButtonTap(params: [String: String]) {
        
        LogManager.logDebug("Registration Parameters: \n\(params.description)")
        viewInput.showLoading()
        
        APIManager.apiPost(serviceName: Constants.API.registration, parameters: params) { [weak self] (response: JSON?, error: NSError?) in
            
            self?.viewInput.hideLoading()
            
            if let error = error {
                self?.viewInput.show(toastMessage: error.localizedDescription)
            }
            
            guard let response = response else {
                self?.viewInput.show(toastMessage: Constants.AlertMessage.somethingWentWrong)
                return
            }
            
            if !response[Constants.ServerKey.status].boolValue {
                
                self?.viewInput.show(toastMessage: response[Constants.ServerKey.message].stringValue)
            } else {
                
                UserManager.shared().loginResponseHandler(response: response)
                
                MixpanelOperations.trackMixpanelEventWithProperties(eventName: "SignUp", dict: params)
                MixpanelOperations.manageMixpanelUserIdentity()
                MixpanelOperations.registerMixpanelUser()
                MixpanelOperations.trackMixpanelEvent(eventName: "Login")
                
                self?.viewInput.showAlertMessage(title: "Success", body: response[Constants.ServerKey.message].stringValue, completion: { [weak self] in
                    self?.moduleOutput.showJobTitleSelection()
                })
            }
        }
    }
}

extension DMRegistrationPresenter {
    
    private func getPreferredLocations() {
        
        APIManager.apiGet(serviceName: Constants.API.getPreferredJobLocations, parameters: nil) { [weak self] (response: JSON?, error: NSError?) in
            
            if let error = error  {
                self?.viewInput.show(toastMessage: error.localizedDescription)
            }
            
            guard let response = response else {
                self?.viewInput.show(toastMessage: Constants.AlertMessage.somethingWentWrong)
                return
            }
            
            if response[Constants.ServerKey.status].boolValue {
                
                let preferredJobLocationArray = response["result"]["preferredJobLocations"].arrayValue
                
                for location in preferredJobLocationArray {
                    self?.preferredLocations.append(PreferredLocation(preferredLocation: location))
                }
                
                self?.viewInput.configurePickerView()
            } else {
                self?.viewInput.show(toastMessage: response[Constants.ServerKey.message].stringValue)
            }
        }
    }
}

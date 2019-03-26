import Foundation
import SwiftyJSON

class DMSettingsPresenter: DMSettingsPresenterProtocol {
    
    unowned let viewInput: DMSettingsViewInput
    unowned let moduleOutput: DMSettingsModuleOutput
    
    init(viewInput: DMSettingsViewInput, moduleOutput: DMSettingsModuleOutput) {
        self.viewInput = viewInput
        self.moduleOutput = moduleOutput
    }
}

extension DMSettingsPresenter: DMSettingsModuleInput {
    
    func viewController() -> UIViewController {
        return viewInput.viewController()
    }
}

extension DMSettingsPresenter: DMSettingsViewOutput {
    
    func openLoginScreen() {
        moduleOutput.showLoginScreen()
    }
    
    func openResetPassword() {
        moduleOutput.showResetPassword()
    }
    
    func openTermsAndConditions(isPrivacyPolicy: Bool) {
        moduleOutput.showTermsAndConditions(isPrivacyPolicy: isPrivacyPolicy)
    }
    
    func openRegisterMaps(delegate: LocationAddressDelegate?) {
        moduleOutput.showRegisterMaps(delegate: delegate)
    }
    
    func signOut() {
        
        viewInput.showLoading()
        APIManager.apiDelete(serviceName: Constants.API.signOut, parameters: [:]) { [weak self] (response: JSON?, error: NSError?) in
            
            self?.viewInput.hideLoading()
            
            if let error = error {
                self?.viewInput.show(toastMessage: error.localizedDescription)
                return
            }
            
            guard let response = response else {
                self?.viewInput.show(toastMessage: Constants.AlertMessage.somethingWentWrong)
                return
            }
            
            self?.viewInput.show(toastMessage: response[Constants.ServerKey.message].stringValue)
            
            if response[Constants.ServerKey.status].boolValue {
                
                AppDelegate.delegate().resetBadgeCount()
                MixpanelOperations.mixpanepanelLogout()
                SocketIOManager.sharedInstance.closeConnection()
                UserManager.shared().deleteActiveUser()
                UserDefaultsManager.sharedInstance.clearCache()
                UserDefaultsManager.sharedInstance.isLoggedOut = true
                
                self?.moduleOutput.showLoginScreen()
            }
        }
    }
}

extension DMSettingsPresenter {
    
}

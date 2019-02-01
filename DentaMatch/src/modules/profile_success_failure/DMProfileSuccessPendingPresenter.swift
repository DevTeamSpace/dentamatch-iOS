import Foundation
import SwiftyJSON

class DMProfileSuccessPendingPresenter: DMProfileSuccessPendingPresenterProtocol {
    
    unowned let viewInput: DMProfileSuccessPendingViewInput
    unowned let moduleOutput: DMProfileSuccessPendingModuleOutput
    
    let isEmailVerified: Bool
    let isLicenseRequired: Bool
    let fromRoot: Bool
    
    init(isEmailVerified: Bool, isLicenseRequired: Bool, fromRoot: Bool, viewInput: DMProfileSuccessPendingViewInput, moduleOutput: DMProfileSuccessPendingModuleOutput) {
        self.isEmailVerified = isEmailVerified
        self.isLicenseRequired = isLicenseRequired
        self.fromRoot = fromRoot
        self.viewInput = viewInput
        self.moduleOutput = moduleOutput
    }
}

extension DMProfileSuccessPendingPresenter: DMProfileSuccessPendingModuleInput {
    
    func viewController() -> UIViewController {
        return viewInput.viewController()
    }
}

extension DMProfileSuccessPendingPresenter: DMProfileSuccessPendingViewOutput {
    
    func didLoad() {
        
        viewInput.configure(isEmailVerified: isEmailVerified, isLicenseRequired: isLicenseRequired, fromRoot: fromRoot)
    }
    
    func verifyEmail(silent: Bool) {
        
        viewInput.showLoading()
        APIManager.apiGet(serviceName: Constants.API.emailVerify, parameters: nil) { [weak self] (response: JSON?, error: NSError?) in
            
            self?.viewInput.hideLoading()
            
            if let error = error {
                self?.viewInput.show(toastMessage: error.localizedDescription)
            }
            
            guard let response = response else {
                self?.viewInput.show(toastMessage: Constants.AlertMessage.somethingWentWrong)
                return
            }
            
            if response[Constants.ServerKey.status].boolValue {
                self?.viewInput.configureViewOnVerify(isVerified: response[Constants.ServerKey.result]["isVerified"].boolValue,
                                                      message: response[Constants.ServerKey.message].stringValue,
                                                      silent: silent)
            }
        }
    }
    
    func openCalendar() {
        moduleOutput.showCalendar(fromJobSelection: true)
    }
}

extension DMProfileSuccessPendingPresenter {
    
}

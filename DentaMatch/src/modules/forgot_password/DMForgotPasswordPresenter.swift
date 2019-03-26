import Foundation
import SwiftyJSON

class DMForgotPasswordPresenter: DMForgotPasswordPresenterProtocol {
    
    unowned let viewInput: DMForgotPasswordViewInput
    unowned let moduleOutput: DMForgotPasswordModuleOutput
    
    init(viewInput: DMForgotPasswordViewInput, moduleOutput: DMForgotPasswordModuleOutput) {
        self.viewInput = viewInput
        self.moduleOutput = moduleOutput
    }
}

extension DMForgotPasswordPresenter: DMForgotPasswordModuleInput {
    
    func viewController() -> UIViewController {
        return viewInput.viewController()
    }
}

extension DMForgotPasswordPresenter: DMForgotPasswordViewOutput {
    
    func onSendButtonTap(params: [String : String]) {
        
        viewInput.showLoading()
        APIManager.apiPut(serviceName: Constants.API.forgotPassword, parameters: params) { [weak self] (response: JSON?, error: NSError?) in
            
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
                self?.viewInput.popViewController()
                self?.viewInput.show(toastMessage: response[Constants.ServerKey.message].stringValue)
            } else {
                self?.viewInput.show(toastMessage: response[Constants.ServerKey.message].stringValue)
            }
        }
    }
}

extension DMForgotPasswordPresenter {
    
}

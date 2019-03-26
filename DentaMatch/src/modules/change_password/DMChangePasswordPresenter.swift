import Foundation
import SwiftyJSON

class DMChangePasswordPresenter: DMChangePasswordPresenterProtocol {
    
    unowned let viewInput: DMChangePasswordViewInput
    unowned let moduleOutput: DMChangePasswordModuleOutput
    
    init(viewInput: DMChangePasswordViewInput, moduleOutput: DMChangePasswordModuleOutput) {
        self.viewInput = viewInput
        self.moduleOutput = moduleOutput
    }
}

extension DMChangePasswordPresenter: DMChangePasswordModuleInput {
    
    func viewController() -> UIViewController {
        return viewInput.viewController()
    }
}

extension DMChangePasswordPresenter: DMChangePasswordViewOutput {
    
    
    func changePassword(passwords: [String]) {
        
        let dict = [Constants.ServerKey.oldPass: passwords[0],
                    Constants.ServerKey.newPass: passwords[1],
                    Constants.ServerKey.confirmPass: passwords[2]]
        
        viewInput.showLoading()
        APIManager.apiPost(serviceName: Constants.API.changePassword, parameters: dict) { [weak self] (response: JSON?, error: NSError?) in
            
            
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
            } else {
                self?.viewInput.show(toastMessage: response[Constants.ServerKey.message].stringValue)
            }
        }
    }
}

extension DMChangePasswordPresenter {
    
}

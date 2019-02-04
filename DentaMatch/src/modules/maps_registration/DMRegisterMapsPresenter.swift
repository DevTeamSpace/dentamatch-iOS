import Foundation
import SwiftyJSON

class DMRegisterMapsPresenter: DMRegisterMapsPresenterProtocol {
    
    unowned let viewInput: DMRegisterMapsViewInput
    unowned let moduleOutput: DMRegisterMapsModuleOutput
    
    let fromSettings: Bool
    weak var delegate: LocationAddressDelegate?
    
    init(fromSettings: Bool, delegate: LocationAddressDelegate?, viewInput: DMRegisterMapsViewInput, moduleOutput: DMRegisterMapsModuleOutput) {
        
        self.fromSettings = fromSettings
        self.delegate = delegate
        self.viewInput = viewInput
        self.moduleOutput = moduleOutput
    }
}

extension DMRegisterMapsPresenter: DMRegisterMapsModuleInput {
    
    func viewController() -> UIViewController {
        return viewInput.viewController()
    }
}

extension DMRegisterMapsPresenter: DMRegisterMapsViewOutput {
    
    func didLoad() {
        
        viewInput.configureViewInput(fromSettings: fromSettings, delegate: delegate)
    }
    
    func locationUpdateApi(location: Location) {
        
        let params = [
            Constants.ServerKey.preferredLocation: location.address!,
            Constants.ServerKey.latitude: "\(location.coordinateSelected!.latitude)",
            Constants.ServerKey.longitude: "\(location.coordinateSelected!.longitude)",
            Constants.ServerKey.zipCode: "\(location.postalCode)",
            "preferredCity": "\(location.city)",
            "preferredState": "\(location.state)",
            "preferredCountry": "\(location.country)",
        ]
        
        viewInput.showLoading()
        APIManager.apiPost(serviceName: Constants.API.updateHomeLocation, parameters: params) { [weak self] (response: JSON?, error: NSError?) in
            
            self?.viewInput.hideLoading()
            
            if let error = error  {
                self?.viewInput.show(toastMessage: error.localizedDescription)
                return
            }
            
            guard let response = response else {
                self?.viewInput.show(toastMessage: Constants.AlertMessage.somethingWentWrong)
                return
            }
            
            if response[Constants.ServerKey.status].boolValue {
                
                self?.viewInput.selectedLocation(location)
                self?.viewInput.show(toastMessage: response[Constants.ServerKey.message].stringValue)
                self?.viewInput.popViewController()
            } else {
                self?.viewInput.show(toastMessage: response[Constants.ServerKey.message].stringValue)
            }
        }
    }
}

extension DMRegisterMapsPresenter {
    
}

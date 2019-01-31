import Foundation

protocol DMRegisterMapsModuleInput: BaseModuleInput {
    
}

protocol DMRegisterMapsModuleOutput: BaseModuleOutput {
    
}

protocol DMRegisterMapsViewInput: BaseViewInput {
    var viewOutput: DMRegisterMapsViewOutput? { get set }
    
    func configureViewInput(fromSettings: Bool, delegate: LocationAddressDelegate?)
    func selectedLocation(_ location: Location)
}

protocol DMRegisterMapsViewOutput: BaseViewOutput {
    
    func didLoad()
    func locationUpdateApi(location: Location)
}

protocol DMRegisterMapsPresenterProtocol: DMRegisterMapsModuleInput, DMRegisterMapsViewOutput {
    
}

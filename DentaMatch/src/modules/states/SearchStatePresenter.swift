import Foundation
import SwiftyJSON

class SearchStatePresenter: SearchStatePresenterProtocol {
    
    unowned let viewInput: SearchStateViewInput
    unowned let moduleOutput: SearchStateModuleOutput
    
    var preselectedState: String?
    weak var delegate: SearchStateViewControllerDelegate?
    
    init(preselectedState: String?, delegate: SearchStateViewControllerDelegate?, viewInput: SearchStateViewInput, moduleOutput: SearchStateModuleOutput) {
        self.preselectedState = preselectedState
        self.delegate = delegate
        self.viewInput = viewInput
        self.moduleOutput = moduleOutput
    }
    
    var states = [State]()
}

extension SearchStatePresenter: SearchStateModuleInput {
    
    func viewController() -> UIViewController {
        return viewInput.viewController()
    }
}

extension SearchStatePresenter: SearchStateViewOutput {
    
    func didLoad() {
        
        viewInput.configureView(preselectedState: preselectedState, delegate: delegate)
        getStates()
    }
}

extension SearchStatePresenter {
    
    private func getStates() {
        
        viewInput.showLoading()
        APIManager.apiGet(serviceName: Constants.API.listStatesApi, parameters: [:]) { [weak self] (response: JSON?, error: NSError?) in
            
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
                
                let stateDicts = response[Constants.ServerKey.result][Constants.ServerKey.statelist].array
                var states = [State]()
                
                for object in stateDicts ?? [] {
                    states.append(State(object))
                }
                
                self?.states = states
                self?.viewInput.updateStates(states)
            } else {
                
                self?.viewInput.updateStates([])
            }
        }
    }
}

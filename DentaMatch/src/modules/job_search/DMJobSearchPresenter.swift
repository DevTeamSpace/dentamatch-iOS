import Foundation
import SwiftyJSON

class DMJobSearchPresenter: DMJobSearchPresenterProtocol {
    
    unowned let viewInput: DMJobSearchViewInput
    unowned let moduleOutput: DMJobSearchModuleOutput
    
    let fromJobResult: Bool
    weak var delegate: SearchJobDelegate?
    
    init(fromJobResult: Bool, delegate: SearchJobDelegate, viewInput: DMJobSearchViewInput, moduleOutput: DMJobSearchModuleOutput) {
        self.fromJobResult = fromJobResult
        self.delegate = delegate
        self.viewInput = viewInput
        self.moduleOutput = moduleOutput
    }
    
    var jobs = [Job]()
    var totalJobsFromServer = 0
}

extension DMJobSearchPresenter: DMJobSearchModuleInput {
    
    func viewController() -> UIViewController {
        return viewInput.viewController()
    }
}

extension DMJobSearchPresenter: DMJobSearchViewOutput {
    
    func didLoad() {
        
        viewInput.configureView(fromJobSelection: fromJobResult, delegate: delegate)
    }
    
    func fetchSearchResults(params: [String : Any]) {
        
        viewInput.showLoading()
        APIManager.apiPost(serviceName: Constants.API.JobSearchResultAPI, parameters: params) { [weak self] (response: JSON?, error: NSError?) in
            
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
                
                let skillList = response[Constants.ServerKey.result][Constants.ServerKey.joblist].array
                
                self?.jobs.removeAll()
                for jobObject in skillList! {
                    let job = Job(job: jobObject)
                    self?.jobs.append(job)
                }
                
                self?.goToSearchResult(params: params)
                self?.totalJobsFromServer = response[Constants.ServerKey.result]["total"].intValue
            } else {
                
                self?.viewInput.show(toastMessage: response[Constants.ServerKey.message].stringValue)
            }
        }
    }
    
    func goToSearchResult(params: [String : Any]) {
        
        UserDefaultsManager.sharedInstance.deleteSearchParameter()
        UserDefaultsManager.sharedInstance.saveSearchParameter(seachParam: params as Any)
        
        if fromJobResult == true {
            if let delegate = delegate {
                delegate.refreshJobList()
            }
            viewInput.popViewController()
        } else {
            assertionFailure("Implement")
        }
    }
    
    func openJobTitle(selectedTitles: [JobTitle]?, isLocation: Bool, locations: [PreferredLocation]?, delegate: DMJobTitleVCDelegate) {
        moduleOutput.showJobTitle(selectedTitles: selectedTitles, isLocation: isLocation, locations: locations, delegate: delegate)
    }
}

extension DMJobSearchPresenter {
    
}

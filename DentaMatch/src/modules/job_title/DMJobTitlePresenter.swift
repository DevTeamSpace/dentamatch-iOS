import Foundation
import SwiftyJSON

class DMJobTitlePresenter: DMJobTitlePresenterProtocol {
    
    unowned let viewInput: DMJobTitleViewInput
    unowned let moduleOutput: DMJobTitleModuleOutput
    
    weak var delegate: DMJobTitleVCDelegate?
    
    init(selectedTitles: [JobTitle]?, forLocation: Bool, locations: [PreferredLocation]?, delegate: DMJobTitleVCDelegate, viewInput: DMJobTitleViewInput, moduleOutput: DMJobTitleModuleOutput) {
        self.selectedJobs = selectedTitles ?? []
        self.forPreferredLocations = forLocation
        self.selectedPreferredLocations = locations ?? []
        self.delegate = delegate
        self.viewInput = viewInput
        self.moduleOutput = moduleOutput
    }
    
    var jobTitles = [JobTitle]()
    var selectedJobs = [JobTitle]()
    var preferredLocations = [PreferredLocation]()
    var selectedPreferredLocations = [PreferredLocation]()
    var forPreferredLocations = false
}

extension DMJobTitlePresenter: DMJobTitleModuleInput {
    
    func viewController() -> UIViewController {
        return viewInput.viewController()
    }
}

extension DMJobTitlePresenter: DMJobTitleViewOutput {

    func didLoad() {
        
        viewInput.configureTitle(forPreferredLocations ? "PREFERRED LOCATIONS" : Constants.ScreenTitleNames.jobTitle,
                                 headingText: forPreferredLocations ? "You can select more than one location" : "You can select more than one job title")
        forPreferredLocations ? getPreferredJobs() : getJobsAPI()
    }
    
    func onRightNavigationItemTap() {
        
        if forPreferredLocations {
            
            selectedPreferredLocations.removeAll()
            selectedPreferredLocations = preferredLocations.filter({ $0.isSelected })
            
            if selectedPreferredLocations.count == 0 {
                viewInput.show(toastMessage: Constants.AlertMessage.selectPreferredLocation)
                return
            }
            
            delegate?.setSelectedPreferredLocations(preferredLocations: selectedPreferredLocations)
        } else {
            
            selectedJobs.removeAll()
            for objTitle in jobTitles {
                if objTitle.jobSelected == true {
                    selectedJobs.append(objTitle)
                }
            }
            if selectedJobs.count == 0 {
                viewInput.show(toastMessage: Constants.AlertMessage.selectTitle)
            } else {
                delegate?.setSelectedJobType(jobTitles: selectedJobs)
            }
        }
        
        viewInput.popViewController()
    }
}

extension DMJobTitlePresenter {
    
    private func getPreferredJobs() {
        
        viewInput.showLoading()
        APIManager.apiGet(serviceName: Constants.API.getPreferredJobLocations, parameters: nil) { [weak self] (response: JSON?, error: NSError?) in
            
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
                
                let preferredJobLocationArray = response["result"]["preferredJobLocations"].arrayValue
                self?.preferredLocations.removeAll()
                
                for location in preferredJobLocationArray {
                    let preferredLocation = PreferredLocation(preferredLocation: location)
                    
                    for selectedLocation in self?.selectedPreferredLocations ?? [] {
                        if preferredLocation.id == selectedLocation.id {
                            preferredLocation.isSelected = true
                        }
                    }
                    
                    self?.preferredLocations.append(preferredLocation)
                }
                
                self?.viewInput.reloadData()
                
            } else {
                self?.viewInput.show(toastMessage: response[Constants.ServerKey.message].stringValue)
            }
        }
    }
    
    private func getJobsAPI() {
        
        viewInput.showLoading()
        APIManager.apiGet(serviceName: Constants.API.getJobTitleAPI, parameters: [:]) { [weak self] (response: JSON?, error: NSError?) in
            
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
                
                let joblist = response[Constants.ServerKey.result][Constants.ServerKey.joblists].array
                self?.jobTitles.removeAll()
                
                for jobObject in joblist ?? [] {
                    let job = JobTitle(job: jobObject)
                    
                    for selectedJob in self?.selectedJobs ?? [] {
                        if selectedJob.jobId == job.jobId {
                            job.jobSelected = true
                        }
                    }
                    
                    self?.jobTitles.append(job)
                }
                
                self?.viewInput.reloadData()
            } else {
                self?.viewInput.show(toastMessage: response[Constants.ServerKey.message].stringValue)
            }
        }
    }
}

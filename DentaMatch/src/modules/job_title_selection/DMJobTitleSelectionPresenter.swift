import Foundation
import SwiftyJSON

class DMJobTitleSelectionPresenter: DMJobTitleSelectionPresenterProtocol {
    
    unowned let viewInput: DMJobTitleSelectionViewInput
    unowned let moduleOutput: DMJobTitleSelectionModuleOutput
    
    init(viewInput: DMJobTitleSelectionViewInput, moduleOutput: DMJobTitleSelectionModuleOutput) {
        self.viewInput = viewInput
        self.moduleOutput = moduleOutput
    }
    
    var jobTitles = [JobTitle]()
    var selectedJobTitle: JobTitle?
}

extension DMJobTitleSelectionPresenter: DMJobTitleSelectionModuleInput {
    
    func viewController() -> UIViewController {
        return viewInput.viewController()
    }
}

extension DMJobTitleSelectionPresenter: DMJobTitleSelectionViewOutput {
 
    func didLoad() {
        
        getJobs()
    }
    
    func onCreateProfileButtonTap(profileImage: UIImage?, params: [String : Any]) {
        
        if let profileImage = profileImage, let imageData = profileImage.jpegData(compressionQuality: 0.5) {
            
            var paramsWithImage = params
            paramsWithImage["image"] = imageData
            
            viewInput.showLoading()
            APIManager.apiMultipart(serviceName: Constants.API.uploadImage, parameters: paramsWithImage, completionHandler: { [weak self] (response: JSON?, error: NSError?) in
                
                self?.viewInput.hideLoading()
                self?.updateLicenseDetails(params: params)
                if let error = error {
                    self?.viewInput.show(toastMessage: error.localizedDescription)
                }
                
                guard let response = response else {
                    self?.viewInput.show(toastMessage: Constants.AlertMessage.somethingWentWrong)
                    return
                }
                
                if response[Constants.ServerKey.status].boolValue {
                    
                    UserManager.shared().activeUser.profileImageURL = response[Constants.ServerKey.result][Constants.ServerKey.profileImageURL].stringValue
                    self?.viewInput.show(toastMessage: response[Constants.ServerKey.message].stringValue)
                } else {
                    self?.viewInput.show(toastMessage: response[Constants.ServerKey.message].stringValue)
                }
                
            })
        } else {
            updateLicenseDetails(params: params)
        }
    }
    
    func openStates(preselectedState: String?, delegate: SearchStateViewControllerDelegate?) {
        moduleOutput.showStates(preselectedState: preselectedState, delegate: delegate)
    }
}

extension DMJobTitleSelectionPresenter {
    
    private func getJobs() {
        
        viewInput.showLoading()
        APIManager.apiGet(serviceName: Constants.API.getJobTitle, parameters: [:]) { [weak self] (response: JSON?, error: NSError?) in
            
            self?.viewInput.hideLoading()
            if let error = error  {
                self?.viewInput.show(toastMessage: error.localizedDescription)
            }
            
            guard let response = response else {
                self?.viewInput.show(toastMessage: Constants.AlertMessage.somethingWentWrong)
                return
            }
            
            if response[Constants.ServerKey.status].boolValue {
                
                let skillList = response[Constants.ServerKey.result][Constants.ServerKey.joblists].array
                var jobTitles = [JobTitle]()
                for jobObject in skillList! {
                    let job = JobTitle(job: jobObject)
                    jobTitles.append(job)
                }
                
                self?.viewInput.configureView(jobTitles: jobTitles)
                self?.jobTitles = jobTitles
            } else {
                self?.viewInput.show(toastMessage: response[Constants.ServerKey.message].stringValue)
            }
        }
    }
    
    private func updateLicenseDetails(params: [String: Any]) {
        
        viewInput.showLoading()
        APIManager.apiPut(serviceName: Constants.API.licenseNumberAndState, parameters: params) { [weak self] (response: JSON?, error: NSError?) in
            
            self?.viewInput.hideLoading()
            
            if let error = error {
                self?.viewInput.show(toastMessage: error.localizedDescription)
            }
            
            guard let response = response else {
                self?.viewInput.show(toastMessage: Constants.AlertMessage.somethingWentWrong)
                return
            }
            
            if response[Constants.ServerKey.status].boolValue {
                
                let user = response[Constants.ServerKey.result]["userDetails"]
                UserManager.shared().activeUser.jobTitle = user[Constants.ServerKey.jobtitleName].stringValue
                UserManager.shared().activeUser.jobTitleId = user[Constants.ServerKey.jobTitileId].stringValue
                UserManager.shared().activeUser.profileImageURL = user[Constants.ServerKey.profilePic].stringValue
                UserManager.shared().activeUser.preferredJobLocation = user[Constants.ServerKey.preferredLocationName].stringValue
                UserManager.shared().activeUser.preferredLocationId = user[Constants.ServerKey.preferredJobLocationId].stringValue
                UserManager.shared().activeUser.state = user[Constants.ServerKey.state].stringValue
                UserManager.shared().activeUser.licenseNumber = user[Constants.ServerKey.licenseNumber].stringValue
                UserManager.shared().activeUser.isJobSeekerVerified = user["isJobSeekerVerified"].boolValue
                UserManager.shared().saveActiveUser()
                
                self?.moduleOutput.showSuccessPending(isEmailVerified: user["isVerified"].stringValue == "1",
                                                      isLicenseRequired: self?.selectedJobTitle?.isLicenseRequired == true,
                                                      fromRoot: false)
            } else {
                
                self?.viewInput.show(toastMessage: response[Constants.ServerKey.message].stringValue)
            }
        }
    }
}

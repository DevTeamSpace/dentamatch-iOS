import Foundation
import SwiftyJSON

class DMPublicProfilePresenter: DMPublicProfilePresenterProtocol {
    
    unowned let viewInput: DMPublicProfileViewInput
    unowned let moduleOutput: DMPublicProfileModuleOutput
    
    var jobTitles: [JobTitle]
    var selectedJob: JobTitle?
    
    init(jobTitles: [JobTitle]?, selectedJob: JobTitle?, viewInput: DMPublicProfileViewInput, moduleOutput: DMPublicProfileModuleOutput) {
        self.jobTitles = jobTitles ?? []
        self.selectedJob = selectedJob
        self.viewInput = viewInput
        self.moduleOutput = moduleOutput
    }
    
    var originalParams = [String: String]()
    
    var editProfileParams = [
        Constants.ServerKey.firstName: "",
        Constants.ServerKey.lastName: "",
        Constants.ServerKey.preferredJobLocation: "",
        Constants.ServerKey.preferredJobLocationId: "",
        Constants.ServerKey.jobTitileId: "",
        Constants.ServerKey.aboutMe: "",
        Constants.ServerKey.licenseNumber: "",
        Constants.ServerKey.state: "",
    ]
    
    var profileImage: UIImage?
    var preferredLocations = [PreferredLocation]()
    var selectedLocation: PreferredLocation?
    var licenseString: String?
    var stateString: String?
}

extension DMPublicProfilePresenter: DMPublicProfileModuleInput {
    
    func viewController() -> UIViewController {
        return viewInput.viewController()
    }
}

extension DMPublicProfilePresenter: DMPublicProfileViewOutput {
    
    func didLoad() {
        
        licenseString = UserManager.shared().activeUser.licenseNumber
        stateString = UserManager.shared().activeUser.state
        
        editProfileParams[Constants.ServerKey.firstName] = UserManager.shared().activeUser.firstName
        editProfileParams[Constants.ServerKey.lastName] = UserManager.shared().activeUser.lastName
        editProfileParams[Constants.ServerKey.jobTitileId] = String(selectedJob?.jobId ?? -1)
        editProfileParams[Constants.ServerKey.licenseNumber] = licenseString
        editProfileParams[Constants.ServerKey.state] = stateString
        
        editProfileParams[Constants.ServerKey.preferredJobLocation] = UserManager.shared().activeUser.preferredJobLocation
        editProfileParams[Constants.ServerKey.preferredJobLocationId] = UserManager.shared().activeUser.preferredLocationId
        
        editProfileParams[Constants.ServerKey.aboutMe] = UserManager.shared().activeUser.aboutMe
        
        originalParams = editProfileParams
        
        getPreferredLocations()
    }
    
    func validateFields() -> Bool {
        
        if editProfileParams[Constants.ServerKey.firstName]!.isEmptyField {
            viewInput.show(toastMessage: Constants.AlertMessage.emptyFirstName)
            return false
        }
        
        if editProfileParams[Constants.ServerKey.lastName]!.isEmptyField {
            viewInput.show(toastMessage: Constants.AlertMessage.emptyLastName)
            return false
        }
        
        if editProfileParams[Constants.ServerKey.aboutMe]!.isEmptyField {
            viewInput.show(toastMessage: Constants.AlertMessage.emptyAboutMe)
            return false
        }
        
        if selectedJob?.isLicenseRequired == false {
            editProfileParams[Constants.ServerKey.licenseNumber] = nil
            editProfileParams[Constants.ServerKey.state] = nil
        } else {
            if editProfileParams[Constants.ServerKey.licenseNumber]!.isEmptyField {
                viewInput.show(toastMessage: Constants.AlertMessage.emptyLicenseNumber)
                return false
            }
            if editProfileParams[Constants.ServerKey.state]!.isEmptyField {
                viewInput.show(toastMessage: Constants.AlertMessage.emptyState)
                return false
            }
        }
        return true
    }
    
    func updatePublicProfile() {
        
        viewInput.showLoading()
        APIManager.apiPut(serviceName: Constants.API.updateUserProfile, parameters: editProfileParams) { [weak self] (response: JSON?, error: NSError?) in
            
            self?.viewInput.hideLoading()
            
            if let error = error {
                self?.viewInput.show(toastMessage: error.localizedDescription)
                return
            }
            
            guard let response = response else {
                self?.viewInput.show(toastMessage: Constants.AlertMessage.somethingWentWrong)
                return
            }
            
            self?.handleUpdateProfileResponse(response: response)
        }
    }
    
    func uploadProfileImage(_ image: UIImage) {
        guard let imageData = image.jpegData(compressionQuality: 0.5) else {
            viewInput.show(toastMessage: "Profile Image problem")
            return
        }
        
        profileImage = image
        
        let params: [String: Any] = [ "type": "profile_pic",
                                      "image": imageData ]
        
        viewInput.showLoading()
        APIManager.apiMultipart(serviceName: Constants.API.uploadImage, parameters: params, completionHandler: { [weak self] (response: JSON?, error: NSError?) in
            
            
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
                UserManager.shared().activeUser.profileImageURL = response[Constants.ServerKey.result][Constants.ServerKey.profileImageURL].stringValue
                UserManager.shared().saveActiveUser()
                self?.viewInput.show(toastMessage: response[Constants.ServerKey.message].stringValue)
                NotificationCenter.default.post(name: .updateProfileScreen, object: nil, userInfo: nil)
                self?.viewInput.reloadData()
            } else {
                self?.viewInput.show(toastMessage: response[Constants.ServerKey.message].stringValue)
            }
        })
    }
    
    func openStates(preselectedState: String?, delegate: SearchStateViewControllerDelegate?) {
        moduleOutput.showStates(preselectedState: preselectedState, delegate: delegate)
    }
    
    func textFieldDidEndEditins(type: ProfileOptions, text: String) {
        
        switch type {
        case .firstName:
            editProfileParams[Constants.ServerKey.firstName] = text
        case .lastName:
            editProfileParams[Constants.ServerKey.lastName] = text
        case .preferredJobLocation:
            editProfileParams[Constants.ServerKey.preferredJobLocation] = text
        case .jobTitle:
            editProfileParams[Constants.ServerKey.jobTitle] = text
        case .state:
            editProfileParams[Constants.ServerKey.state] = text
        case .license:
            editProfileParams[Constants.ServerKey.licenseNumber] = text
            licenseString = text
        }
    }
    
    func onPickerDoneButtonTap(job: JobTitle?) {
        
        selectedJob = job
        if selectedJob?.jobTitle != UserManager.shared().activeUser.jobTitle {
            licenseString = nil
            stateString = nil
            editProfileParams[Constants.ServerKey.state] = ""
            editProfileParams[Constants.ServerKey.licenseNumber] = ""
        }

    }
}

extension DMPublicProfilePresenter {
    
    private func getPreferredLocations() {

        
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
                    self?.preferredLocations.append(PreferredLocation(preferredLocation: location))
                }
                
                self?.viewInput.configureLocationPicker(locations: self?.preferredLocations ?? [])
            } else {
                self?.viewInput.show(toastMessage: response[Constants.ServerKey.message].stringValue)
            }
        }
    }
    
    private func handleUpdateProfileResponse(response: JSON?) {
        if let response = response {
            if response[Constants.ServerKey.status].boolValue {
                
                updateUserDetailsOnSuccess()
                viewInput.show(toastMessage: response[Constants.ServerKey.message].stringValue)
                
                NotificationCenter.default.post(name: .updateProfileScreen, object: nil, userInfo: nil)
                NotificationCenter.default.post(name: .profileUpdated, object: nil, userInfo:nil)
                viewInput.popViewController()
            } else {
                 viewInput.show(toastMessage: response[Constants.ServerKey.message].stringValue)
            }
        }
    }
    
    private func updateUserDetailsOnSuccess() {
        UserManager.shared().activeUser.firstName = editProfileParams[Constants.ServerKey.firstName]
        UserManager.shared().activeUser.lastName = editProfileParams[Constants.ServerKey.lastName]
        UserManager.shared().activeUser.preferredJobLocation = editProfileParams[Constants.ServerKey.preferredJobLocation]
        UserManager.shared().activeUser.preferredLocationId = editProfileParams[Constants.ServerKey.preferredJobLocationId]
        
        UserManager.shared().activeUser.jobTitleId = "\(selectedJob?.jobId ?? -1)"
        UserManager.shared().activeUser.jobTitle = selectedJob?.jobTitle
        
        UserManager.shared().activeUser.aboutMe = editProfileParams[Constants.ServerKey.aboutMe]
        if let _ = editProfileParams[Constants.ServerKey.state] {
            UserManager.shared().activeUser.state = editProfileParams[Constants.ServerKey.state]
        } else {
            UserManager.shared().activeUser.state = ""
        }
        if let _ = editProfileParams[Constants.ServerKey.licenseNumber] {
            UserManager.shared().activeUser.licenseNumber = editProfileParams[Constants.ServerKey.licenseNumber]
        } else {
            UserManager.shared().activeUser.licenseNumber = ""
        }
        UserManager.shared().saveActiveUser()
    }
}

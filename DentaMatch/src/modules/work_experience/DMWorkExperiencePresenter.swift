import Foundation
import SwiftyJSON

class DMWorkExperiencePresenter: DMWorkExperiencePresenterProtocol {
    
    unowned let viewInput: DMWorkExperienceViewInput
    unowned let moduleOutput: DMWorkExperienceModuleOutput
    
    var jobTitles: [JobTitle]
    var isEditing: Bool
    
    init(jobTitles: [JobTitle]?, isEditing: Bool, viewInput: DMWorkExperienceViewInput, moduleOutput: DMWorkExperienceModuleOutput) {
        self.jobTitles = jobTitles ?? []
        self.isEditing = isEditing
        self.viewInput = viewInput
        self.moduleOutput = moduleOutput
    }
    
    var exprienceArray = [ExperienceModel]()
    var exprienceDetailArray = NSMutableArray()
    var currentExperience = ExperienceModel(empty: "")
    var selectedIndex: Int = 0
    var isHiddenExperienceTable = false
}

extension DMWorkExperiencePresenter: DMWorkExperienceModuleInput {
    
    func viewController() -> UIViewController {
        return viewInput.viewController()
    }
}

extension DMWorkExperiencePresenter: DMWorkExperienceViewOutput {
    
    func getExperience() {
        
        viewInput.showLoading()
        APIManager.apiPost(serviceName: Constants.API.getWorkExperience, parameters: [:]) { [weak self] (response: JSON?, error: NSError?) in
            
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
                let experienceList = response[Constants.ServerKey.result][Constants.ServerKey.list].array
                self?.exprienceArray.removeAll()
                for jobObject in experienceList! {
                    let experienceObj = ExperienceModel(json: jobObject)
                    self?.exprienceArray.append(experienceObj)
                }
                
                if self?.exprienceArray.count != 0 {
                    self?.currentExperience.isFirstExperience = false
                }
                
                self?.viewInput.reloadData()
            } else {
                self?.viewInput.show(toastMessage: response[Constants.ServerKey.message].stringValue)
            }
        }
    }
    
    func saveUpdateExperience(isAddExperience: Bool) {
        
        viewInput.showLoading()
        APIManager.apiPost(serviceName: Constants.API.workExperienceSave, parameters: getParams()) { [weak self] (response: JSON?, error: NSError?) in
            
            self?.viewInput.hideLoading()
            
            if let error = error {
                self?.viewInput.show(toastMessage: error.localizedDescription)
                return
            }
            
            guard let response = response else {
                self?.viewInput.show(toastMessage: Constants.AlertMessage.somethingWentWrong)
                return
            }
            
            self?.viewInput.show(toastMessage: response[Constants.ServerKey.message].stringValue)
            
            if response[Constants.ServerKey.status].boolValue, let resultArray = response[Constants.ServerKey.result][Constants.ServerKey.list].array {
                
                if resultArray.count > 0, let dict = resultArray[0].dictionary {
                    self?.currentExperience.experienceID = dict[Constants.ServerKey.experienceId]?.intValue ?? -1
                }
                
                if self?.currentExperience.isEditMode == true {
                    self?.exprienceArray[self?.selectedIndex ?? 0] = self?.currentExperience ?? ExperienceModel(empty: "")
                    
                } else {
                    self?.exprienceArray.append(self?.currentExperience ?? ExperienceModel(empty: ""))
                }
                
                self?.isHiddenExperienceTable = false
                self?.currentExperience = ExperienceModel(empty: "")
                self?.currentExperience.isFirstExperience = false
                self?.currentExperience.references.append(EmployeeReferenceModel(empty: ""))
                
                self?.viewInput.reloadData()
                
                NotificationCenter.default.post(name: .updateProfileScreen, object: nil, userInfo: ["workExperiences": self?.exprienceArray ?? []])
                
                if self?.isEditing == true, !isAddExperience {
                    self?.viewInput.popViewController()
                }
            }
        }
    }
    
    func saveUpdateExperience() {
        saveUpdateExperience(isAddExperience: false)
    }
    
    func openStates(preselectedState: String?, delegate: SearchStateViewControllerDelegate?) {
        moduleOutput.showStates(preselectedState: preselectedState, delegate: delegate)
    }
    
    func deleteExperience() {
        
        var params = [String: Any]()
        params[Constants.ServerKey.experienceId] = currentExperience.experienceID
        
        viewInput.showLoading()
        APIManager.apiDelete(serviceName: Constants.API.deleteExperience, parameters: params) { [weak self] (response: JSON?, error: NSError?) in
            
            self?.viewInput.hideLoading()
            
            if let error = error {
                self?.viewInput.show(toastMessage: error.localizedDescription)
                return
            }
            
            guard let response = response else {
                self?.viewInput.show(toastMessage: Constants.AlertMessage.somethingWentWrong)
                return
            }
            
            self?.viewInput.show(toastMessage: response[Constants.ServerKey.message].stringValue)
            
            if response[Constants.ServerKey.status].boolValue {
                
                self?.exprienceArray.removeObject(object: self?.currentExperience ?? ExperienceModel(empty: ""))
                self?.currentExperience = ExperienceModel(empty: "")
                self?.currentExperience.isFirstExperience = false
                self?.currentExperience.references.append(EmployeeReferenceModel(empty: ""))
                self?.isHiddenExperienceTable = false
                
                self?.viewInput.reloadData()
                NotificationCenter.default.post(name: .updateProfileScreen, object: nil, userInfo: ["workExperiences": self?.exprienceArray ?? []])
            }
        }
    }
}

extension DMWorkExperiencePresenter {
    
    private func getParams() -> [String: Any] {
        
        var params = [String: Any]()
        params[Constants.ServerKey.jobTitleId] = currentExperience.jobTitleID
        params[Constants.ServerKey.monthsOfExperience] = currentExperience.experienceInMonth
        params[Constants.ServerKey.officeName] = currentExperience.officeName
        params[Constants.ServerKey.officeAddressExp] = currentExperience.officeAddress
        params[Constants.ServerKey.cityName] = currentExperience.cityName
        params[Constants.ServerKey.stateName] = currentExperience.stateName
        
        for index in 0 ..< (currentExperience.references.count) {
            let refObj = currentExperience.references[index]
            if index == 0 {
                if (refObj.referenceName?.isEmptyField)! && (refObj.mobileNumber?.isEmptyField)! && (refObj.email?.isEmptyField)! {
                    // no need to do action
                } else {
                    params[Constants.ServerKey.reference1Name] = refObj.referenceName
                    params[Constants.ServerKey.reference1Mobile] = refObj.mobileNumber
                    params[Constants.ServerKey.reference1Email] = refObj.email
                }
                
            } else {
                if (refObj.referenceName?.isEmptyField)! && (refObj.mobileNumber?.isEmptyField)! && (refObj.email?.isEmptyField)! {
                    // no need to do action
                    currentExperience.references.removeObject(object: refObj)
                } else {
                    params[Constants.ServerKey.reference2Name] = refObj.referenceName
                    params[Constants.ServerKey.reference2Mobile] = refObj.mobileNumber
                    params[Constants.ServerKey.reference2Email] = refObj.email
                }
            }
        }
        
        if isEditing == true {
            params[Constants.ServerKey.experienceId] = currentExperience.experienceID
            params["action"] = "edit"
        } else {
            params["action"] = "add"
        }
        
        return params
    }
}

import Foundation
import SwiftyJSON

class DMAffiliationsPresenter: DMAffiliationsPresenterProtocol {
    
    unowned let viewInput: DMAffiliationsViewInput
    unowned let moduleOutput: DMAffiliationsModuleOutput
    
    var selectedAffiliationsFromProfile: [Affiliation]
    var isEditing: Bool
    
    init(affiliations: [Affiliation]?, isEditing: Bool, viewInput: DMAffiliationsViewInput, moduleOutput: DMAffiliationsModuleOutput) {
        selectedAffiliationsFromProfile = affiliations ?? []
        self.isEditing = isEditing
        self.viewInput = viewInput
        self.moduleOutput = moduleOutput
    }
    
    var isOtherSelected = false
    var otherText = ""
    var affiliations = [Affiliation]()
}

extension DMAffiliationsPresenter: DMAffiliationsModuleInput {
    
    func viewController() -> UIViewController {
        return viewInput.viewController()
    }
}

extension DMAffiliationsPresenter: DMAffiliationsViewOutput {
    
    func getAffiliations() {
        
        viewInput.showLoading()
        APIManager.apiGet(serviceName: Constants.API.getAffiliationList, parameters: [:]) { [weak self] (response: JSON?, error: NSError?) in
            
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
                
                let affiliationList = response[Constants.ServerKey.result][Constants.ServerKey.list].arrayValue
                for affiliationObj in affiliationList {
                    let affiliation = Affiliation(affiliation: affiliationObj)
                    self?.affiliations.append(affiliation)
                }
                
                self?.viewInput.reloadData()
            } else {
                self?.viewInput.show(toastMessage: response[Constants.ServerKey.message].stringValue)
            }
        }
    }
    
    func saveAffiliationData() {
        
        var params = [String: AnyObject]()
        var other = [[String: String]]()
        var otherObject = [String: String]()
        
        var selectedAffiliationIds = [String]()
        for affiliation in affiliations {
            if affiliation.isSelected {
                if !affiliation.isOther {
                    selectedAffiliationIds.append(affiliation.affiliationId)
                }
            }
        }
        
        // For other affiliation
        let affiliationArray = affiliations.filter { (obj) -> Bool in
            obj.affiliationId == "9"
        } // affiliations[affiliations.count - 1]
        if affiliationArray.count > 0 {
            let affiliation = affiliationArray[0]
            if affiliation.isSelected {
                if let otherAffiliation = affiliation.otherAffiliation {
                    if otherAffiliation.trim().isEmpty {
                        viewInput.show(toastMessage: "Other affiliation can't be empty")
                        return
                    }
                    otherObject[Constants.ServerKey.affiliationId] = affiliation.affiliationId
                    otherObject[Constants.ServerKey.otherAffiliation] = otherText
                    other.append(otherObject)
                }
            }
            if !affiliation.isSelected {
                if selectedAffiliationIds.count == 0 {
                    viewInput.show(toastMessage: "Please select atleast one affiliation")
                    return
                }
            }
        }
        
        params[Constants.ServerKey.affiliationDataArray] = selectedAffiliationIds as AnyObject?
        params[Constants.ServerKey.other] = other as AnyObject?
        
        viewInput.showLoading()
        APIManager.apiPostWithJSONEncode(serviceName: Constants.API.saveAffiliationList, parameters: params) { [weak self] (response: JSON?, error: NSError?) in
            
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
                self?.viewInput.show(toastMessage: response[Constants.ServerKey.message].stringValue)
                if self?.isEditing == true {
                    NotificationCenter.default.post(name: .updateProfileScreen, object: nil, userInfo: ["affiliations": self?.affiliations.filter({ $0.isSelected == true }) ?? []])
                    self?.viewInput.popViewController()
                } else {
                    //openCertificationScreen()
                }
            } else {
                self?.viewInput.show(toastMessage: response[Constants.ServerKey.message].stringValue)
            }
        }
    }
}

extension DMAffiliationsPresenter {
    
}

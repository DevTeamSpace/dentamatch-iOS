//
//  DMWorkExperienceVC+Services.swift
//  DentaMatch
//
//  Created by Sanjay Kumar Yadav on 12/01/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import Foundation
import SwiftyJSON

extension DMWorkExperienceVC {
    func getExperienceAPI() {
        showLoader()
        APIManager.apiPost(serviceName: Constants.API.getWorkExperience, parameters: [:]) { (response: JSON?, error: NSError?) in
            self.hideLoader()
            if error != nil {
                self.makeToast(toastString: (error?.localizedDescription)!)
                return
            }
            if response == nil {
                self.makeToast(toastString: Constants.AlertMessage.somethingWentWrong)
                return
            }
            ////debugPrint(response!)
            self.handleExperienceListResponse(response: response!)
        }
    }

    func handleExperienceListResponse(response: JSON?) {
        if let response = response {
            if response[Constants.ServerKey.status].boolValue {
                let experienceList = response[Constants.ServerKey.result][Constants.ServerKey.list].array
                exprienceArray.removeAll()
                for jobObject in experienceList! {
                    let experienceObj = ExperienceModel(json: jobObject)
                    exprienceArray.append(experienceObj)
                }

                if exprienceArray.count > 0 {
                    currentExperience?.isFirstExperience = false
                }
                workExperienceTable.reloadData()
                workExperienceDetailTable.reloadData()
                reSizeTableViewsAndScrollView()

            } else {
                makeToast(toastString: response[Constants.ServerKey.message].stringValue)
            }
        }
    }

    func getParamsForSaveAndUpdate(isEdit: Bool) -> [String: AnyObject] {
        var params = [String: AnyObject]()
        params[Constants.ServerKey.jobTitleId] = currentExperience?.jobTitleID as AnyObject?
        params[Constants.ServerKey.monthsOfExperience] = currentExperience?.experienceInMonth as AnyObject?
        params[Constants.ServerKey.officeName] = currentExperience?.officeName as AnyObject?
        params[Constants.ServerKey.officeAddressExp] = currentExperience?.officeAddress as AnyObject?
        params[Constants.ServerKey.cityName] = currentExperience?.cityName as AnyObject?
        params[Constants.ServerKey.stateName] = currentExperience?.stateName as AnyObject?
        for index in 0 ..< (currentExperience!.references.count) {
            let refObj = currentExperience?.references[index]
            if index == 0 {
                if (refObj!.referenceName?.isEmptyField)! && (refObj?.mobileNumber?.isEmptyField)! && (refObj?.email?.isEmptyField)! {
                    // no need to do action
                } else {
                    params[Constants.ServerKey.reference1Name] = refObj?.referenceName as AnyObject?
                    params[Constants.ServerKey.reference1Mobile] = refObj?.mobileNumber as AnyObject?
                    params[Constants.ServerKey.reference1Email] = refObj?.email as AnyObject?
                }

            } else {
                if (refObj!.referenceName?.isEmptyField)! && (refObj?.mobileNumber?.isEmptyField)! && (refObj?.email?.isEmptyField)! {
                    // no need to do action
                    currentExperience?.references.removeObject(object: refObj!)
                } else {
                    params[Constants.ServerKey.reference2Name] = refObj?.referenceName as AnyObject?
                    params[Constants.ServerKey.reference2Mobile] = refObj?.mobileNumber as AnyObject?
                    params[Constants.ServerKey.reference2Email] = refObj?.email as AnyObject?
                }
            }
        }

        if isEdit == true {
            params[Constants.ServerKey.experienceId] = currentExperience?.experienceID as AnyObject?
            params["action"] = "edit" as AnyObject
        } else {
            params["action"] = "add" as AnyObject
        }

        return params
    }

    func saveUpdateExperience(params: [String: AnyObject], completionHandler: @escaping (JSON?, NSError?) -> Void) {
        // debugPrint("Experience Parameters\n\(params.description))")

        showLoader()
        APIManager.apiPost(serviceName: Constants.API.workExperienceSave, parameters: params) { (response: JSON?, error: NSError?) in
            self.hideLoader()
            if error != nil {
                self.makeToast(toastString: (error?.localizedDescription)!)
                return
            }
            guard let _ = response else {
                self.makeToast(toastString: Constants.AlertMessage.somethingWentWrong)
                return
            }
            // debugPrint(response!)

            if response![Constants.ServerKey.status].boolValue {
                self.makeToast(toastString: response![Constants.ServerKey.message].stringValue)
                // do next
                completionHandler(response, error)

            } else {
                self.makeToast(toastString: response![Constants.ServerKey.message].stringValue)
                completionHandler(response, error)
            }
        }
    }

    func deleteExperience(completionHandler: @escaping (Bool?, NSError?) -> Void) {
        var params = [String: AnyObject]()
        params[Constants.ServerKey.experienceId] = currentExperience?.experienceID as AnyObject?
        // debugPrint("Experience Parameters\n\(params.description))")

        showLoader()
        APIManager.apiDelete(serviceName: Constants.API.deleteExperience, parameters: params) { (response: JSON?, error: NSError?) in
            self.hideLoader()
            if error != nil {
                self.makeToast(toastString: (error?.localizedDescription)!)
                return
            }
            guard let _ = response else {
                self.makeToast(toastString: Constants.AlertMessage.somethingWentWrong)
                return
            }
//            //debugPrint(response!)

            if response![Constants.ServerKey.status].boolValue {
                self.makeToast(toastString: response![Constants.ServerKey.message].stringValue)
                completionHandler(true, error)
                // do next
            } else {
                self.makeToast(toastString: response![Constants.ServerKey.message].stringValue)
                completionHandler(false, error)
            }
        }
    }
}

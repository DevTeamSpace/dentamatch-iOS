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
        self.showLoader()
        APIManager.apiPost(serviceName: Constants.API.getWorkExperience, parameters: [:]) { (response:JSON?, error:NSError?) in
            self.hideLoader()
            if error != nil {
                self.makeToast(toastString: (error?.localizedDescription)!)
                return
            }
            if response == nil {
                self.makeToast(toastString: Constants.AlertMessage.somethingWentWrong)
                return
            }
            print(response!)
            self.handleExperienceListResponse(response: response!)
        }
    }
    
    func handleExperienceListResponse(response:JSON?) {
        if let response = response {
            if response[Constants.ServerKey.status].boolValue {
                let experienceList = response[Constants.ServerKey.result][Constants.ServerKey.list].array
                self.exprienceArray.removeAll()
                for jobObject in experienceList! {
                    let experienceObj = ExperienceModel(json: jobObject)
                    self.exprienceArray.append(experienceObj)
                }
                
                self.workExperienceTable.reloadData()
                self.workExperienceDetailTable.reloadData()
                self.reSizeTableViewsAndScrollView()

                
            } else {
                self.makeToast(toastString: response[Constants.ServerKey.message].stringValue)
            }
        }
    }

    func getParamsForSaveAndUpdate(isEdit:Bool) ->[String:AnyObject]
    {
        var params = [String:AnyObject]()
        params[Constants.ServerKey.jobTitleId] = self.currentExperience?.jobTitleID as AnyObject?
        params[Constants.ServerKey.monthsOfExperience] = self.currentExperience?.experienceInMonth as AnyObject?
        params[Constants.ServerKey.officeName] = self.currentExperience?.officeName as AnyObject?
        params[Constants.ServerKey.officeAddressExp] = self.currentExperience?.officeAddress as AnyObject?
        params[Constants.ServerKey.cityName] = self.currentExperience?.cityName as AnyObject?
        
        for index in 0..<(self.currentExperience!.references.count) {
            let refObj = self.currentExperience?.references[index]
            if index == 0 {
                params[Constants.ServerKey.reference1Name] = refObj?.referenceName as AnyObject?
                params[Constants.ServerKey.reference1Mobile] = refObj?.mobileNumber as AnyObject?
                params[Constants.ServerKey.reference1Email] = refObj?.email as AnyObject?
                
            }else {
                params[Constants.ServerKey.reference2Name] = refObj?.referenceName as AnyObject?
                params[Constants.ServerKey.reference1Mobile] = refObj?.mobileNumber as AnyObject?
                params[Constants.ServerKey.reference2Email] = refObj?.email as AnyObject?
            }
            
        }
        


        if isEdit == true{
            params[Constants.ServerKey.experienceId] = self.currentExperience?.experienceID as AnyObject?
            params["action"] = "edit" as AnyObject
        }else{
            params["action"] = "add" as AnyObject
        }

        return params
    }
    func saveUpdateExperience(params:[String:AnyObject],completionHandler: @escaping (Bool?, NSError?) -> ()) {
        print("Experience Parameters\n\(params.description))")

        self.showLoader()
        APIManager.apiPost(serviceName: Constants.API.workExperienceSave, parameters: params) { (response:JSON?, error:NSError?) in
            self.hideLoader()
            if error != nil {
                self.makeToast(toastString: (error?.localizedDescription)!)
                return
            }
            guard let _ = response else {
                self.makeToast(toastString: Constants.AlertMessage.somethingWentWrong)
                return
            }
            debugPrint(response!)
            
            if response![Constants.ServerKey.status].boolValue {
                self.makeToast(toastString: response![Constants.ServerKey.message].stringValue)
                //do next
                completionHandler(true, error)

            } else {
                self.makeToast(toastString: response![Constants.ServerKey.message].stringValue)
                completionHandler(false, error)

            }
        }
    }

    
    func deleteExperience(completionHandler: @escaping (Bool?, NSError?) -> ()) {
        var params = [String:AnyObject]()
        params[Constants.ServerKey.experienceId] = self.currentExperience?.experienceID as AnyObject?
        print("Experience Parameters\n\(params.description))")
        
        self.showLoader()
        APIManager.apiDelete(serviceName: Constants.API.deleteExperience, parameters: params) { (response:JSON?, error:NSError?) in
            self.hideLoader()
            if error != nil {
                self.makeToast(toastString: (error?.localizedDescription)!)
                return
            }
            guard let _ = response else {
                self.makeToast(toastString: Constants.AlertMessage.somethingWentWrong)
                return
            }
//            debugPrint(response!)
            
            if response![Constants.ServerKey.status].boolValue {
                self.makeToast(toastString: response![Constants.ServerKey.message].stringValue)
                completionHandler(true, error)
                //do next
            } else {
                self.makeToast(toastString: response![Constants.ServerKey.message].stringValue)
                completionHandler(false, error)

            }
        }
    }

    
}

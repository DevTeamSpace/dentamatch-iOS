//
//  DMLoginVC+Services.swift
//  DentaMatch
//
//  Created by Rajan Maheshwari on 05/01/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import Foundation
import SwiftyJSON

extension DMLoginVC {
    func loginAPI(params: [String: String]) {
        // debugPrint("Login Parameters\n\(params.description))")
        showLoader()
        APIManager.apiPost(serviceName: Constants.API.login, parameters: params) { (response: JSON?, error: NSError?) in
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
            self.handleLoginResponse(response: response!)
        }
    }

    func handleLoginResponse(response: JSON?) {
        UserManager.shared().loginResponseHandler(response: response) { [weak self] (success: Bool, _: String) in
            
            self?.makeToast(toastString: response![Constants.ServerKey.message].stringValue)
            
            if success {
                MixpanelOperations.manageMixpanelUserIdentity()
                MixpanelOperations.registerMixpanelUser()
                MixpanelOperations.trackMixpanelEvent(eventName: "Login")
                
                
                self?.saveSearchedData(response: response!)
                
                SocketIOManager.sharedInstance.establishConnection()
                if (UserManager.shared().activeUser.jobTitleId?.isEmptyField)! {
                    self?.moduleOutput?.showJobTitleSelection()
                } else {
                    UserDefaultsManager.sharedInstance.isProfileSkipped = true
                    self?.moduleOutput?.showTabBar()
                }
            }
        }
    }

    func saveSearchedData(response: JSON?) {
        var searchParams = [String: Any]()
        if let searchFilters = response?[Constants.ServerKey.result][Constants.ServerKey.searchFilters] {
            if searchFilters.count == 0 {
                return
            }

            searchParams[Constants.JobDetailKey.lat] = searchFilters[Constants.JobDetailKey.lat].stringValue
            searchParams[Constants.JobDetailKey.lng] = searchFilters[Constants.JobDetailKey.lng].stringValue
            searchParams[Constants.JobDetailKey.zipCode] = searchFilters[Constants.JobDetailKey.zipCode].stringValue
            searchParams[Constants.JobDetailKey.city] = searchFilters[Constants.JobDetailKey.city].stringValue
            searchParams[Constants.JobDetailKey.country] = searchFilters[Constants.JobDetailKey.country].stringValue
            searchParams[Constants.JobDetailKey.state] = searchFilters[Constants.JobDetailKey.state].stringValue

            searchParams[Constants.JobDetailKey.isFulltime] = searchFilters[Constants.JobDetailKey.isFulltime].stringValue
            searchParams[Constants.JobDetailKey.isParttime] = searchFilters[Constants.JobDetailKey.isParttime].stringValue

            if let partTimeDays = searchFilters[Constants.JobDetailKey.parttimeDays].arrayObject as? [String] {
                searchParams[Constants.JobDetailKey.parttimeDays] = partTimeDays
            }

            if let jobTitles = searchFilters[Constants.JobDetailKey.jobTitle].arrayObject as? [String] {
                searchParams[Constants.JobDetailKey.jobTitle] = jobTitles
            }

            if let customJobTitlesArray = searchFilters[Constants.JobDetailKey.jobTitles].arrayObject as? [[String: Any]] {
                searchParams[Constants.JobDetailKey.jobTitles] = customJobTitlesArray
            }

            searchParams[Constants.JobDetailKey.address] = searchFilters[Constants.JobDetailKey.address].stringValue

            UserDefaultsManager.sharedInstance.deleteSearchParameter()
            UserDefaultsManager.sharedInstance.saveSearchParameter(seachParam: searchParams as Any)
        }
    }
}

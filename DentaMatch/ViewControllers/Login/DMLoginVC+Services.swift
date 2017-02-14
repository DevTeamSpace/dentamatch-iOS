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
    
    func loginAPI(params:[String:String]) {
        print("Login Parameters\n\(params.description))")
        self.showLoader()
        APIManager.apiPost(serviceName: Constants.API.login, parameters: params) { (response:JSON?, error:NSError?) in
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
            self.handleLoginResponse(response: response!)
        }
    }
    
    func handleLoginResponse(response:JSON?) {
        UserManager.shared().loginResponseHandler(response: response) { (success:Bool, message:String) in
            self.makeToast(toastString: response![Constants.ServerKey.message].stringValue)
            if success {
                SocketManager.sharedInstance.establishConnection()
                self.saveSearchedData(response: response!)
                self.openJobTitleSelection()
            }
        }
    }
    
    func saveSearchedData(response:JSON?) {
        var searchParams = [String : Any]()
        if let searchFilters = response?[Constants.ServerKey.result][Constants.ServerKey.searchFilters] {
                searchParams[Constants.JobDetailKey.lat] = searchFilters[Constants.JobDetailKey.lat].stringValue
                searchParams[Constants.JobDetailKey.lng] = searchFilters[Constants.JobDetailKey.lng].stringValue
                searchParams[Constants.JobDetailKey.zipCode] = searchFilters[Constants.JobDetailKey.zipCode].stringValue
                searchParams[Constants.JobDetailKey.isFulltime] = searchFilters[Constants.JobDetailKey.isFulltime].stringValue
                searchParams[Constants.JobDetailKey.isParttime] = searchFilters[Constants.JobDetailKey.isParttime].stringValue
                searchParams[Constants.JobDetailKey.parttimeDays] = searchFilters[Constants.JobDetailKey.parttimeDays].arrayObject as! [String]
                searchParams[Constants.JobDetailKey.jobTitle] = searchFilters[Constants.JobDetailKey.jobTitle].arrayObject as! [Int]
            searchParams[Constants.JobDetailKey.jobTitles] = searchFilters[Constants.JobDetailKey.jobTitles].arrayObject as! [[String:Any]]
                searchParams[Constants.JobDetailKey.address] = searchFilters[Constants.JobDetailKey.address].stringValue
        }
        UserDefaultsManager.sharedInstance.deleteSearchParameter()
        UserDefaultsManager.sharedInstance.saveSearchParameter(seachParam: searchParams as Any)
    }
}

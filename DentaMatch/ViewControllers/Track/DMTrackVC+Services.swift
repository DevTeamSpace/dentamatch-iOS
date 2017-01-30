//
//  DMTrackVC+Services.swift
//  DentaMatch
//
//  Created by Rajan Maheshwari on 27/01/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import Foundation
import SwiftyJSON

extension DMTrackVC {
    
    func getJobList(params:[String:String]) {
        self.showLoader()
        APIManager.apiGet(serviceName: Constants.API.jobList, parameters: params) { (response:JSON?, error:NSError?) in
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
            self.handleJobListResponse(response: response,type: params["type"]!)
        }
    }
    
    func handleJobListResponse(response:JSON?,type:String) {
        if let response = response {
            print("type returned = \(type)")
            if response[Constants.ServerKey.status].boolValue {
                
            }
            self.makeToast(toastString: response[Constants.ServerKey.message].stringValue)
        }
    }
}

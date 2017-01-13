//
//  DMCertificationsVC+Services.swift
//  DentaMatch
//
//  Created by Rajan Maheshwari on 13/01/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import Foundation
import SwiftyJSON

extension DMCertificationsVC {
    
    func getCertificationListAPI() {
        self.showLoader()
        APIManager.apiGet(serviceName: Constants.API.getCertificationList, parameters: [:]) { (response:JSON?, error:NSError?) in
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
            self.handleCertificationListResponse(response: response)
        }
    }
    
    func handleCertificationListResponse(response:JSON?) {
        
        if let response = response {
            
            if response[Constants.ServerKey.status].boolValue {
                let certificatesList = response[Constants.ServerKey.result][Constants.ServerKey.list].arrayValue
                
                for certificateObj in certificatesList {
                    let certificate = Certification(certification: certificateObj)
                    certicates.append(certificate)
                }
                self.certificationsTableView.reloadData()
            } else {
                self.makeToast(toastString: response[Constants.ServerKey.message].stringValue)
            }
        }
    }
}

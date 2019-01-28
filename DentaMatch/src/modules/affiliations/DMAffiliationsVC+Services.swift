//
//  DMAffiliationsVC+Services.swift
//  DentaMatch
//
//  Created by Rajan Maheshwari on 13/01/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import Foundation
import SwiftyJSON

extension DMAffiliationsVC {
    func getAffiliationListAPI() {
        showLoader()
        APIManager.apiGet(serviceName: Constants.API.getAffiliationList, parameters: [:]) { (response: JSON?, error: NSError?) in
            self.hideLoader()
            if error != nil {
                self.makeToast(toastString: (error?.localizedDescription)!)
                return
            }

            if response == nil {
                self.makeToast(toastString: Constants.AlertMessage.somethingWentWrong)
                return
            }
            // debugPrint(response!)
            self.handleAffiliationListResponse(response: response)
        }
    }

    func saveAffiliationData(params: [String: Any]) {
        // debugPrint(params)
        showLoader()
        APIManager.apiPostWithJSONEncode(serviceName: Constants.API.saveAffiliationList, parameters: params) { (response: JSON?, error: NSError?) in

            self.hideLoader()
            if error != nil {
                self.makeToast(toastString: (error?.localizedDescription)!)
                return
            }

            if response == nil {
                self.makeToast(toastString: Constants.AlertMessage.somethingWentWrong)
                return
            }
            // debugPrint(response!)
            self.handleSaveAffiliationResponse(response: response)
        }
    }

    // MARK: - Response Handling

    func handleAffiliationListResponse(response: JSON?) {
        if let response = response {
            if response[Constants.ServerKey.status].boolValue {
                let affiliationList = response[Constants.ServerKey.result][Constants.ServerKey.list].arrayValue
                for affiliationObj in affiliationList {
                    let affiliation = Affiliation(affiliation: affiliationObj)
                    affiliations.append(affiliation)
                }
                affiliationsTableView.reloadData()
            } else {
                makeToast(toastString: response[Constants.ServerKey.message].stringValue)
            }
        }
    }

    func handleSaveAffiliationResponse(response: JSON?) {
        if let response = response {
            if response[Constants.ServerKey.status].boolValue {
                makeToast(toastString: response[Constants.ServerKey.message].stringValue)
                if isEditMode {
                    manageSelectedAffiliations()
                    _ = navigationController?.popViewController(animated: true)
                } else {
                    openCertificationScreen()
                }
            } else {
                makeToast(toastString: response[Constants.ServerKey.message].stringValue)
            }
        }
    }
}

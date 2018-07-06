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
        showLoader()
        APIManager.apiGet(serviceName: Constants.API.getCertificationList, parameters: [:]) { (response: JSON?, error: NSError?) in
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
            self.handleCertificationListResponse(response: response)
        }
    }

    func handleCertificationListResponse(response: JSON?) {
        if let response = response {
            if response[Constants.ServerKey.status].boolValue {
                let certificatesList = response[Constants.ServerKey.result][Constants.ServerKey.list].arrayValue

                for certificateObj in certificatesList {
                    let certificate = Certification(certification: certificateObj)
                    certicates.append(certificate)
                }
                certificationsTableView.reloadData()
            } else {
                makeToast(toastString: response[Constants.ServerKey.message].stringValue)
            }
        }
    }

    func uploadCetificatsImage(certObj: Certification, completionHandler: @escaping (JSON?, NSError?) -> Void) {
        var params = [String: AnyObject]()
        params["certificateId"] = certObj.certificationId as AnyObject?
//        params["validityDate"] = certObj.validityDate as AnyObject?

        if let profileImageData = certObj.certificateImage {
            if let imageData = UIImageJPEGRepresentation(profileImageData, 0.5) {
                params["image"] = imageData as AnyObject?
                showLoader()
                APIManager.apiMultipart(serviceName: Constants.API.updateCertificate, parameters: params, completionHandler: { (response: JSON?, error: NSError?) in
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

                    completionHandler(response, error)

                })
            } else {
                makeToast(toastString: Constants.AlertMessage.somethingWentWrong)
            }
        }
    }

    func uploadAllValidityDates(completionHandler: @escaping (JSON?, NSError?) -> Void) {
        var params = [String: AnyObject]()

        var allValidatyDates = [AnyObject]()
        for cetificate in certicates {
            if !cetificate.validityDate.isEmptyField {
                let validityDict = ["id": cetificate.certificationId, "value": cetificate.validityDate]
                allValidatyDates.append(validityDict as AnyObject)
            }
        }
        params["certificateValidition"] = allValidatyDates as AnyObject?

        // debugPrint("certificateValidition Parameters\n\(params.description)")
        showLoader()
        APIManager.apiPostWithJSONEncode(serviceName: Constants.API.updateValidationDates, parameters: params) { (response: JSON?, error: NSError?) in
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
            }
        }
    }

    func getDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        return dateFormatter.string(from: date)
    }
}

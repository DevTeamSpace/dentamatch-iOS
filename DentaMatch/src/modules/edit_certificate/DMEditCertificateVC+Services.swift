//
//  DMEditCertificateVC+Services.swift
//  DentaMatch
//
//  Created by Rajan Maheshwari on 24/01/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import Foundation
import SwiftyJSON

extension DMEditCertificateVC {
    func uploadCertificateImage(certObj: Certification, completionHandler: @escaping (JSON?, NSError?) -> Void) {
        var params = [String: AnyObject]()
        params["certificateId"] = certObj.certificationId as AnyObject?
        if let certificateImageData = certificateImage {
            if let imageData = certificateImageData.jpegData(compressionQuality: 0.5) {
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

    func uploadValidityDate(completionHandler: @escaping (JSON?, NSError?) -> Void) {
        var params = [String: AnyObject]()

        var allValidatyDates = [AnyObject]()
        /*var validityDict:[String:String] = [String:String]()
        if isEditingResume {
            validityDict = ["id": self.certificate?.certificationId, "value": ""]
        }else{
           validityDict = ["id": self.certificate?.certificationId, "value": self.dateSelected]
        }*/
        let validityDict = ["id": self.certificate?.certificationId, "value": self.dateSelected == Constants.kEmptyDate ? "" : self.dateSelected ]
        allValidatyDates.append(validityDict as AnyObject)

        params["certificateValidition"] = allValidatyDates as AnyObject?
        LogManager.logDebug("certificateValidition Parameters:\n\(params.description)")
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
}
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
    
    
    func uploadCetificatsImage(certObj:Certification, completionHandler: @escaping (JSON?, NSError?) -> ())  {
        
        
        var params = [String:AnyObject]()
        params["certificateId"] = certObj.certificationId as AnyObject?
//        params["validityDate"] = certObj.validityDate as AnyObject?

        if let profileImageData = certObj.certificateImage {
            if let imageData = UIImageJPEGRepresentation(profileImageData, 0.5) {
                params["image"] = imageData as AnyObject?
                self.showLoader()
                APIManager.apiMultipart(serviceName: Constants.API.updateCertificate, parameters: params, completionHandler: { (response:JSON?, error:NSError?) in
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
//                    self.handleUploadProfileResponse(response: response)
                
                    completionHandler(response, error)

                
                    
                    
                })
            } else {
                self.makeToast(toastString: "Profile Image problem")
            }
        }
        
    }
    
    func uploadAllValidityDates( completionHandler: @escaping (JSON?, NSError?) -> ()){
        var params = [String:AnyObject]()

        var allValidatyDates = [AnyObject]()
        for cetificate in self.certicates {
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MM-yyyy"
//            dateFormatter.timeZone = TimeZone(abbreviation: "UTC")

            let date = dateFormatter.date(from: cetificate.validityDate)
            dateFormatter.dateFormat = Date.dateFormatYYYYMMDDDashed()
            let newDate = dateFormatter.string(from: date!)
            
            
            let validityDict = ["id":cetificate.certificationId,"value":newDate]
            allValidatyDates.append(validityDict as AnyObject)
        }
        params["certificateValidition"] = allValidatyDates as AnyObject?

        
            debugPrint("certificateValidition Parameters\n\(params.description)")
            self.showLoader()
            APIManager.apiPostWithJSONEncode(serviceName: Constants.API.updateValidationDates, parameters: params) { (response:JSON?, error:NSError?) in
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
//                    self.openExperienceFirstScreen()
                    completionHandler(response, error)
                } else {
                    self.makeToast(toastString: response![Constants.ServerKey.message].stringValue)
                }
            }
        
        
    }
    
     func getDate(date:Date)-> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        return dateFormatter.string(from: date)
    }

    
}

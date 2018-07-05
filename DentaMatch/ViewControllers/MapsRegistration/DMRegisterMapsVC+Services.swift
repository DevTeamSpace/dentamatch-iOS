//
//  DMRegisterMapsVC+Services.swift
//  DentaMatch
//
//  Created by Rajan Maheshwari on 31/01/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import Foundation
import SwiftyJSON

extension DMRegisterMapsVC {
    func locationUpdateAPI(location: Location) {
        view.endEditing(true)
        showLoader()
        let params = [
            Constants.ServerKey.preferredLocation: location.address!,
            Constants.ServerKey.latitude: "\(location.coordinateSelected!.latitude)",
            Constants.ServerKey.longitude: "\(location.coordinateSelected!.longitude)",
            Constants.ServerKey.zipCode: "\(location.postalCode)",
            "preferredCity": "\(location.city)",
            "preferredState": "\(location.state)",
            "preferredCountry": "\(location.country)",
        ]

        // debugPrint("Location Update Params\n \(params)")

        APIManager.apiPost(serviceName: Constants.API.updateHomeLocation, parameters: params) { (response: JSON?, error: NSError?) in
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
            self.handleLocationUpdateResponse(response: response)
        }
    }

    func handleLocationUpdateResponse(response: JSON?) {
        if let response = response {
            if response[Constants.ServerKey.status].boolValue {
                if let delegate = self.delegate {
                    addressSelected = placeSearchBar.text!
                    delegate.locationAddress(location: location)
                }
                makeToast(toastString: response[Constants.ServerKey.message].stringValue)
                _ = navigationController?.popViewController(animated: true)
            } else {
                makeToast(toastString: response[Constants.ServerKey.message].stringValue)
            }
        }
    }
}

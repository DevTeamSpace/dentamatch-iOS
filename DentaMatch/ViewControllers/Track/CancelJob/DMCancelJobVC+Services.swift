//
//  DMCancelJobVC+Services.swift
//  DentaMatch
//
//  Created by Rajan Maheshwari on 31/01/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import Foundation
import SwiftyJSON

extension DMCancelJobVC {
    
    func cancelJobAPI() {
        
        let params = [
            Constants.ServerKey.jobId:(job?.jobId)!,
            Constants.ServerKey.cancelReason:self.reasonTextView.text!
        ] as [String : Any]
        debugPrint("Cancel Paran \(params.description)")
        
        self.showLoader()
        APIManager.apiPost(serviceName: Constants.API.cancelJob, parameters: params) { (response:JSON?, error:NSError?) in
            self.hideLoader()
            if error != nil {
                self.makeToast(toastString: (error?.localizedDescription)!)
                return
            }
            guard let _ = response else {
                self.makeToast(toastString: Constants.AlertMessage.somethingWentWrong)
                return
            }
            self.handleCancelJobResponse(response: response)
        }
    }
    
    func handleCancelJobResponse(response:JSON?) {
        if let response = response {
            if response[Constants.ServerKey.status].boolValue {
                if let delegate = delegate {
                    delegate.cancelledJob(job: job!,fromApplied:fromApplied)
                }
                _ = self.navigationController?.popViewController(animated: true)
            }
        }
    }
}

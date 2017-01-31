//
//  DMJobSearchResultVC+Services.swift
//  DentaMatch
//
//  Created by Shailesh Tyagi on 31/01/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import Foundation
import SwiftyJSON

extension DMJobSearchVC {
    
    func saveUnsaveJob(saveStatus:Int,jobId:Int,completionHandler: @escaping (JSON?, NSError?) -> ()) {
//        let params = [
//            Constants.ServerKey.jobId:jobId,
//            Constants.ServerKey.status:saveStatus
//        ]
//        self.showLoader()
//        APIManager.apiPost(serviceName: Constants.API.saveJob, parameters: params) { (response:JSON?, error:NSError?) in
//            self.hideLoader()
//            completionHandler(response,error)
//        }
    }
}

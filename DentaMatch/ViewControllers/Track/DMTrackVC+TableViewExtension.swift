//
//  DMTrackVC+TableViewExtension.swift
//  DentaMatch
//
//  Created by Rajan Maheshwari on 30/01/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import Foundation

extension DMTrackVC:UITableViewDataSource,UITableViewDelegate {

    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 170
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return savedJobs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "JobSearchResultCell") as! JobSearchResultCell
        let job = savedJobs[indexPath.row]
        cell.lblJobTitle.text = job.jobtitle
        cell.lblDocName.text = job.officeName
        cell.lblAddress.text = job.address
        cell.lblDistance.text = String(format: "%.2f", job.distance) + " miles"
        cell.btnType.setTitle(getJobTypeText(jobType: job.jobType), for: .normal)
        return cell
    }
    
    func getJobTypeText(jobType:Int)-> String {
        if jobType == 1 {
            return "Full Time"
        } else if jobType == 2 {
            return "Part Time"
        } else {
            return "Temporary"
        }
    }
}

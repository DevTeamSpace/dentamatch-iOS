//
//  DMTrackVC+TableViewExtension.swift
//  DentaMatch
//
//  Created by Rajan Maheshwari on 30/01/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import Foundation
import SwiftyJSON

extension DMTrackVC:UITableViewDataSource,UITableViewDelegate {

    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 170
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let segmentControlOptions = SegmentControlOption(rawValue: self.segmentedControl.selectedSegmentIndex)!

        switch segmentControlOptions {
        case .saved:
            return savedJobs.count
            
        case .applied:
            return appliedJobs.count
            
        case .shortlisted:
            return shortListedJobs.count

        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == savedJobs.count - 2 {
            callLoadMore(type: 1)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let segmentControlOptions = SegmentControlOption(rawValue: self.segmentedControl.selectedSegmentIndex)!

        let cell = tableView.dequeueReusableCell(withIdentifier: "JobSearchResultCell") as! JobSearchResultCell
        let job = savedJobs[indexPath.row]
        cell.lblJobTitle.text = job.jobtitle
        cell.lblDocName.text = job.officeName
        cell.lblAddress.text = job.address
        cell.lblDistance.text = String(format: "%.2f", job.distance) + " miles"
        cell.btnType.setTitle(getJobTypeText(jobType: job.jobType), for: .normal)
        cell.btnFavourite.tag = indexPath.row
        
        switch segmentControlOptions {
            case .saved:
                if job.isSaved == 0 {
                    cell.btnFavourite.setTitleColor(UIColor.black, for: .normal)

                } else {
                    cell.btnFavourite.setTitleColor(Constants.Color.saveJobColor, for: .normal)
                }
                cell.btnFavourite.addTarget(self, action: #selector(addFavouriteJobButtonPressed), for: .touchUpInside)
            
            case .applied:
            print("")
            
            case .shortlisted:
            print("")
            
        }
        
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
    
    func addFavouriteJobButtonPressed(sender:UIButton) {
        let job = savedJobs[sender.tag]
        saveUnsaveJob(saveStatus: job.isSaved == 0 ? 1 : 0, jobId: job.jobId) { (response:JSON?, error:NSError?) in
            if let response = response {
                if response[Constants.ServerKey.status].boolValue {
                    //Save Unsave success
                    print(response)
                    job.isSaved = job.isSaved == 0 ? 1 : 0
                    
                    DispatchQueue.main.async {
                        self.savedJobsTableView.reloadData()
                    }
                }
            }
        }
    }
    
    func callLoadMore(type:Int) {
        if type == 1 {
            if loadingMoreSaveJobs == true {
                return
            }
            else{
                if self.totalSavedJobsFromServer > self.savedJobs.count {
                    setupLoadingMoreOnTable(tableView: self.savedJobsTableView)
                    loadingMoreSaveJobs = true
                    jobParams["type"] = "\(type)"
                    jobParams["page"] = "\(self.savedJobsPageNo)"
                    self.getJobList(params: jobParams)
                }
            }
        } else if type == 2 {
            if loadingMoreAppliedJobs == true {
                return
            }
            else{
                if self.totalAppliedJobsFromServer > self.appliedJobs.count {
                    setupLoadingMoreOnTable(tableView: self.appliedJobsTableView)
                    loadingMoreAppliedJobs = true
                    jobParams["type"] = "\(type)"
                    jobParams["page"] = "\(self.appliedJobsPageNo)"
                    self.getJobList(params: jobParams)
                }
            }
        } else {
            if loadingMoreShortListedJobs == true {
                return
            }
            else{
                if self.totalShortListedJobsFromServer > self.shortListedJobs.count {
                    setupLoadingMoreOnTable(tableView: self.shortListedJobsTableView)
                    loadingMoreShortListedJobs = true
                    jobParams["type"] = "\(type)"
                    jobParams["page"] = "\(self.shortListedJobsPageNo)"
                    self.getJobList(params: jobParams)
                }
            }
        }
    }
    
    func setupLoadingMoreOnTable(tableView:UITableView) {
        let footer = Bundle.main.loadNibNamed("LoadMoreView", owner: nil, options: nil)?[0] as? LoadMoreView
        footer!.frame = CGRect(x:0, y:0, width:tableView.frame.size.width,height:44)
        footer?.layoutIfNeeded();
        footer?.activityIndicator.startAnimating();
        tableView.tableFooterView = footer;
    }
}

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
        
        switch segmentControlOptions {
        case .saved:
            let job = savedJobs[indexPath.row]
            self.populateJobCellData(cell: cell, job: job)
            cell.handlePartTimeLabel(job: job)
            cell.btnFavourite.setImage(UIImage(named:"saveStar"), for: .normal)
            cell.btnFavourite.setTitle("", for: .normal)
            cell.btnFavourite.removeTarget(nil, action: nil, for: .allEvents)
            cell.btnFavourite.addTarget(self, action: #selector(removeFavouriteJobButtonPressed), for: .touchUpInside)
            cell.btnFavourite.tag = indexPath.row
            cell.btnFavourite.isHidden = false
            
        case .applied:
            let job = appliedJobs[indexPath.row]
            self.populateJobCellData(cell: cell, job: job)
            cell.handlePartTimeLabel(job: job)
            cell.btnFavourite.removeTarget(nil, action: nil, for: .allEvents)
            cell.btnFavourite.isHidden = true
            
        case .shortlisted:
            let job = shortListedJobs[indexPath.row]
            self.populateJobCellData(cell: cell, job: job)
            cell.handlePartTimeLabel(job: job)
            cell.btnFavourite.isHidden = false
            cell.btnFavourite.imageView?.image = nil
            cell.btnFavourite.tag = indexPath.row
            cell.btnFavourite.setTitle("n", for: .normal)
            cell.btnFavourite.removeTarget(nil, action: nil, for: .allEvents)
            cell.btnFavourite.addTarget(self, action: #selector(goToChatButton), for: .touchUpInside)

        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let segmentControlOptions = SegmentControlOption(rawValue: self.segmentedControl.selectedSegmentIndex)!
        
        switch segmentControlOptions {
        case .applied:
            let deleteAction = UITableViewRowAction(style: .normal, title: "Cancel Job", handler: { (action:UITableViewRowAction, indexPath:IndexPath) in
                let job = self.appliedJobs[indexPath.row]
                self.openCancelJob(job: job,fromApplied:true)
                self.appliedJobsTableView.setEditing(false, animated: true)
            })
            deleteAction.backgroundColor = Constants.Color.cancelJobDeleteColor
            return [ deleteAction]
            
        case .shortlisted:
                let deleteAction = UITableViewRowAction(style: .normal, title: "Cancel Job", handler: { (action:UITableViewRowAction, indexPath:IndexPath) in
                    let job = self.shortListedJobs[indexPath.row]
                    self.openCancelJob(job: job,fromApplied:false)
                    self.shortListedJobsTableView.setEditing(false, animated: true)
                })
                deleteAction.backgroundColor = Constants.Color.cancelJobDeleteColor
                return [ deleteAction]
            
        default:
                return nil
        }
    }
    
    func openCancelJob(job:Job,fromApplied:Bool) {
        let cancelJobVC = UIStoryboard.trackStoryBoard().instantiateViewController(type: DMCancelJobVC.self)!
        cancelJobVC.job = job
        cancelJobVC.fromApplied = fromApplied
        cancelJobVC.delegate = self
        self.navigationController?.pushViewController(cancelJobVC, animated: true)
    }
    
    func populateJobCellData(cell:JobSearchResultCell,job:Job) {
        cell.lblJobTitle.text = job.jobtitle
        cell.lblDocName.text = job.officeName
        cell.lblAddress.text = job.address
        cell.lblDistance.text = String(format: "%.2f", job.distance) + " miles"
        cell.btnType.setTitle(getJobTypeText(jobType: job.jobType), for: .normal)
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
    
    func removeFavouriteJobButtonPressed(sender:UIButton) {
        self.alertMessage(title: "Confirm your action", message: "Are you sure you want to unsave the job?", leftButtonText: "Cancel", rightButtonText: "Ok") { (isLeftButton:Bool) in
            if !isLeftButton {
                let job = self.savedJobs[sender.tag]
                self.saveUnsaveJob(saveStatus: 0, jobId: job.jobId) { (response:JSON?, error:NSError?) in
                    if let response = response {
                        if response[Constants.ServerKey.status].boolValue {
                            //Save Unsave success
                            print(response)
                            job.isSaved = 0
                            self.savedJobs.remove(at: sender.tag)
                            if self.savedJobs.count == 0 {
                                self.savedJobsPageNo = 1
                            }
                            self.totalSavedJobsFromServer -= 1
                            DispatchQueue.main.async {
                                self.savedJobsTableView.reloadData()
                            }
                        }
                    }
                }
            }
        }
    }
    
    func goToChatButton(sender:UIButton) {
        _ = self.shortListedJobs[sender.tag]
    }
    
    func callLoadMore(type:Int) {
        if type == 1 {
            if loadingMoreSavedJobs == true {
                return
            }
            else{
                if self.totalSavedJobsFromServer > self.savedJobs.count {
                    setupLoadingMoreOnTable(tableView: self.savedJobsTableView)
                    loadingMoreSavedJobs = true
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

extension DMTrackVC : CancelledJobDelegate {
    func cancelledJob(job: Job, fromApplied: Bool) {
        if fromApplied {
            self.appliedJobs.removeObject(object: job)
            self.appliedJobsTableView.reloadData()
            if self.appliedJobs.count == 0 {
                self.appliedJobsPageNo = 1
            }
        } else {
            self.shortListedJobs.removeObject(object: job)
            self.shortListedJobsTableView.reloadData()
            if self.shortListedJobs.count == 0 {
                self.shortListedJobsPageNo = 1
            }
        }
    }
}

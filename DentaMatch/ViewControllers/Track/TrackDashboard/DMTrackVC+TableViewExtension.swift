//
//  DMTrackVC+TableViewExtension.swift
//  DentaMatch
//
//  Created by Rajan Maheshwari on 30/01/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import Foundation
import SwiftyJSON

extension DMTrackVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
        return 170
    }

    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        let segmentControlOptions = SegmentControlOption(rawValue: segmentedControl.selectedSegmentIndex)!

        switch segmentControlOptions {
        case .saved:
            return savedJobs.count

        case .applied:
            return appliedJobs.count

        case .shortlisted:
            return shortListedJobs.count
        }
    }

    func tableView(_: UITableView, willDisplay _: UITableViewCell, forRowAt indexPath: IndexPath) {
        let segmentControlOptions = SegmentControlOption(rawValue: segmentedControl.selectedSegmentIndex)!
        switch segmentControlOptions {
        case .saved:
            if indexPath.row == savedJobs.count - 2 {
                callLoadMore(type: 1)
            }
        case .applied:
            if indexPath.row == appliedJobs.count - 2 {
                callLoadMore(type: 2)
            }
        case .shortlisted:
            if indexPath.row == shortListedJobs.count - 2 {
                callLoadMore(type: 3)
            }
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let segmentControlOptions = SegmentControlOption(rawValue: segmentedControl.selectedSegmentIndex)!

        let cell = tableView.dequeueReusableCell(withIdentifier: "JobSearchResultCell") as! JobSearchResultCell

        switch segmentControlOptions {
        case .saved:
            let job = savedJobs[indexPath.row]
            populateJobCellData(cell: cell, job: job)
            cell.handlePartTimeLabel(job: job)
            cell.btnFavourite.setImage(UIImage(named: "saveStar"), for: .normal)
            cell.btnFavourite.setTitle("", for: .normal)
            cell.btnFavourite.removeTarget(nil, action: nil, for: .allEvents)
            cell.btnFavourite.addTarget(self, action: #selector(removeFavouriteJobButtonPressed), for: .touchUpInside)
            cell.btnFavourite.tag = indexPath.row
            cell.btnFavourite.isHidden = false
            cell.selectionStyle = .none
            cell.configureWagesLabel(job: job, isSaved: true)
        case .applied:
            let job = appliedJobs[indexPath.row]
            populateJobCellData(cell: cell, job: job)
            cell.handlePartTimeLabel(job: job)
            cell.btnFavourite.removeTarget(nil, action: nil, for: .allEvents)
            cell.btnFavourite.isHidden = true
            cell.selectionStyle = .none
            cell.configureWagesLabel(job: job, isSaved: true)
        case .shortlisted:
            let job = shortListedJobs[indexPath.row]
            populateJobCellData(cell: cell, job: job)
            cell.handlePartTimeLabel(job: job)
            cell.btnFavourite.isHidden = false
            cell.btnFavourite.imageView?.image = nil
            cell.btnFavourite.tag = indexPath.row
            cell.btnFavourite.setTitle("n", for: .normal)
            cell.btnFavourite.removeTarget(nil, action: nil, for: .allEvents)
            cell.btnFavourite.addTarget(self, action: #selector(goToChatButton), for: .touchUpInside)
            cell.selectionStyle = .none
            cell.configureWagesLabel(job: job, isSaved: true)
        }
        
        return cell
    }

    func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        openJobDetails(indexPath: indexPath)
    }

    func tableView(_: UITableView, canEditRowAt _: IndexPath) -> Bool {
        let segmentControlOptions = SegmentControlOption(rawValue: segmentedControl.selectedSegmentIndex)!

        switch segmentControlOptions {
        case .saved:
            return false
        default:
            return true
        }
    }

    func tableView(_: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let segmentControlOptions = SegmentControlOption(rawValue: segmentedControl.selectedSegmentIndex)!

        switch segmentControlOptions {
        case .applied:
            let deleteAction = UITableViewRowAction(style: .normal, title: "Cancel Job", handler: { (_: UITableViewRowAction, indexPath: IndexPath) in
                let job = self.appliedJobs[indexPath.row]
                self.openCancelJob(job: job, fromApplied: true)
                self.appliedJobsTableView.setEditing(false, animated: true)
            })
            deleteAction.backgroundColor = Constants.Color.cancelJobDeleteColor
            return [deleteAction]

        case .shortlisted:
            let deleteAction = UITableViewRowAction(style: .normal, title: "Cancel Job", handler: { (_: UITableViewRowAction, indexPath: IndexPath) in
                let job = self.shortListedJobs[indexPath.row]
                self.openCancelJob(job: job, fromApplied: false)
                self.shortListedJobsTableView.setEditing(false, animated: true)
            })
            deleteAction.backgroundColor = Constants.Color.cancelJobDeleteColor
            return [deleteAction]

        default:
            return nil
        }
    }

    func openCancelJob(job: Job, fromApplied: Bool) {
        let cancelJobVC = UIStoryboard.trackStoryBoard().instantiateViewController(type: DMCancelJobVC.self)!
        cancelJobVC.job = job
        cancelJobVC.fromApplied = fromApplied
        cancelJobVC.hidesBottomBarWhenPushed = true
        cancelJobVC.delegate = self
        navigationController?.pushViewController(cancelJobVC, animated: true)
    }

    func populateJobCellData(cell: JobSearchResultCell, job: Job) {
        cell.lblJobTitle.text = job.jobtitle
        cell.lblDocName.text = job.officeName
        cell.lblAddress.text = job.address
        cell.lblDistance.text = String(format: "%.2f", job.percentSkillsMatch) + "%"
        cell.btnType.setTitle(getJobTypeText(jobType: job.jobType), for: .normal)
    }

    func getJobTypeText(jobType: Int) -> String {
        if jobType == 1 {
            return "Full Time"
        } else if jobType == 2 {
            return "Part Time"
        } else {
            return "Temporary"
        }
    }

    @objc func removeFavouriteJobButtonPressed(sender: UIButton) {
        alertMessage(title: "Confirm your action", message: "Are you sure you want to unsave the job?", leftButtonText: "Cancel", rightButtonText: "Ok") { (isLeftButton: Bool) in
            if !isLeftButton {
                let job = self.savedJobs[sender.tag]
                self.saveUnsaveJob(saveStatus: 0, jobId: job.jobId) { (response: JSON?, _: NSError?) in
                    if let response = response {
                        if response[Constants.ServerKey.status].boolValue {
                            // Save Unsave success
                            // debugPrint(response)
                            job.isSaved = 0
                            self.savedJobs.remove(at: sender.tag)
                            if self.savedJobs.count == 0 {
                                self.savedJobsPageNo = 1
                                self.placeHolderEmptyJobsView?.isHidden = false
                                self.placeHolderEmptyJobsView?.placeHolderMessageLabel.text = "You don’t have any saved jobs"
                            }
                            self.totalSavedJobsFromServer -= 1
                            DispatchQueue.main.async {
                                self.savedJobsTableView.reloadData()
                            }
                            
                            NotificationCenter.default.post(name: .jobSavedUnsaved, object: job, userInfo: nil)
                        }
                    }
                }
            }
        }
    }

    @objc func goToChatButton(sender: UIButton) {
        _ = shortListedJobs[sender.tag]
    }

    func callLoadMore(type: Int) {
        if type == 1 {
            if loadingMoreSavedJobs == true {
                return
            } else {
                if totalSavedJobsFromServer > savedJobs.count {
                    setupLoadingMoreOnTable(tableView: savedJobsTableView)
                    loadingMoreSavedJobs = true
                    jobParams["type"] = "\(type)"
                    jobParams["page"] = "\(savedJobsPageNo)"
                    getJobList(params: jobParams)
                }
            }
        } else if type == 2 {
            if loadingMoreAppliedJobs == true {
                return
            } else {
                if totalAppliedJobsFromServer > appliedJobs.count {
                    setupLoadingMoreOnTable(tableView: appliedJobsTableView)
                    loadingMoreAppliedJobs = true
                    jobParams["type"] = "\(type)"
                    jobParams["page"] = "\(appliedJobsPageNo)"
                    getJobList(params: jobParams)
                }
            }
        } else {
            if loadingMoreShortListedJobs == true {
                return
            } else {
                if totalShortListedJobsFromServer > shortListedJobs.count {
                    setupLoadingMoreOnTable(tableView: shortListedJobsTableView)
                    loadingMoreShortListedJobs = true
                    jobParams["type"] = "\(type)"
                    jobParams["page"] = "\(shortListedJobsPageNo)"
                    getJobList(params: jobParams)
                }
            }
        }
    }

    func setupLoadingMoreOnTable(tableView: UITableView) {
        let footer = Bundle.main.loadNibNamed("LoadMoreView", owner: nil, options: nil)?[0] as? LoadMoreView
        footer!.frame = CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 44)
        footer?.layoutIfNeeded()
        footer?.activityIndicator.startAnimating()
        tableView.tableFooterView = footer
    }
    
}

extension DMTrackVC: CancelledJobDelegate {
    func cancelledJob(job: Job, fromApplied: Bool) {
        if fromApplied {
            appliedJobs.removeObject(object: job)
            totalAppliedJobsFromServer -= 1
            appliedJobsTableView.reloadData()
            if appliedJobs.count == 0 {
                appliedJobsPageNo = 1
                placeHolderEmptyJobsView?.isHidden = false
                placeHolderEmptyJobsView?.placeHolderMessageLabel.text = "You don’t have any applied jobs"
            } else {
                placeHolderEmptyJobsView?.isHidden = true
            }
        } else {
            shortListedJobs.removeObject(object: job)
            totalShortListedJobsFromServer -= 1
            shortListedJobsTableView.reloadData()
            if shortListedJobs.count == 0 {
                shortListedJobsPageNo = 1
                placeHolderEmptyJobsView?.isHidden = false
                placeHolderEmptyJobsView?.placeHolderMessageLabel.text = "You don’t have any interviewing jobs"
            } else {
                placeHolderEmptyJobsView?.isHidden = true
            }
        }
    }
}

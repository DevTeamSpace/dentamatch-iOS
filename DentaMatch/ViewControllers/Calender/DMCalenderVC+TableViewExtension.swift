//
//  DMCalenderVC+TableViewExtension.swift
//  DentaMatch
//
//  Created by Sanjay Kumar Yadav on 30/01/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import Foundation

extension DMCalenderVC:UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 45
        case 1:
            return 170
        default:
            break
        }
        return 0

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        switch section {
        case 0:
            return 1
        case 1:
            return selectedDayList.count
        default:
            break
        }
        return 0
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        switch indexPath.section {
        case 0:
            return false
        case 1:
            return true
        default:
            break
        }
        return true

    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SectionHeadingTableCell") as? SectionHeadingTableCell
            cell?.headingLabel.text = "BOOKED JOBS"
            cell?.selectionStyle = .none
            return cell!
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "JobSearchResultCell") as? JobSearchResultCell
            let job = selectedDayList[indexPath.row]
            
            cell?.setCellData(job: job)
            cell?.handlePartTimeLabel(job: job)

            cell?.lblJobTitle.text = job.jobtitle
            cell?.lblDocName.text = job.officeName
            cell?.lblAddress.text = job.address
            cell?.lblDistance.isHidden = true
            cell?.selectionStyle = .none

//            cell?.lblDistance.text = String(format: "%.2f", job.distance) + " miles"
            cell?.btnType.setTitle(getJobTypeText(jobType: job.jobType), for: .normal)
            cell?.btnFavourite.isHidden = true

            return cell!
        }
    }
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        switch indexPath.section {
        case 0:
            break
        case 1:
            let deleteAction = UITableViewRowAction(style: .normal, title: "Cancel Job", handler: { (action:UITableViewRowAction, indexPath:IndexPath) in
                let job = self.selectedDayList[indexPath.row]
//                self.removeJobButtonPressed(job: job)
                self.openCancelJob(job: job,fromApplied:false)
                self.bookedJobsTableView.setEditing(false, animated: true)
            })
            deleteAction.backgroundColor = Constants.Color.cancelJobDeleteColor
            return [ deleteAction]
            
        default:
            return nil
        }
        return nil

    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let jobDetailVC = UIStoryboard.jobSearchStoryBoard().instantiateViewController(type: DMJobDetailVC.self)!
        jobDetailVC.fromCalender = false
        jobDetailVC.job = selectedDayList[indexPath.row]
        jobDetailVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(jobDetailVC, animated: true)
    }
    
    
    func openCancelJob(job:Job,fromApplied:Bool) {
        let cancelJobVC = UIStoryboard.trackStoryBoard().instantiateViewController(type: DMCancelJobVC.self)!
        cancelJobVC.job = job
        cancelJobVC.fromApplied = fromApplied
        cancelJobVC.delegate = self
        self.navigationController?.pushViewController(cancelJobVC, animated: true)
    }

//    func removeJobButtonPressed(job:Job) {
//        self.alertMessage(title: "Confirm your action", message: "Are you sure you want to cancel the job?", leftButtonText: "Cancel", rightButtonText: "Ok") { (isLeftButton:Bool) in
//            if !isLeftButton {
////                let job = self.selectedDayList[sender.tag]
////                self.saveUnsaveJob(saveStatus: 0, jobId: job.jobId) { (response:JSON?, error:NSError?) in
////                    if let response = response {
////                        if response[Constants.ServerKey.status].boolValue {
////                            //Save Unsave success
////                            print(response)
////                            DispatchQueue.main.async {
////                                self.savedJobsTableView.reloadData()
////                            }
////                        }
////                    }
////                }
//            }
//        }
//    }

    
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

extension DMCalenderVC : CancelledJobDelegate {
    func cancelledJob(job: Job, fromApplied: Bool) {
        hiredList.removeObject(object: job)
        selectedDayList.removeObject(object: job)
        calendar?.reloadData()
        bookedJobsTableView.reloadData()
        let fullTime  = self.hiredList.filter({ (job) -> Bool in
            job.jobType == 1
        })
        if fullTime.count > 0 {
            self.fulltimeJobIndicatorView.isHidden = false
        }else{
            self.fulltimeJobIndicatorView.isHidden = true
        }

    }
}

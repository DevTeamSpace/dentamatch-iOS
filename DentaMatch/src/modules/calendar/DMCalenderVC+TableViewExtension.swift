//
//  DMCalenderVC+TableViewExtension.swift
//  DentaMatch
//
//  Created by Sanjay Kumar Yadav on 30/01/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import Foundation

extension DMCalenderVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in _: UITableView) -> Int {
        return 1
    }

//    func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
//        return 225
//    }
    
    func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_: UITableView, estimatedHeightForRowAt _: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_: UITableView, heightForHeaderInSection _: Int) -> CGFloat {
        return 45
    }

    func tableView(_: UITableView, viewForHeaderInSection _: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: Utilities.ScreenSize.SCREEN_WIDTH, height: 46))
        headerView.backgroundColor = UIColor.color(withHexCode: "f9f9f9")

        let label = UILabel(frame: CGRect(x: 20, y: 16, width: Utilities.ScreenSize.SCREEN_WIDTH, height: 20))
        label.text = "BOOKED JOBS (Swipe to cancel job)"
        label.textColor = Constants.Color.textFieldTextColor

        label.font = UIFont.fontMedium(fontSize: 14.0)
        headerView.addSubview(label)

        let bottomLineView = UIView(frame: CGRect(x: 0, y: 44, width: Utilities.ScreenSize.SCREEN_WIDTH, height: 1))
        bottomLineView.backgroundColor = Constants.Color.textFieldBorderColor
        headerView.addSubview(bottomLineView)

        return headerView
    }

    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return selectedDayList.count
    }

    func tableView(_: UITableView, canEditRowAt _: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
        cell?.jobTitleLeftConstraint.constant = 20
        cell?.contentView.layoutIfNeeded()
        return cell!
    }

    func tableView(_: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .normal, title: "Cancel Job", handler: { (_: UITableViewRowAction, indexPath: IndexPath) in
            let job = self.selectedDayList[indexPath.row]

            self.openCancelJob(job: job, fromApplied: false)
            self.bookedJobsTableView.setEditing(false, animated: true)
        })
        let job = selectedDayList[indexPath.row]
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let currentDate = formatter.date(from: job.currentDate) ?? Date()
        let tempjobDate = formatter.date(from: job.tempjobDate) ?? Date()
        if currentDate.timeIntervalSince(tempjobDate) >= 0 {
            return [UITableViewRowAction]()
        }

        deleteAction.backgroundColor = Constants.Color.cancelJobDeleteColor
        return [deleteAction]
    }

    func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        moduleOutput?.showJobDetail(job: selectedDayList[indexPath.row])
    }

    func openCancelJob(job: Job, fromApplied: Bool) {
        moduleOutput?.showCancelJob(job: job, fromApplied: fromApplied, delegate: self)
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
}

extension DMCalenderVC: CancelledJobDelegate {
    func cancelledJob(job: Job, fromApplied _: Bool) {
        hiredList.removeObject(object: job)
        selectedDayList.removeObject(object: job)
        calendar?.reloadData()
        bookedJobsTableView.reloadData()
        let fullTime = hiredList.filter({ (job) -> Bool in
            job.jobType == 1
        })
        if fullTime.count > 0 {
            fulltimeJobIndicatorView.isHidden = false
        } else {
            fulltimeJobIndicatorView.isHidden = true
        }
    }
}

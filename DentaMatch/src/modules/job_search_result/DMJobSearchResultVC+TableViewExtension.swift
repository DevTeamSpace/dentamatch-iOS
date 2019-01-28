//
//  DMJobSearchResult+TableViewExtension.swift
//  DentaMatch
//
//  Created by Shailesh Tyagi on 30/01/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import Foundation
import SwiftyJSON

extension DMJobSearchResultVC: UITableViewDataSource, UITableViewDelegate, JobSearchResultCellDelegate {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return jobs.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "JobSearchResultCell") as! JobSearchResultCell
        cell.selectionStyle = .none
        let objJob = jobs[indexPath.row]
        cell.index = indexPath.row
        cell.delegate = self
        cell.setCellData(job: objJob)
        return cell
    }

    func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_: UITableView, estimatedHeightForRowAt _: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let jobDetailVC = DMJobDetailInitializer.initialize() as? DMJobDetailVC else { return }
        jobDetailVC.job = jobs[indexPath.row]
        jobDetailVC.hidesBottomBarWhenPushed = true
        jobDetailVC.delegate = self
        navigationController?.pushViewController(jobDetailVC, animated: true)
    }

    func tableView(_: UITableView, willDisplay _: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == jobs.count - 1 {
            callLoadMore()
        }
    }

    // MARK: - Call Load More

    func callLoadMore() {
        if loadingMoreJobs == true {
            return
        } else {
            if totalJobsFromServer > jobs.count {
                setupLoadingMoreOnTable(tableView: tblJobSearchResult)
                loadingMoreJobs = true
                searchParams[Constants.JobDetailKey.page] = "\(jobsPageNo)"
                fetchSearchResultAPI(params: searchParams)
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

    // MARK: - JobSearchResultCellDelegate Method

    func saveOrUnsaveJob(index: Int) {
        let job = jobs[index]
        var status: Int!
        if job.isSaved == 1 {
            status = 0
        } else {
            status = 1
        }
        saveUnsaveJob(saveStatus: status, jobId: job.jobId) { (response: JSON?, _: NSError?) in
            if let response = response {
                if response[Constants.ServerKey.status].boolValue {
                    // Save Unsave success
                    job.isSaved = status
                    self.jobs.remove(at: index)
                    self.jobs.insert(job, at: index)
                    DispatchQueue.main.async {
                        self.tblJobSearchResult.reloadRows(at: [IndexPath(row: index, section: 0)], with: .none)
                    }
                    NotificationCenter.default.post(name: .refreshSavedJobs, object: nil, userInfo: nil)
                }
            }
        }
    }
}

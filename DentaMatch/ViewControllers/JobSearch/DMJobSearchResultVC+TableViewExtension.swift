//
//  DMJobSearchResult+TableViewExtension.swift
//  DentaMatch
//
//  Created by Shailesh Tyagi on 30/01/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import Foundation
import SwiftyJSON

extension DMJobSearchResultVC : UITableViewDataSource, UITableViewDelegate, JobSearchResultCellDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.jobs.count
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let jobDetailVC = UIStoryboard.jobSearchStoryBoard().instantiateViewController(type: DMJobDetailVC.self)!
        self.navigationController?.pushViewController(jobDetailVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath)
    {
        if indexPath.row < self.jobs.count - 3 {
            self.callLoadMore()
        }
    }
    
    //MARK:- Call Load More
    func callLoadMore() {
        if loadingMoreJobs == true{
            return
        }
        else {
            if self.totalJobsFromServer > self.jobs.count {
                setupLoadingMoreOnTable(tableView: self.tblJobSearchResult)
                loadingMoreJobs = true
                searchParams[Constants.JobDetailKey.page] = "\(self.jobsPageNo)"
                self.fetchSearchResultAPI(params: searchParams)
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
    
    //MARK:- JobSearchResultCellDelegate Method
    
    func saveOrUnsaveJob(index: Int) {
        let job = self.jobs[index]
        var status : Int!
        if job.isSaved == 1 {
            status = 0
        }
        else {
            status = 1
        }
        self.saveUnsaveJob(saveStatus: status, jobId: job.jobId) { (response:JSON?, error:NSError?) in
            if let response = response {
                if response[Constants.ServerKey.status].boolValue {
                    //Save Unsave success
                    job.isSaved = status
                    self.jobs.remove(at: index)
                    self.jobs.insert(job, at: index)
                    DispatchQueue.main.async {
                        self.tblJobSearchResult.reloadRows(at: [IndexPath(row: index, section: 0)], with: .none)
                    }
                }
            }
        }
    }
}


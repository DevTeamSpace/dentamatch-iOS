//
//  DMTrackVC.swift
//  DentaMatch
//
//  Created by Sanjay Kumar Yadav on 22/01/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

class DMTrackVC: DMBaseVC {

    enum SegmentControlOption:Int {
        case saved
        case applied
        case shortlisted
    }
    
    var loadingMoreSavedJobs = false
    var loadingMoreAppliedJobs = false
    var loadingMoreShortListedJobs = false

    var savedJobs = [Job]()
    var appliedJobs = [Job]()
    var shortListedJobs = [Job]()
    var savedJobsPageNo = 1
    var appliedJobsPageNo = 1
    var shortListedJobsPageNo = 1
    var totalSavedJobsFromServer = 0
    var totalAppliedJobsFromServer = 0
    var totalShortListedJobsFromServer = 0
    
    var pullToRefreshSavedJobs = UIRefreshControl()
    var pullToRefreshAppliedJobs = UIRefreshControl()
    var pullToRefreshShortListedJobs = UIRefreshControl()

    var jobParams = [String:String]()

    @IBOutlet weak var savedJobsTableView: UITableView!
    @IBOutlet weak var appliedJobsTableView: UITableView!
    
    @IBOutlet weak var shortListedJobsTableView: UITableView!
    @IBOutlet weak var segmentedControl: CustomSegmentControl!
    override func viewDidLoad() {
        super.viewDidLoad()
        jobParams = [
            "type":"1",
            "page":"1",
            "lat":"\(UserManager.shared().activeUser.latitude!)",
            "lng":"\(UserManager.shared().activeUser.longitude!)"
        ]
        
        self.getJobList(params: jobParams)
        setup()
        // Do any additional setup after loading the view.
    }
    
    func setup() {
        self.savedJobsTableView.tag = 0
        self.appliedJobsTableView.tag = 1
        self.shortListedJobsTableView.tag = 2

        pullToRefreshSavedJobs.addTarget(self, action: #selector(pullToRefreshForSavedJobs), for: .valueChanged)
        self.savedJobsTableView.addSubview(pullToRefreshSavedJobs)

        savedJobsTableView.isHidden = false
        appliedJobsTableView.isHidden = true
        shortListedJobsTableView.isHidden = true
        self.savedJobsTableView.register(UINib(nibName: "JobSearchResultCell", bundle: nil), forCellReuseIdentifier: "JobSearchResultCell")
        self.appliedJobsTableView.register(UINib(nibName: "JobSearchResultCell", bundle: nil), forCellReuseIdentifier: "JobSearchResultCell")
        self.shortListedJobsTableView.register(UINib(nibName: "JobSearchResultCell", bundle: nil), forCellReuseIdentifier: "JobSearchResultCell")

    }
    
    func pullToRefreshForSavedJobs() {
        self.savedJobsPageNo = 1
        jobParams["type"] = "1"
        jobParams["page"] = "1"
        self.getJobList(params: jobParams)
        pullToRefreshSavedJobs.endRefreshing()
    }
    
    func pullToRefreshForAppliedJobs() {
        self.savedJobsPageNo = 1
        jobParams["type"] = "2"
        jobParams["page"] = "1"
        self.getJobList(params: jobParams)
        pullToRefreshAppliedJobs.endRefreshing()
    }

    func pullToRefreshForShortListedJobs() {
        self.savedJobsPageNo = 1
        jobParams["type"] = "3"
        jobParams["page"] = "1"
        self.getJobList(params: jobParams)
        pullToRefreshShortListedJobs.endRefreshing()
    }

    @IBAction func segmentControlValueChanged(_ sender: UISegmentedControl) {
        let segmentControlOptions = SegmentControlOption(rawValue: sender.selectedSegmentIndex)!
        
        switch segmentControlOptions {
            
        case .saved:
            if self.savedJobsPageNo == 1 {
                jobParams["type"] = "2"
                jobParams["page"] = "1"
                self.getJobList(params: jobParams)
            }
            savedJobsTableView.isHidden = false
            appliedJobsTableView.isHidden = true
            shortListedJobsTableView.isHidden = true
        case .applied:
            if appliedJobsPageNo == 1 {
                jobParams["type"] = "2"
                jobParams["page"] = "1"
                self.getJobList(params: jobParams)
            }
            savedJobsTableView.isHidden = true
            appliedJobsTableView.isHidden = false
            shortListedJobsTableView.isHidden = true
        case .shortlisted:
            if shortListedJobsPageNo == 1 {
                jobParams["type"] = "3"
                jobParams["page"] = "1"
                self.getJobList(params: jobParams)
            }
            savedJobsTableView.isHidden = true
            appliedJobsTableView.isHidden = true
            shortListedJobsTableView.isHidden = false
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

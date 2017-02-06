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
    var placeHolderEmptyJobsView:PlaceHolderJobsView?

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
        setup()
        self.getJobList(params: jobParams)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let selectedIndex = self.savedJobsTableView.indexPathForSelectedRow {
            self.savedJobsTableView.deselectRow(at: selectedIndex, animated: true)
        }
        
        if let selectedIndex = self.appliedJobsTableView.indexPathForSelectedRow {
            self.appliedJobsTableView.deselectRow(at: selectedIndex, animated: true)
        }
        
        if let selectedIndex = self.shortListedJobsTableView.indexPathForSelectedRow {
            self.shortListedJobsTableView.deselectRow(at: selectedIndex, animated: true)
        }
    }
    
    func setup() {
        self.savedJobsTableView.tag = 0
        self.appliedJobsTableView.tag = 1
        self.shortListedJobsTableView.tag = 2
        self.savedJobsTableView.tableFooterView = UIView()
        self.appliedJobsTableView.tableFooterView = UIView()
        self.shortListedJobsTableView.tableFooterView = UIView()

        placeHolderEmptyJobsView = PlaceHolderJobsView.loadPlaceHolderJobsView()
        placeHolderEmptyJobsView?.frame = CGRect(x: 0, y: 0, width: 300, height: 500)
        placeHolderEmptyJobsView?.center = self.view.center
        self.view.addSubview(placeHolderEmptyJobsView!)
        placeHolderEmptyJobsView?.placeHolderMessageLabel.text = "You don’t have any saved jobs"
        
        self.view.bringSubview(toFront: self.savedJobsTableView)
        self.view.bringSubview(toFront: self.appliedJobsTableView)
        self.view.bringSubview(toFront: self.shortListedJobsTableView)

        
        pullToRefreshSavedJobs.addTarget(self, action: #selector(pullToRefreshForSavedJobs), for: .valueChanged)
        self.savedJobsTableView.addSubview(pullToRefreshSavedJobs)
        
        pullToRefreshAppliedJobs.addTarget(self, action: #selector(pullToRefreshForAppliedJobs), for: .valueChanged)
        self.appliedJobsTableView.addSubview(pullToRefreshAppliedJobs)

        pullToRefreshShortListedJobs.addTarget(self, action: #selector(pullToRefreshForShortListedJobs), for: .valueChanged)
        self.shortListedJobsTableView.addSubview(pullToRefreshShortListedJobs)


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
        jobParams["lat"] = UserManager.shared().activeUser.latitude
        jobParams["lng"] = UserManager.shared().activeUser.longitude
        self.getJobList(params: jobParams)
        pullToRefreshSavedJobs.endRefreshing()
    }
    
    
    func pullToRefreshForAppliedJobs() {
        self.appliedJobsPageNo = 1
        jobParams["type"] = "2"
        jobParams["page"] = "1"
        jobParams["lat"] = UserManager.shared().activeUser.latitude
        jobParams["lng"] = UserManager.shared().activeUser.longitude
        self.getJobList(params: jobParams)
        pullToRefreshAppliedJobs.endRefreshing()
    }

    func pullToRefreshForShortListedJobs() {
        self.shortListedJobsPageNo = 1
        jobParams["type"] = "3"
        jobParams["page"] = "1"
        jobParams["lat"] = UserManager.shared().activeUser.latitude
        jobParams["lng"] = UserManager.shared().activeUser.longitude
        self.getJobList(params: jobParams)
        pullToRefreshShortListedJobs.endRefreshing()
    }

    @IBAction func segmentControlValueChanged(_ sender: UISegmentedControl) {
        let segmentControlOptions = SegmentControlOption(rawValue: sender.selectedSegmentIndex)!
        
        switch segmentControlOptions {
            
        case .saved:
            savedJobsTableView.isHidden = false
            appliedJobsTableView.isHidden = true
            shortListedJobsTableView.isHidden = true
            placeHolderEmptyJobsView?.placeHolderMessageLabel.text = "You don’t have any saved jobs"

            self.placeHolderEmptyJobsView?.isHidden = savedJobs.count == 0 ? false:true

            if self.savedJobsPageNo == 1 {
                jobParams["type"] = "1"
                jobParams["page"] = "1"
                self.getJobList(params: jobParams)
            }
        case .applied:
            savedJobsTableView.isHidden = true
            shortListedJobsTableView.isHidden = true
            appliedJobsTableView.isHidden = false
            placeHolderEmptyJobsView?.placeHolderMessageLabel.text = "You don’t have any applied jobs"
            self.placeHolderEmptyJobsView?.isHidden = appliedJobs.count == 0 ? false:true
            if appliedJobsPageNo == 1 {
                jobParams["type"] = "2"
                jobParams["page"] = "1"
                self.getJobList(params: jobParams)
            }
        case .shortlisted:
            savedJobsTableView.isHidden = true
            appliedJobsTableView.isHidden = true
            shortListedJobsTableView.isHidden = false
            placeHolderEmptyJobsView?.placeHolderMessageLabel.text = "You don’t have any shortlisted jobs"
            self.placeHolderEmptyJobsView?.isHidden = shortListedJobs.count == 0 ? false:true
            if shortListedJobsPageNo == 1 {
                jobParams["type"] = "3"
                jobParams["page"] = "1"
                self.getJobList(params: jobParams)
            }
        }
    }
}

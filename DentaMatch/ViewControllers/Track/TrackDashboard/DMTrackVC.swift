//
//  DMTrackVC.swift
//  DentaMatch
//
//  Created by Sanjay Kumar Yadav on 22/01/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

class DMTrackVC: DMBaseVC {
    enum SegmentControlOption: Int {
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

    var isFromJobDetailApplied = false
    var lat = ""
    var long = ""

    var jobParams = [String: String]()
    var placeHolderEmptyJobsView: PlaceHolderJobsView?

    @IBOutlet var savedJobsTableView: UITableView!
    @IBOutlet var appliedJobsTableView: UITableView!

    @IBOutlet var shortListedJobsTableView: UITableView!
    @IBOutlet var segmentedControl: CustomSegmentControl!
    //var notificationLabel: UILabel?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let params = UserDefaultsManager.sharedInstance.loadSearchParameter() {
            lat = params[Constants.JobDetailKey.lat] as? String ?? "0"
            long = params[Constants.JobDetailKey.lng] as? String ?? "0"
        }

        jobParams = [
            "type": "1",
            "page": "1",
            "lat": lat,
            "lng": long,
        ]
        setup()
        getJobList(params: jobParams)
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       //self.setNotificationLabelText(count: AppDelegate.delegate().badgeCount())
    }

    func setup() {
        savedJobsTableView.tag = 0
        appliedJobsTableView.tag = 1
        shortListedJobsTableView.tag = 2
        savedJobsTableView.tableFooterView = UIView()
        appliedJobsTableView.tableFooterView = UIView()
        shortListedJobsTableView.tableFooterView = UIView()

        placeHolderEmptyJobsView = PlaceHolderJobsView.loadPlaceHolderJobsView()
        placeHolderEmptyJobsView?.frame = CGRect(x: 0, y: 0, width: 300, height: 200)
        placeHolderEmptyJobsView?.center = view.center
        placeHolderEmptyJobsView?.backgroundColor = UIColor.clear
        view.addSubview(placeHolderEmptyJobsView!)
        placeHolderEmptyJobsView?.placeHolderMessageLabel.text = "You don’t have any saved jobs"

        view.bringSubview(toFront: savedJobsTableView)
        view.bringSubview(toFront: appliedJobsTableView)
        view.bringSubview(toFront: shortListedJobsTableView)

        pullToRefreshSavedJobs.addTarget(self, action: #selector(pullToRefreshForSavedJobs), for: .valueChanged)
        savedJobsTableView.addSubview(pullToRefreshSavedJobs)

        pullToRefreshAppliedJobs.addTarget(self, action: #selector(pullToRefreshForAppliedJobs), for: .valueChanged)
        appliedJobsTableView.addSubview(pullToRefreshAppliedJobs)

        pullToRefreshShortListedJobs.addTarget(self, action: #selector(pullToRefreshForShortListedJobs), for: .valueChanged)
        shortListedJobsTableView.addSubview(pullToRefreshShortListedJobs)

        savedJobsTableView.isHidden = false
        appliedJobsTableView.isHidden = true
        shortListedJobsTableView.isHidden = true
        savedJobsTableView.register(UINib(nibName: "JobSearchResultCell", bundle: nil), forCellReuseIdentifier: "JobSearchResultCell")
        appliedJobsTableView.register(UINib(nibName: "JobSearchResultCell", bundle: nil), forCellReuseIdentifier: "JobSearchResultCell")
        shortListedJobsTableView.register(UINib(nibName: "JobSearchResultCell", bundle: nil), forCellReuseIdentifier: "JobSearchResultCell")
        
         //navigationItem.leftBarButtonItem = customLeftBarButton()
    }

    @objc func pullToRefreshForSavedJobs() {
        savedJobsPageNo = 1
        jobParams["type"] = "1"
        jobParams["page"] = "1"
        jobParams["lat"] = lat
        jobParams["lng"] = long
        savedJobsTableView.tableFooterView = nil
        loadingMoreSavedJobs = false
        getJobList(params: jobParams)
        pullToRefreshSavedJobs.endRefreshing()
    }

    @objc func pullToRefreshForAppliedJobs() {
        appliedJobsPageNo = 1
        jobParams["type"] = "2"
        jobParams["page"] = "1"
        jobParams["lat"] = lat
        jobParams["lng"] = long
        appliedJobsTableView.tableFooterView = nil
        loadingMoreAppliedJobs = false
        getJobList(params: jobParams)
        pullToRefreshAppliedJobs.endRefreshing()
    }

    @objc func pullToRefreshForShortListedJobs() {
        shortListedJobsPageNo = 1
        jobParams["type"] = "3"
        jobParams["page"] = "1"
        jobParams["lat"] = lat
        jobParams["lng"] = long
        shortListedJobsTableView.tableFooterView = nil
        loadingMoreShortListedJobs = false
        getJobList(params: jobParams)
        pullToRefreshShortListedJobs.endRefreshing()
    }

    func openJobDetails(indexPath: IndexPath) {
        let segmentControlOptions = SegmentControlOption(rawValue: segmentedControl.selectedSegmentIndex)!

        let jobDetailVC = UIStoryboard.jobSearchStoryBoard().instantiateViewController(type: DMJobDetailVC.self)!
        jobDetailVC.fromTrack = true
        switch segmentControlOptions {
        case .saved:
            jobDetailVC.job = savedJobs[indexPath.row]

        case .applied:
            jobDetailVC.job = appliedJobs[indexPath.row]

        case .shortlisted:
            jobDetailVC.job = shortListedJobs[indexPath.row]
        }
        jobDetailVC.hidesBottomBarWhenPushed = true
        jobDetailVC.delegate = self
        self.navigationController?.pushViewController(jobDetailVC, animated: true)
    }

    @IBAction func segmentControlValueChanged(_ sender: UISegmentedControl) {
        let segmentControlOptions = SegmentControlOption(rawValue: sender.selectedSegmentIndex)!

        switch segmentControlOptions {
        case .saved:
            savedJobsTableView.isHidden = false
            appliedJobsTableView.isHidden = true
            shortListedJobsTableView.isHidden = true
            savedJobsTableView.dataSource = self
            appliedJobsTableView.dataSource = nil
            shortListedJobsTableView.dataSource = nil

            placeHolderEmptyJobsView?.placeHolderMessageLabel.text = "You don’t have any saved jobs"

            placeHolderEmptyJobsView?.isHidden = savedJobs.count == 0 ? false : true

            if savedJobsPageNo == 1 {
                jobParams["type"] = "1"
                jobParams["page"] = "1"
                getJobList(params: jobParams)
            } else {
                savedJobsTableView.reloadData()
            }
        case .applied:
            savedJobsTableView.isHidden = true
            shortListedJobsTableView.isHidden = true
            appliedJobsTableView.isHidden = false
            savedJobsTableView.dataSource = nil
            appliedJobsTableView.dataSource = self
            shortListedJobsTableView.dataSource = nil

            placeHolderEmptyJobsView?.placeHolderMessageLabel.text = "You don’t have any applied jobs"
            placeHolderEmptyJobsView?.isHidden = appliedJobs.count == 0 ? false : true
            if appliedJobsPageNo == 1 {
                jobParams["type"] = "2"
                jobParams["page"] = "1"
                getJobList(params: jobParams)
            } else {
                appliedJobsTableView.reloadData()
            }
        case .shortlisted:
            savedJobsTableView.isHidden = true
            appliedJobsTableView.isHidden = true
            shortListedJobsTableView.isHidden = false
            savedJobsTableView.dataSource = nil
            appliedJobsTableView.dataSource = nil
            shortListedJobsTableView.dataSource = self

            placeHolderEmptyJobsView?.placeHolderMessageLabel.text = "You don’t have any interviewing jobs"
            placeHolderEmptyJobsView?.isHidden = shortListedJobs.count == 0 ? false : true
            if shortListedJobsPageNo == 1 {
                jobParams["type"] = "3"
                jobParams["page"] = "1"
                getJobList(params: jobParams)
            } else {
                shortListedJobsTableView.reloadData()
            }
        }
    }
    
    /*func customLeftBarButton() -> UIBarButtonItem {
        notificationLabel = UILabel(frame: CGRect(x: 10, y: 0, width: 15, height: 15))
        notificationLabel?.backgroundColor = UIColor.red
        notificationLabel?.layer.cornerRadius = (notificationLabel?.bounds.size.height)! / 2
        notificationLabel?.font = UIFont.fontRegular(fontSize: 10)
        notificationLabel?.textAlignment = .center
        notificationLabel?.textColor = UIColor.white
        notificationLabel?.clipsToBounds = true
        notificationLabel?.text = ""
        notificationLabel?.isHidden = true
        let customButton = UIButton(type: .system)
        customButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        customButton.titleLabel?.font = UIFont.designFont(fontSize: 18)
        customButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 0)
        customButton.setTitle(Constants.DesignFont.notification, for: .normal)
        customButton.addTarget(self, action: #selector(actionLeftNavigationItem), for: .touchUpInside)
        customButton.addSubview(notificationLabel!)
        let barButton = UIBarButtonItem(customView: customButton)
        return barButton
    }
    
    @objc override func actionLeftNavigationItem() {
        // will implement
        let notification = UIStoryboard.notificationStoryBoard().instantiateViewController(type: DMNotificationVC.self)!
        notification.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(notification, animated: true)
    }
    
    func setNotificationLabelText(count: Int) {
        if count != 0 {
            notificationLabel?.text = "\(count)"
            notificationLabel?.isHidden = false
            notificationLabel?.adjustsFontSizeToFitWidth = true
            
        } else {
            notificationLabel?.isHidden = true
        }
    }*/
}

extension DMTrackVC: JobSavedStatusUpdateDelegate {
    func jobUpdate(job: Job) {
        // unsave status
        let jobs = savedJobs.filter({ $0.jobId == job.jobId }).first
        if let _ = jobs {
            jobs?.isSaved = job.isSaved
            savedJobs.removeObject(object: jobs!)
            totalSavedJobsFromServer -= 1
            savedJobsTableView.reloadData()
        }
    }

    func jobApplied(job _: Job) {
        isFromJobDetailApplied = true
        appliedJobs.removeAll()
        appliedJobsPageNo = 1
    }
}

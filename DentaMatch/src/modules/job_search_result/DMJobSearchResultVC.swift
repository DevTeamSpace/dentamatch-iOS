//
//  DMJobSearchResultVC.swift
//  DentaMatch
//
//  Created by Shailesh Tyagi on 12/01/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import GoogleMaps
import UIKit

class DMJobSearchResultVC: DMBaseVC {
    @IBOutlet weak var currentGPSButtonTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var bannerLabel: UILabel!
    @IBOutlet weak var bannerView: UIView!

    @IBOutlet weak var bannerHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var tblJobSearchResult: UITableView!
    @IBOutlet weak var mapViewSearchResult: GMSMapView!
    @IBOutlet weak var constraintTblViewSearchResultHeight: NSLayoutConstraint!
    @IBOutlet weak var viewResultCount: UIView!
    @IBOutlet weak var lblResultCount: UILabel!
    @IBOutlet weak var constraintViewResultCountHeight: NSLayoutConstraint!
    
    @IBOutlet var btnCurrentLocation: UIButton!
    //var notificationLabel: UILabel?
    var bannerStatus = 0
    var rightBarBtn: UIButton = UIButton()
    var rightBarButtonItem: UIBarButtonItem = UIBarButtonItem()
    var isListShow: Bool = false
    var isMapShow: Bool = false
    var btnList: UIButton!
    var btnMap: UIButton!
    var currentCoordinate: CLLocationCoordinate2D! = CLLocationCoordinate2D(latitude: 0.00, longitude: 0.00)
    var arrMarkers = [JobMarker]()
    var jobs = [Job]()
    var rightBarButtonWidth: CGFloat = 20.0
    var cellHeight: CGFloat = 172.0
    var loadingMoreJobs = false
    var totalJobsFromServer = 0
    var jobsPageNo = 1

    var searchParams = [String: Any]()
    var markers = [JobMarker]()
    var pullToRefreshJobs = UIRefreshControl()

    var indexOfSelectedMarker: Int?
    var selectedMarker: JobMarker?
    var placeHolderEmptyJobsView: PlaceHolderJobsView?
    
    weak var moduleOutput: DMJobSearchResultModuleOutput?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setUp()
        getJobs()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.fetchBadgeCount()
    }

    func getJobs() {
        jobsPageNo = 1
        if let params = UserDefaultsManager.sharedInstance.loadSearchParameter() {
            searchParams = params
        }
        searchParams[Constants.JobDetailKey.page] = "\(jobsPageNo)"
        fetchSearchResultAPI(params: searchParams)
    }

    // MARK: Private Method

    func setUp() {
        if let params = UserDefaultsManager.sharedInstance.loadSearchParameter() {
            searchParams = params
        }

        placeHolderEmptyJobsView = PlaceHolderJobsView.loadPlaceHolderJobsView()
        placeHolderEmptyJobsView?.frame = CGRect(x: 0, y: 0, width: 300, height: 200)
        placeHolderEmptyJobsView?.center = view.center
        placeHolderEmptyJobsView?.backgroundColor = UIColor.clear
        placeHolderEmptyJobsView?.placeHolderMessageLabel.numberOfLines = 2
        view.addSubview(placeHolderEmptyJobsView!)
        placeHolderEmptyJobsView?.isHidden = false
        placeHolderEmptyJobsView?.layoutIfNeeded()
        view.layoutIfNeeded()
        placeHolderEmptyJobsView?.placeHolderMessageLabel.text = "No jobs found"//"You don’t have any jobs"

        NotificationCenter.default.addObserver(self, selector: #selector(pushRediectNotificationOtherAll), name: .pushRedirectNotificationAllForground, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(pushRediectNotificationOtherAllBackGround), name: .pushRedirectNotificationAllBackGround, object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(pushRediectNotificationForJobDetailForground), name: .pushRedirectNotificationForground, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(pushRediectNotificationForJobDetailBacground), name: .pushRedirectNotificationBacground, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(bannerUIStatus(_:)), name: .pushRedirectNotificationForProfile, object: nil)
       NotificationCenter.default.addObserver(self, selector: #selector(decreaseBadgeCount(_:)), name: .decreaseBadgeCount, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(fetchBadgeCount(_:)), name: .fetchBadgeCount, object: nil)
         NotificationCenter.default.addObserver(self, selector: #selector(refreshListForSaveUnsaveJob(_:)), name: .jobSavedUnsaved, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(bannerUIStatus(_:)), name: .profileUpdated, object: nil)
        mapViewSearchResult.isHidden = true
        tblJobSearchResult.register(UINib(nibName: "JobSearchResultCell", bundle: nil), forCellReuseIdentifier: "JobSearchResultCell")
        mapViewSearchResult.delegate = self
        mapViewSearchResult.isMyLocationEnabled = false
        lblResultCount.text = String(jobs.count) + Constants.Strings.whiteSpace + Constants.Strings.resultsFound

        navigationItem.leftBarButtonItem = nil//customLeftBarButton()

        setRightBarButton(title: "", imageName: "FilterImage", width: rightBarButtonWidth, font: UIFont.designFont(fontSize: 16.0))
        setUpSegmentControl()
        bannerHeightConstraint.constant = 0
        currentGPSButtonTopConstraint.constant = 15.0
        constraintTblViewSearchResultHeight.constant = UIScreen.main.bounds.height - (navigationController?.navigationBar.frame.height)! - UIApplication.shared.statusBarFrame.height - (tabBarController?.tabBar.frame.height)! - 32.0

        view.layoutIfNeeded()
        btnCurrentLocation.isHidden = true
        btnCurrentLocation.isUserInteractionEnabled = false
        btnCurrentLocation.layer.cornerRadius = btnCurrentLocation.frame.size.width / 2
        btnCurrentLocation.layer.shadowColor = UIColor.gray.cgColor
        btnCurrentLocation.layer.shadowOffset = CGSize(width: 0, height: 1.0)
        btnCurrentLocation.layer.shadowOpacity = 1.0
        btnCurrentLocation.layer.shadowRadius = 1.0

        tblJobSearchResult.layer.shadowColor = UIColor.gray.cgColor
        tblJobSearchResult.layer.shadowOffset = CGSize(width: 0, height: 1.0)
        tblJobSearchResult.layer.shadowOpacity = 1.0
        tblJobSearchResult.layer.shadowRadius = 1.0
        pullToRefreshJobs.addTarget(self, action: #selector(pullToRefreshForJobs), for: .valueChanged)
        tblJobSearchResult.addSubview(pullToRefreshJobs)
    }
    
    func fetchBadgeCount () {
        getUnreadNotificationCount { response, _ in
            if response![Constants.ServerKey.status].boolValue {
                if let resultDic = response![Constants.ServerKey.result].dictionary {
                    let count = resultDic["notificationCount"]?.intValue
                    //if self.notificationLabel != nil {
                    AppDelegate.delegate().setAppBadgeCount(count ?? 0)
                    //self.setNotificationLabelText(count: count!)
                    if let tabbarCtlr = self.tabBarController as? TabBarVC {
                        tabbarCtlr.updateBadgeOnProfileTab(value: count)
                    }
                    NotificationCenter.default.post(name: .updateBadgeCount, object: nil, userInfo: nil)
                    //} else {
                    //    self.notificationLabel?.isHidden = true
                    //}
                }
            }
        }
    }

    func showBanner(status: Int = 1) {
        // if status is 1 it means yellow banner i.e. profile not verified
        // if status is 2 it means red banner i.e. needs attention
        bannerStatus = status
        bannerHeightConstraint.constant = 45.0
        constraintTblViewSearchResultHeight.constant = UIScreen.main.bounds.height - (navigationController?.navigationBar.frame.height)! - UIApplication.shared.statusBarFrame.height - (tabBarController?.tabBar.frame.height)! - 32.0 - 45.0
        currentGPSButtonTopConstraint.constant = 55.0
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
        if status == 1 {
            bannerView.backgroundColor = UIColor.color(withHexCode: "e8ab43") // yellow /job seeker verified = 0
            bannerLabel.text = "Once we confirm your license, you’ll be able apply for jobs."
        } else {
            bannerView.backgroundColor = UIColor.color(withHexCode: "fc3238") // red // profile completed = 0
            bannerLabel.text = "Your Profile is incomplete, please select the availability to be able to apply for jobs."
        }
    }
    
   @objc func bannerUIStatus(_ userInfo: Notification){
        getJobs()
    }

    func hideBanner() {
        bannerHeightConstraint.constant = 0.0
        constraintTblViewSearchResultHeight.constant = UIScreen.main.bounds.height - (navigationController?.navigationBar.frame.height)! - UIApplication.shared.statusBarFrame.height - (tabBarController?.tabBar.frame.height)! - 32.0
        currentGPSButtonTopConstraint.constant = 15.0
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
    }

    @objc func pushRediectNotificationOtherAll(userInfo _: Notification) {
        moduleOutput?.showNotifications()
    }

    @objc func pushRediectNotificationOtherAllBackGround(userInfo _: Notification) {
        moduleOutput?.showNotifications()
    }

    @objc func pushRediectNotificationForJobDetailForground(userInfo: Notification) {
        let dict = userInfo.userInfo
        if let notification = dict?["notificationData"], let notiObj = notification as? Job {
            goToJobDetail(jobObj: notiObj)
        }
    }

    @objc func pushRediectNotificationForJobDetailBacground(userInfo: Notification) {
        let dict = userInfo.userInfo
        if let notification = dict?["notificationData"], let notiObj = notification as? Job  {
            goToJobDetail(jobObj: notiObj)
        }
    }
    
    @objc func fetchBadgeCount(_ notification: Notification) {
        self.fetchBadgeCount()
    }
    
    @objc func decreaseBadgeCount(_ notification: Notification) {
        AppDelegate.delegate().decrementBadgeCount()
        //self.setNotificationLabelText(count: AppDelegate.delegate().badgeCount())
        self.fetchBadgeCount()
    }

    func goToJobDetail(jobObj: Job) {
        
        moduleOutput?.showJobDetail(job: jobObj, delegate: self)
    }
    

    @objc override func actionRightNavigationItem() {
        moduleOutput?.showJobSearch(fromJobResult: true, delegate: self)
    }

    @objc func pullToRefreshForJobs() {
        getJobs()
        pullToRefreshJobs.endRefreshing()
    }

    @objc func refreshListForSaveUnsaveJob(_ notification: Notification) {
        if let jobObj = notification.object as? Job, jobObj.jobId != 0 {
            let filteredJobs = self.jobs.filter{$0.jobId == jobObj.jobId }
            for job in filteredJobs {
                job.isSaved = jobObj.isSaved
            }
            DispatchQueue.main.async {
                if let visibleRows = self.tblJobSearchResult.indexPathsForVisibleRows {
                    self.tblJobSearchResult.reloadRows(at: visibleRows, with: .none)
                }
            }
        }
    }
    
    func setUpSegmentControl() {
        let segmentView: UIView! = UIView(frame: CGRect(x: 0, y: 0, width: 152, height: 29))
        segmentView.backgroundColor = UIColor.clear
        segmentView.layer.cornerRadius = 4.0
        segmentView.layer.borderColor = Constants.Color.segmentControlBorderColor.cgColor
        segmentView.layer.borderWidth = 1.0
        segmentView.layer.masksToBounds = true

        btnList = UIButton(frame: CGRect(x: 0, y: 1, width: 75, height: 27))
        btnList.setTitle("List", for: .normal)
        btnList.setTitleColor(UIColor.white, for: .normal)
        btnList.titleLabel!.font = UIFont.fontLight(fontSize: 13.0)
        btnList.backgroundColor = Constants.Color.segmentControlSelectionColor
        btnList.addTarget(self, action: #selector(actionListButton), for: .touchUpInside)

        btnMap = UIButton(frame: CGRect(x: 76, y: 1, width: 75, height: 27))
        btnMap.setTitle("Map", for: .normal)
        btnMap.setTitleColor(UIColor.white, for: .normal)
        btnMap.titleLabel!.font = UIFont.fontLight(fontSize: 13.0)
        btnMap.backgroundColor = UIColor.clear
        btnMap.layer.masksToBounds = true
        btnMap.addTarget(self, action: #selector(actionMapButton), for: .touchUpInside)
        segmentView.addSubview(btnList)
        segmentView.addSubview(btnMap)
        navigationItem.titleView = segmentView
    }

    @objc func actionListButton() {
        if isListShow == false {
            btnList.backgroundColor = Constants.Color.mapButtonBackGroundColor
            btnList.titleLabel!.font = UIFont.fontSemiBold(fontSize: 13.0)
            btnMap.titleLabel!.font = UIFont.fontLight(fontSize: 13.0)
            btnMap.backgroundColor = UIColor.clear
            mapViewSearchResult.isHidden = true
            tblJobSearchResult.isHidden = false
            constraintTblViewSearchResultHeight.constant = UIScreen.main.bounds.height - (navigationController?.navigationBar.frame.height)! - UIApplication.shared.statusBarFrame.height - (tabBarController?.tabBar.frame.height)! - 32.0
            if bannerStatus == 1 || bannerStatus == 2 {
                showBanner(status: bannerStatus)
            }

            view.layoutIfNeeded()
            tblJobSearchResult.isScrollEnabled = true
            btnCurrentLocation.isHidden = true
        }
        isListShow = !isListShow
        isMapShow = false
    }

    @objc func actionMapButton() {
        if isMapShow == false {
            btnMap.backgroundColor = Constants.Color.mapButtonBackGroundColor
            btnMap.titleLabel!.font = UIFont.fontSemiBold(fontSize: 13.0)
            btnList.titleLabel!.font = UIFont.fontLight(fontSize: 13.0)
            btnList.backgroundColor = UIColor.clear
            mapViewSearchResult.isHidden = false
            tblJobSearchResult.isHidden = true
            view.layoutIfNeeded()
            btnCurrentLocation.isHidden = false
        }
        isMapShow = !isMapShow
        isListShow = false
        restoreAllMarkers()
    }

    @IBAction func actionCurrentLocaton(_: UIButton) {
        mapViewSearchResult.animate(to: GMSCameraPosition(target: currentCoordinate, zoom: 15, bearing: 0, viewingAngle: 0))
        hideCard()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension DMJobSearchResultVC: SearchJobDelegate {
    func refreshJobList() {
        jobsPageNo = 1
        if let params = UserDefaultsManager.sharedInstance.loadSearchParameter() {
            searchParams = params
        }
        searchParams[Constants.JobDetailKey.page] = "\(jobsPageNo)"
        fetchSearchResultAPI(params: searchParams)
    }
}

extension DMJobSearchResultVC: JobSavedStatusUpdateDelegate {
    func jobUpdate(job: Job) {
        let updatedJob = jobs.filter({ $0.jobId == job.jobId }).first
        updatedJob?.isSaved = job.isSaved
        tblJobSearchResult.reloadData()
    }
}
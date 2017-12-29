//
//  DMJobSearchResultVC.swift
//  DentaMatch
//
//  Created by Shailesh Tyagi on 12/01/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit
import GoogleMaps

class DMJobSearchResultVC : DMBaseVC {
    @IBOutlet weak var currentGPSButtonTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var bannerLabel: UILabel!
    @IBOutlet weak var bannerView: UIView!
    
    @IBOutlet weak var bannerHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var tblJobSearchResult: UITableView!
    @IBOutlet weak var mapViewSearchResult: GMSMapView!
    @IBOutlet weak var constraintTblViewSearchResultHeight: NSLayoutConstraint!
    @IBOutlet weak var lblResultCount: UILabel!
    
    @IBOutlet weak var btnCurrentLocation: UIButton!
    var notificationLabel:UILabel?
    var bannerStatus = 0
    var rightBarBtn : UIButton = UIButton()
    var rightBarButtonItem : UIBarButtonItem = UIBarButtonItem()
    var isListShow : Bool = false
    var isMapShow : Bool = false
    var btnList : UIButton!
    var btnMap : UIButton!
    var currentCoordinate : CLLocationCoordinate2D! = CLLocationCoordinate2D(latitude : 0.00, longitude : 0.00)
    var arrMarkers  = [JobMarker]()
    var jobs = [Job]()
    var rightBarButtonWidth : CGFloat = 20.0
    var cellHeight : CGFloat = 172.0
    var loadingMoreJobs = false
    var totalJobsFromServer = 0
    var jobsPageNo = 1
    
    var searchParams = [String : Any]()
    var markers = [JobMarker]()
    var pullToRefreshJobs = UIRefreshControl()
    
    var indexOfSelectedMarker: Int?
    var selectedMarker: JobMarker?
    
    //var stylebarAndNavigationbarHeight = s
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.setUp()
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
        self.getUnreadNotificationCount { (response, error ) in
            if response![Constants.ServerKey.status].boolValue {
                if let resultDic = response![Constants.ServerKey.result].dictionary {
                    let count = resultDic["notificationCount"]?.intValue
                    if self.notificationLabel != nil {
                        self.setNotificationLabelText(count: count!)
                    }else{
                        self.notificationLabel?.isHidden = true
                    }
                }
            }
        }
    }
    
    func setNotificationLabelText(count:Int) {
        if count != 0 {
            self.notificationLabel?.text = "\(count)"
            self.notificationLabel?.isHidden = false
            self.notificationLabel?.adjustsFontSizeToFitWidth = true

        }else {
            self.notificationLabel?.isHidden = true
        }
    }
    
    func getJobs() {
        jobsPageNo = 1
        if let params =  UserDefaultsManager.sharedInstance.loadSearchParameter() {
            searchParams = params
        }
        searchParams[Constants.JobDetailKey.page] = "\(self.jobsPageNo)"
        self.fetchSearchResultAPI(params: searchParams)
    }
    
    //MARK : Private Method
    func setUp() {
        if let params =  UserDefaultsManager.sharedInstance.loadSearchParameter() {
            searchParams = params
        }

        NotificationCenter.default.addObserver(self, selector: #selector(pushRediectNotificationOtherAll), name: .pushRedirectNotificationAllForground, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(pushRediectNotificationOtherAllBackGround), name: .pushRedirectNotificationAllBackGround, object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(pushRediectNotificationForJobDetailForground), name: .pushRedirectNotificationForground, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(pushRediectNotificationForJobDetailBacground), name: .pushRedirectNotificationBacground, object: nil)

        self.mapViewSearchResult.isHidden = true
        self.tblJobSearchResult.register(UINib(nibName: "JobSearchResultCell", bundle: nil), forCellReuseIdentifier: "JobSearchResultCell")
        self.mapViewSearchResult.delegate = self
        self.mapViewSearchResult.isMyLocationEnabled = true
        self.lblResultCount.text = String(self.jobs.count) + Constants.Strings.whiteSpace + Constants.Strings.resultsFound
//        self.setLeftBarButton(title: Constants.DesignFont.notification)
        self.navigationItem.leftBarButtonItem = self.customLeftBarButton()

        self.setRightBarButton(title: "",imageName: "search",width : rightBarButtonWidth, font: UIFont.designFont(fontSize: 16.0)!)
        self.setUpSegmentControl()
        self.bannerHeightConstraint.constant = 0
        self.currentGPSButtonTopConstraint.constant = 15.0
        self.constraintTblViewSearchResultHeight.constant = UIScreen.main.bounds.height - (self.navigationController?.navigationBar.frame.height)! - UIApplication.shared.statusBarFrame.height - (self.tabBarController?.tabBar.frame.height)! - (32.0) 
//        self.constraintTblViewSearchResultHeight.constant = UIScreen.main.bounds.height - (self.navigationController?.navigationBar.frame.height)! - UIApplication.shared.statusBarFrame.height - (self.tabBarController?.tabBar.frame.height)! - (32.0) - (45.0)

        self.view.layoutIfNeeded()
        self.btnCurrentLocation.isHidden = true
        self.btnCurrentLocation.isUserInteractionEnabled = false
        self.btnCurrentLocation.layer.cornerRadius = self.btnCurrentLocation.frame.size.width/2
        self.btnCurrentLocation.layer.shadowColor = UIColor.gray.cgColor
        self.btnCurrentLocation.layer.shadowOffset = CGSize(width: 0, height: 1.0)
        self.btnCurrentLocation.layer.shadowOpacity = 1.0
        self.btnCurrentLocation.layer.shadowRadius = 1.0
        
        self.tblJobSearchResult.layer.shadowColor = UIColor.gray.cgColor
        self.tblJobSearchResult.layer.shadowOffset = CGSize(width: 0, height: 1.0)
        self.tblJobSearchResult.layer.shadowOpacity = 1.0
        self.tblJobSearchResult.layer.shadowRadius = 1.0
        pullToRefreshJobs.addTarget(self, action: #selector(pullToRefreshForJobs), for: .valueChanged)
        self.tblJobSearchResult.addSubview(pullToRefreshJobs)
        
    }
    
    func showBanner(status:Int = 1) {
        //if status is 1 it means yellow banner i.e. profile not verified
        //if status is 2 it means red banner i.e. needs attention
        self.bannerStatus = status
        self.bannerHeightConstraint.constant = 45.0
        self.constraintTblViewSearchResultHeight.constant = UIScreen.main.bounds.height - (self.navigationController?.navigationBar.frame.height)! - UIApplication.shared.statusBarFrame.height - (self.tabBarController?.tabBar.frame.height)! - (32.0) - (45.0)
        self.currentGPSButtonTopConstraint.constant = 55.0
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
        if status == 1 {
            self.bannerView.backgroundColor = UIColor.color(withHexCode: "e8ab43") //yellow /job seeker verified = 0
            self.bannerLabel.text = "Your Profile is currently is being reviewed by Admin. Once it gets approved, you can start applying for jobs."
        } else {
            self.bannerView.backgroundColor = UIColor.color(withHexCode: "fc3238") //red // profile completed = 0
            self.bannerLabel.text = "Your Profile is incomplete, please select the availability to be able to apply for jobs."
        }
    }
    
    func hideBanner() {
        self.bannerHeightConstraint.constant = 0.0
        self.constraintTblViewSearchResultHeight.constant = UIScreen.main.bounds.height - (self.navigationController?.navigationBar.frame.height)! - UIApplication.shared.statusBarFrame.height - (self.tabBarController?.tabBar.frame.height)! - (32.0)
        self.currentGPSButtonTopConstraint.constant = 15.0
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
    }
    
    
    func customLeftBarButton() -> UIBarButtonItem {
        notificationLabel = UILabel(frame: CGRect(x: 10, y: 0, width: 15, height: 15))
        notificationLabel?.backgroundColor = UIColor.red
        notificationLabel?.layer.cornerRadius = (notificationLabel?.bounds.size.height)!/2
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

    
    
    @objc func pushRediectNotificationOtherAll(userInfo:Notification) {
        if let tabbar = ((UIApplication.shared.delegate) as! AppDelegate).window?.rootViewController as? TabBarVC {
            _=self.navigationController?.popToRootViewController(animated: false)
            tabbar.selectedIndex = 0
            let notification = UIStoryboard.notificationStoryBoard().instantiateViewController(type: DMNotificationVC.self)!
            notification.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(notification, animated: true)

        }
        
    }
    @objc func pushRediectNotificationOtherAllBackGround(userInfo:Notification) {
        if let tabbar = ((UIApplication.shared.delegate) as! AppDelegate).window?.rootViewController as? TabBarVC {
            _=self.navigationController?.popToRootViewController(animated: false)
            tabbar.selectedIndex = 0
            let notification = UIStoryboard.notificationStoryBoard().instantiateViewController(type: DMNotificationVC.self)!
            notification.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(notification, animated: true)
        }
        
    }

    @objc func pushRediectNotificationForJobDetailForground(userInfo:Notification) {
        if let tabbar = ((UIApplication.shared.delegate) as! AppDelegate).window?.rootViewController as? TabBarVC {
            _=self.navigationController?.popToRootViewController(animated: false)
            tabbar.selectedIndex = 0
        }
        
        let dict = userInfo.userInfo
        
        if let notification = dict?["notificationData"] {
            let notiObj = notification as! Job
            goToJobDetail(jobObj: notiObj)
        }
    }
   

    @objc func pushRediectNotificationForJobDetailBacground(userInfo:Notification) {
        if let tabbar = ((UIApplication.shared.delegate) as! AppDelegate).window?.rootViewController as? TabBarVC {
            tabbar.selectedIndex = 0
        }

        let dict = userInfo.userInfo
        if let notification = dict?["notificationData"] {
            let notiObj = notification as! Job
            goToJobDetail(jobObj: notiObj)
        }
    }
    func goToJobDetail(jobObj:Job){
        let jobDetailVC = UIStoryboard.jobSearchStoryBoard().instantiateViewController(type: DMJobDetailVC.self)!
        jobDetailVC.job = jobObj
        jobDetailVC.hidesBottomBarWhenPushed = true
        jobDetailVC.delegate = self
        self.navigationController?.pushViewController(jobDetailVC, animated: true)

    }

    @objc override func actionLeftNavigationItem() {
        //will implement
        let notification = UIStoryboard.notificationStoryBoard().instantiateViewController(type: DMNotificationVC.self)!
        notification.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(notification, animated: true)

    }
    
    @objc override func actionRightNavigationItem() {
        let jobSearchVC = UIStoryboard.jobSearchStoryBoard().instantiateViewController(type: DMJobSearchVC.self)!
        jobSearchVC.fromJobSearchResults = true
        jobSearchVC.delegate = self
        jobSearchVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(jobSearchVC, animated: true)
    }
    
    
    @objc func pullToRefreshForJobs() {
        self.getJobs()
        self.pullToRefreshJobs.endRefreshing()
    }
    
    func setUpSegmentControl() {
        let segmentView : UIView! = UIView(frame:CGRect (x : 0,y : 0, width : 152,height : 29))
        segmentView.backgroundColor = UIColor.clear
        segmentView.layer.cornerRadius = 4.0
        segmentView.layer.borderColor = Constants.Color.segmentControlBorderColor.cgColor
        segmentView.layer.borderWidth = 1.0
        segmentView.layer.masksToBounds = true
        
        self.btnList = UIButton.init(frame: CGRect(x : 0 , y : 1, width : 75, height : 27))
        self.btnList.setTitle("List", for: .normal)
        self.btnList.setTitleColor(UIColor.white, for: .normal)
        self.btnList.titleLabel!.font =  UIFont.fontLight(fontSize: 13.0)
        self.btnList.backgroundColor = Constants.Color.segmentControlSelectionColor
        self.btnList.addTarget(self, action: #selector(actionListButton), for: .touchUpInside)
        
        self.btnMap = UIButton.init(frame: CGRect(x : 76 , y : 1, width : 75, height : 27))
        self.btnMap.setTitle("Map", for: .normal)
        self.btnMap.setTitleColor(UIColor.white, for: .normal)
        self.btnMap.titleLabel!.font =  UIFont.fontLight(fontSize: 13.0)
        self.btnMap.backgroundColor = UIColor.clear
        self.btnMap.layer.masksToBounds = true
        self.btnMap.addTarget(self, action: #selector(actionMapButton), for: .touchUpInside)
        segmentView.addSubview(self.btnList)
        segmentView.addSubview(btnMap)
        self.navigationItem.titleView = segmentView
    }
    
    @objc func actionListButton() {
        if isListShow == false {
            self.btnList.backgroundColor = Constants.Color.mapButtonBackGroundColor
            self.btnList.titleLabel!.font =  UIFont.fontSemiBold(fontSize: 13.0)
            self.btnMap.titleLabel!.font =  UIFont.fontLight(fontSize: 13.0)
            self.btnMap.backgroundColor = UIColor.clear
            self.mapViewSearchResult.isHidden = true
            self.tblJobSearchResult.isHidden = false
            if self.bannerStatus == 1 || self.bannerStatus == 2 {
                self.showBanner(status: self.bannerStatus)
            }
            
//            self.constraintTblViewSearchResultHeight.constant = UIScreen.main.bounds.height - (self.navigationController?.navigationBar.frame.height)! - UIApplication.shared.statusBarFrame.height - (self.tabBarController?.tabBar.frame.height)! - ((32.0))
            self.view.layoutIfNeeded()
            self.tblJobSearchResult.isScrollEnabled = true
            self.btnCurrentLocation.isHidden = true
        }
        isListShow = !isListShow
        isMapShow = false
    }
    
    @objc func actionMapButton() {
        if isMapShow == false {
            self.btnMap.backgroundColor = Constants.Color.mapButtonBackGroundColor
            self.btnMap.titleLabel!.font =  UIFont.fontSemiBold(fontSize: 13.0)
            self.btnList.titleLabel!.font =  UIFont.fontLight(fontSize: 13.0)
            self.btnList.backgroundColor = UIColor.clear
            self.mapViewSearchResult.isHidden = false
            self.tblJobSearchResult.isHidden = true
//            self.constraintTblViewSearchResultHeight.constant = 0.0
            self.view.layoutIfNeeded()
            self.btnCurrentLocation.isHidden = false
        }
        isMapShow = !isMapShow
        isListShow = false
        self.getLocation()
        self.restoreAllMarkers()
    }
    
    @IBAction func actionCurrentLocaton(_ sender: UIButton) {
        self.mapViewSearchResult.animate(to: GMSCameraPosition(target: self.currentCoordinate, zoom: 15, bearing: 0, viewingAngle: 0))
        self.hideCard()
    }
    
    func getLocation() {
        LocationManager.sharedInstance.getLocation { (location:CLLocation?, error:NSError?) in
            if error != nil {
                DispatchQueue.main.async {
                    self.hideLoader()
                    self.alertMessage(title: "", message: (error?.localizedDescription)!, buttonText: kOkButtonTitle, completionHandler: nil)
                }
                return
            }
            self.btnCurrentLocation.isUserInteractionEnabled = true
            let coordinate = CLLocationCoordinate2D(latitude: (location!.coordinate.latitude), longitude: (location!.coordinate.longitude))
            self.currentCoordinate = coordinate
        }
    }
}

extension DMJobSearchResultVC : SearchJobDelegate {
    func refreshJobList() {
        jobsPageNo = 1
        if let params =  UserDefaultsManager.sharedInstance.loadSearchParameter() {
            searchParams = params
        }
        searchParams[Constants.JobDetailKey.page] = "\(self.jobsPageNo)"
        self.fetchSearchResultAPI(params: searchParams)
    }
}

extension DMJobSearchResultVC: JobSavedStatusUpdateDelegate {
    
    func jobUpdate(job: Job) {
        let updatedJob = self.jobs.filter({$0.jobId == job.jobId}).first
        updatedJob?.isSaved = job.isSaved
        self.tblJobSearchResult.reloadData()
    }
}

import GoogleMaps
import UIKit

class DMJobSearchResultVC: DMBaseVC {
    
    enum JobSearchState {
        case list
        case map
    }
    
    @IBOutlet weak var profileInReviewView: UIView!
    @IBOutlet weak var profileInReviewLabel: UILabel!
    @IBOutlet weak var containerView: UIView!

//    @IBOutlet weak var currentGPSButtonTopConstraint: NSLayoutConstraint!
//    @IBOutlet weak var bannerLabel: UILabel!
//    @IBOutlet weak var bannerView: UIView!
//
//    @IBOutlet weak var bannerHeightConstraint: NSLayoutConstraint!
//    @IBOutlet weak var tblJobSearchResult: UITableView!
//    @IBOutlet weak var mapViewSearchResult: GMSMapView!
//    @IBOutlet weak var constraintTblViewSearchResultHeight: NSLayoutConstraint!
//    @IBOutlet weak var viewResultCount: UIView!
//    @IBOutlet weak var lblResultCount: UILabel!
//    @IBOutlet weak var constraintViewResultCountHeight: NSLayoutConstraint!
//
//    @IBOutlet var btnCurrentLocation: UIButton!
//    var notificationLabel: UILabel?
//    var rightBarBtn: UIButton = UIButton()
//    var rightBarButtonItem: UIBarButtonItem = UIBarButtonItem()
//    var isListShow: Bool = false
//    var isMapShow: Bool = false
//    var btnList: UIButton!
//    var btnMap: UIButton!
//    var arrMarkers = [JobMarker]()
//    var rightBarButtonWidth: CGFloat = 20.0
//    var cellHeight: CGFloat = 172.0
//    var loadingMoreJobs = false
//
//    var searchParams = [String: Any]()
//    var markers = [JobMarker]()
//    var pullToRefreshJobs = UIRefreshControl()
//
//    var placeHolderEmptyJobsView: PlaceHolderJobsView?
    
    var viewOutput: DMJobSearchResultViewOutput?
    
    private weak var jobListModuleInput: JobSearchListScreenModuleInput?
    private weak var jobMapModuleInput: JobSearchMapScreenModuleInput?
    
    private var currentState = JobSearchState.list
    
    private var listSegmentButton: UIButton?
    private var mapSegmentButton: UIButton?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUp()
        viewOutput?.didLoad()
    }
    
    func setUp() {
        guard let viewOutput = viewOutput else { return }

        setRightBarButton(title: "", imageName: "FilterImage", width: 20.0, font: UIFont.designFont(fontSize: 16.0))
        setUpSegmentControl()
        
        let (jobListModuleInput, jobListVcOpt) = JobSearchListScreenInitializer.initialize(moduleOutput: viewOutput)
        let (jobMapModuleInput, jobMapVcOpt) = JobSearchMapScreenInitializer.initialize(moduleOutput: viewOutput)
        
        guard let jobListVc = jobListVcOpt, let jobMapVc = jobMapVcOpt else { return }
        
        addChild(jobListVc)
        addChild(jobMapVc)
        
        jobListVc.view.translatesAutoresizingMaskIntoConstraints = false
        jobMapVc.view.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.addSubview(jobMapVc.view)
        containerView.addSubview(jobListVc.view)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: jobListVc.view.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: jobListVc.view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: jobListVc.view.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: jobListVc.view.bottomAnchor),
            containerView.topAnchor.constraint(equalTo: jobMapVc.view.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: jobMapVc.view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: jobMapVc.view.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: jobMapVc.view.bottomAnchor)
        ])
        
        view.layoutIfNeeded()
        jobListVc.didMove(toParent: self)
        jobMapVc.didMove(toParent: self)
        
        jobMapVc.view.isHidden = true
        
        self.jobListModuleInput = jobListModuleInput
        self.jobMapModuleInput =  jobMapModuleInput
    }
    

    @objc override func actionRightNavigationItem() {
        viewOutput?.openJobSearch(fromJobResult: true, delegate: self)
    }

    func setUpSegmentControl() {
        let segmentView: UIView! = UIView(frame: CGRect(x: 0, y: 0, width: 152, height: 29))
        segmentView.backgroundColor = UIColor.clear
        segmentView.layer.cornerRadius = 4.0
        segmentView.layer.borderColor = Constants.Color.segmentControlBorderColor.cgColor
        segmentView.layer.borderWidth = 1.0
        segmentView.layer.masksToBounds = true

        let btnList: UIButton
        let btnMap: UIButton
        
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
        
        listSegmentButton = btnList
        mapSegmentButton = btnMap
    }

    @objc func actionListButton() {
        guard let toVc = jobListModuleInput?.viewController(), currentState != .list,
            let fromVc = jobMapModuleInput?.viewController() else { return }
        
        fromVc.view.isHidden = true
        toVc.view.isHidden = false
        listSegmentButton?.backgroundColor = Constants.Color.mapButtonBackGroundColor
        listSegmentButton?.titleLabel!.font = UIFont.fontSemiBold(fontSize: 13.0)
        mapSegmentButton?.titleLabel!.font = UIFont.fontLight(fontSize: 13.0)
        mapSegmentButton?.backgroundColor = UIColor.clear
//
//        view.addSubview(toVc.view)
//        containerView.removeConstraints(containerView.constraints)
//
//        NSLayoutConstraint.activate([
//            containerView.topAnchor.constraint(equalTo: toVc.view.topAnchor),
//            containerView.leadingAnchor.constraint(equalTo: toVc.view.leadingAnchor),
//            containerView.trailingAnchor.constraint(equalTo: toVc.view.trailingAnchor),
//            containerView.bottomAnchor.constraint(equalTo: toVc.view.bottomAnchor)
//        ])
//
//        view.layoutIfNeeded()
//        fromVc.view.removeFromSuperview()
        
        currentState = .list
    }

    @objc func actionMapButton() {
        guard let toVc = jobMapModuleInput?.viewController(), currentState != .map,
            let fromVc = jobListModuleInput?.viewController() else { return }
        
        fromVc.view.isHidden = true
        toVc.view.isHidden = false
//        fromVc.view.removeFromSuperview()
//
        mapSegmentButton?.backgroundColor = Constants.Color.mapButtonBackGroundColor
        mapSegmentButton?.titleLabel!.font = UIFont.fontSemiBold(fontSize: 13.0)
        listSegmentButton?.titleLabel!.font = UIFont.fontLight(fontSize: 13.0)
        listSegmentButton?.backgroundColor = UIColor.clear
//
//        view.addSubview(toVc.view)
//        containerView.removeConstraints(containerView.constraints)
//
//        NSLayoutConstraint.activate([
//            containerView.topAnchor.constraint(equalTo: toVc.view.topAnchor),
//            containerView.leadingAnchor.constraint(equalTo: toVc.view.leadingAnchor),
//            containerView.trailingAnchor.constraint(equalTo: toVc.view.trailingAnchor),
//            containerView.bottomAnchor.constraint(equalTo: toVc.view.bottomAnchor)
//        ])
//
//        view.layoutIfNeeded()
        
        currentState = .map
    }
}

extension DMJobSearchResultVC: DMJobSearchResultViewInput {
    func showBanner(status: Int) {
        profileInReviewView.isHidden = false
        
        switch status {
        case 1:
            profileInReviewView.backgroundColor = UIColor.color(withHexCode: "e8ab43")
            profileInReviewLabel.text = "Your Profile is currently is being reviewed by Admin. Once it gets approved, you can start applying for jobs."
        case 2:
            profileInReviewView.backgroundColor = UIColor.color(withHexCode: "fc3238")
            profileInReviewLabel.text = "Your Proifle is incomplete, please select the availability to be able to apply for jobs."
        default:
            break
        }
    }
    
    func hideBanner() {
        profileInReviewView.isHidden = true
    }
    
    func updateBadge(count: Int) {
        if let tabbarCtlr = self.tabBarController as? TabBarVC {
            tabbarCtlr.updateBadgeOnProfileTab(value: count)
        }
        NotificationCenter.default.post(name: .updateBadgeCount, object: nil, userInfo: nil)
    }
    
    func updateMapMarkers(jobs: [Job]) {
        jobMapModuleInput?.populateWithJobs(jobs: jobs)
    }
}

extension DMJobSearchResultVC: SearchJobDelegate {
    func refreshJobList() {
        jobListModuleInput?.refreshData(true)
    }
}

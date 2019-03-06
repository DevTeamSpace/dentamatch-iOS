import GoogleMaps
import UIKit

class DMJobSearchResultVC: DMBaseVC {
    
    enum JobSearchState: Int {
        case list = 0
        case map = 1
    }
    
    @IBOutlet weak var profileInReviewView: UIView!
    @IBOutlet weak var profileInReviewLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var containerView: UIView!
    
    var viewOutput: DMJobSearchResultViewOutput?
    
    private weak var jobListModuleInput: JobSearchListScreenModuleInput?
    private weak var jobMapModuleInput: JobSearchMapScreenModuleInput?
    
    private var currentState = JobSearchState.list {
        willSet {
            changeState(newValue)
        }
    }
    
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
        
        containerView.addSubview(jobListVc.view)
        containerView.addSubview(jobMapVc.view)

        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: jobListVc.view.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: jobListVc.view.leadingAnchor),
            containerView.bottomAnchor.constraint(equalTo: jobListVc.view.bottomAnchor),
            jobListVc.view.widthAnchor.constraint(equalTo: view.widthAnchor),
            
            containerView.topAnchor.constraint(equalTo: jobMapVc.view.topAnchor),
            jobMapVc.view.leadingAnchor.constraint(equalTo: jobListVc.view.trailingAnchor),
            containerView.trailingAnchor.constraint(equalTo: jobMapVc.view.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: jobMapVc.view.bottomAnchor),
            jobMapVc.view.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])

        
        view.layoutIfNeeded()
        jobListVc.didMove(toParent: self)
        jobMapVc.didMove(toParent: self)
        
        scrollView.delegate = self
        
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
        guard let toVc = jobListModuleInput?.viewController(), currentState != .list else { return }
        
        scrollView.setContentOffset(CGPoint(x: toVc.view.frame.minX, y: 0), animated: true)
        currentState = .list
    }

    @objc func actionMapButton() {
        guard let toVc = jobMapModuleInput?.viewController(), currentState != .map else { return }
        
        scrollView.setContentOffset(CGPoint(x: toVc.view.frame.minX, y: 0), animated: true)
        currentState = .map
    }
    
    func changeState(_ newState: JobSearchState) {
        
        switch newState {
        case .list:
            listSegmentButton?.backgroundColor = Constants.Color.mapButtonBackGroundColor
            listSegmentButton?.titleLabel!.font = UIFont.fontSemiBold(fontSize: 13.0)
            mapSegmentButton?.titleLabel!.font = UIFont.fontLight(fontSize: 13.0)
            mapSegmentButton?.backgroundColor = UIColor.clear
        case .map:
            mapSegmentButton?.backgroundColor = Constants.Color.mapButtonBackGroundColor
            mapSegmentButton?.titleLabel!.font = UIFont.fontSemiBold(fontSize: 13.0)
            listSegmentButton?.titleLabel!.font = UIFont.fontLight(fontSize: 13.0)
            listSegmentButton?.backgroundColor = UIColor.clear
        }
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

extension DMJobSearchResultVC: UIScrollViewDelegate {
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        guard let newState = JobSearchState(rawValue: Int(scrollView.contentOffset.x / scrollView.frame.width)) else { return }
        currentState = newState
    }
}

extension DMJobSearchResultVC: SearchJobDelegate {
    
    func refreshJobList() {
        jobListModuleInput?.refreshData(true)
    }
    
    func refreshJobList(showLoading: Bool) {
        jobListModuleInput?.refreshData(showLoading)
    }
}

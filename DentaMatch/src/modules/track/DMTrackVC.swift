import UIKit

class DMTrackVC: DMBaseVC {
    enum SegmentControlOption: Int {
        case saved
        case applied
        case shortlisted
    }

    var pullToRefreshSavedJobs = UIRefreshControl()
    var pullToRefreshAppliedJobs = UIRefreshControl()
    var pullToRefreshShortListedJobs = UIRefreshControl()
    var placeHolderEmptyJobsView: PlaceHolderJobsView?
    
    var viewOutput: DMTrackViewOutput?

    @IBOutlet var savedJobsTableView: UITableView!
    @IBOutlet var appliedJobsTableView: UITableView!

    @IBOutlet var shortListedJobsTableView: UITableView!
    @IBOutlet var segmentedControl: CustomSegmentControl!
    //var notificationLabel: UILabel?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        setup()
        viewOutput?.didLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
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

        view.bringSubviewToFront(savedJobsTableView)
        view.bringSubviewToFront(appliedJobsTableView)
        view.bringSubviewToFront(shortListedJobsTableView)

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
        
        NotificationCenter.default.addObserver(self, selector: #selector(pullToRefreshForSavedJobs), name: .refreshSavedJobs, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(pullToRefreshForAppliedJobs), name: .refreshAppliedJobs, object: nil)
         //NotificationCenter.default.addObserver(self, selector: #selector(pullToRefreshForShortListedJobs), name: .refreshInterviewingJobs, object: nil)
    }

    @objc func pullToRefreshForSavedJobs() {
        savedJobsTableView.tableFooterView = nil
        viewOutput?.refreshData(type: .saved)
    }

    @objc func pullToRefreshForAppliedJobs() {
        appliedJobsTableView.tableFooterView = nil
        viewOutput?.refreshData(type: .applied)
    }

    @objc func pullToRefreshForShortListedJobs() {
        shortListedJobsTableView.tableFooterView = nil
        viewOutput?.refreshData(type: .shortlisted)
    }

    func openJobDetails(indexPath: IndexPath) {
        
        let segmentControlOptions = SegmentControlOption(rawValue: segmentedControl.selectedSegmentIndex)!
        
        switch segmentControlOptions {
        case .saved:
            viewOutput?.openJobDetails(index: indexPath.row, type: .saved, delegate: self)
        case .applied:
            viewOutput?.openJobDetails(index: indexPath.row, type: .applied, delegate: self)

        case .shortlisted:
            viewOutput?.openJobDetails(index: indexPath.row, type: .shortlisted, delegate: self)
        }
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
            viewOutput?.switchToType(.saved)
        case .applied:
            savedJobsTableView.isHidden = true
            shortListedJobsTableView.isHidden = true
            appliedJobsTableView.isHidden = false
            savedJobsTableView.dataSource = nil
            appliedJobsTableView.dataSource = self
            shortListedJobsTableView.dataSource = nil

            placeHolderEmptyJobsView?.placeHolderMessageLabel.text = "You don’t have any applied jobs"
            viewOutput?.switchToType(.applied)
        case .shortlisted:
            savedJobsTableView.isHidden = true
            appliedJobsTableView.isHidden = true
            shortListedJobsTableView.isHidden = false
            savedJobsTableView.dataSource = nil
            appliedJobsTableView.dataSource = nil
            shortListedJobsTableView.dataSource = self

            placeHolderEmptyJobsView?.placeHolderMessageLabel.text = "You don’t have any interviewing jobs"
            viewOutput?.switchToType(.shortlisted)
        }
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension DMTrackVC: DMTrackViewInput {
    
    func reloadData() {
        
        pullToRefreshSavedJobs.endRefreshing()
        pullToRefreshAppliedJobs.endRefreshing()
        pullToRefreshShortListedJobs.endRefreshing()
        
        savedJobsTableView.reloadData()
        appliedJobsTableView.reloadData()
        shortListedJobsTableView.reloadData()
        
        savedJobsTableView.tableFooterView = nil
        appliedJobsTableView.tableFooterView = nil
        shortListedJobsTableView.tableFooterView = nil
    }
    
    func configureEmptyView(isHidden: Bool, message: String?) {
        placeHolderEmptyJobsView?.isHidden = isHidden
        
        if let message = message {
            placeHolderEmptyJobsView?.placeHolderMessageLabel.text = message
        }
    }
    
    func addLoadingCell(to type: PTRType) {
        switch type {
        case .saved:
            setupLoadingMoreOnTable(tableView: savedJobsTableView)
        case .applied:
            setupLoadingMoreOnTable(tableView: appliedJobsTableView)
        case .shortlisted:
            setupLoadingMoreOnTable(tableView: shortListedJobsTableView)
        }
    }
}

extension DMTrackVC: JobSavedStatusUpdateDelegate {
    func jobUpdate(job: Job) {
        // unsave status
        viewOutput?.jobUpdate(job)
    }

    func jobApplied(job _: Job) {
        viewOutput?.jobApplied()
    }
}

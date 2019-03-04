import UIKit
import SwiftyJSON

@objc protocol JobSavedStatusUpdateDelegate {
    @objc optional func jobUpdate(job: Job)
    @objc optional func jobApplied(job: Job)
}

class DMJobDetailVC: DMBaseVC {
    @IBOutlet var tblJobDetail: UITableView!
    @IBOutlet var btnApplyForJob: UIButton!
    @IBOutlet weak var buttonTemplateView: UIView!
    @IBOutlet weak var bottomBtnConstainer: NSLayoutConstraint!
    var headerHeight: CGFloat = 49.0
    var jobDetailParams = [String: Any]()
    var job: Job?
    var isReadMore = false
    var isReadMoreOffice = false
    weak var delegate: JobSavedStatusUpdateDelegate?
    var fromTrack = false
    var fromCalender = false
    var fromNotificationVC = false
    var isTagExpanded: Bool = false
    
    var recruiterId: String?
    
    enum TableViewCellHeight: CGFloat {
        case jobTitle = 115.0
        case about = 190.0
        case jobDescAndOfficeDesc = 175.0
        case map = 199.0
    }
    
    var viewOutput: DMJobDetailViewOutput?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewOutput?.didLoad()
        setup()
        tblJobDetail.isHidden = true
        setBottomButtonHidden(true)
        viewOutput?.fetchJob(params: jobDetailParams)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if fromTrack {
            navigationItem.leftBarButtonItem = backBarButton()
            navigationController?.setNavigationBarHidden(false, animated: true)
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if fromTrack {
            navigationController?.setNavigationBarHidden(true, animated: true)
        }
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }

    // MARK: - Private Method
    
    private func setBottomButtonHidden(_ isHidden: Bool) {
        var bottomInset: CGFloat = 0
        
        if #available(iOS 11.0, *) {
            bottomInset += view.safeAreaInsets.bottom
        }
        
        btnApplyForJob.isHidden = isHidden
        buttonTemplateView.isHidden = isHidden
        bottomBtnConstainer.constant = isHidden ? btnApplyForJob.frame.height + bottomInset : 0
        
        DispatchQueue.main.async { [weak self] in
            self?.view.layoutIfNeeded()
        }
    }

    func setup() {
        title = Constants.ScreenTitleNames.jobDetails
        tblJobDetail.rowHeight = UITableView.automaticDimension
        tblJobDetail.register(UINib(nibName: "TempJobDetailCell", bundle: nil), forCellReuseIdentifier: "TempJobDetailCell")
        tblJobDetail.register(UINib(nibName: "DentistDetailCell", bundle: nil), forCellReuseIdentifier: "DentistDetailCell")
        tblJobDetail.register(UINib(nibName: "AboutCell", bundle: nil), forCellReuseIdentifier: "AboutCell")
        tblJobDetail.register(UINib(nibName: "JobDescriptionCell", bundle: nil), forCellReuseIdentifier: "JobDescriptionCell")
        tblJobDetail.register(UINib(nibName: "OfficeDescriptionCell", bundle: nil), forCellReuseIdentifier: "OfficeDescriptionCell")
        tblJobDetail.register(UINib(nibName: "WorkingHoursTableCell", bundle: nil), forCellReuseIdentifier: "WorkingHoursTableCell")
        tblJobDetail.register(UINib(nibName: "MapCell", bundle: nil), forCellReuseIdentifier: "MapCell")
        navigationItem.leftBarButtonItem = backBarButton()
        // if let params =  UserDefaultsManager.sharedInstance.loadSearchParameter() {
//            let latStr = params[Constants.JobDetailKey.lat] as! NSString
//            let longStr = params[Constants.JobDetailKey.lng] as! NSString
        jobDetailParams = [
            Constants.ServerKey.jobId: job?.jobId ?? 0,
        ]
        // }
    }

    // MARK: - @IBAction

    @IBAction func actionApplyForJob(_: UIButton) {
        viewOutput?.applyJob(params: jobDetailParams)
    }
}

extension DMJobDetailVC: DMJobDetailViewInput {
    
    func configureView(job: Job?, fromTrack: Bool, delegate: JobSavedStatusUpdateDelegate?) {
        self.job = job
        self.fromTrack = fromTrack
        self.delegate = delegate
    }
    
    func configureFetch(job: Job) {
        self.job = job
        
        /* For Job status
         INVITED = 1
         APPLIED = 2
         SHORTLISTED = 3
         HIRED = 4
         REJECTED = 5
         CANCELLED = 6
         */
        
        if job.isApplied == 1 || job.isApplied == 2 || job.isApplied == 3 || job.isApplied == 4 || job.isApplied == 5 {
            // Hide apply for job button
            btnApplyForJob.isUserInteractionEnabled = false
            setBottomButtonHidden(true)
            btnApplyForJob.setTitle(Constants.Strings.appliedForThisJob, for: .normal)
        } else {
            // If its temp job and cancelled
            if job.jobType == 3 {
                btnApplyForJob.isUserInteractionEnabled = false
                setBottomButtonHidden(true)
            } else {
                btnApplyForJob.isUserInteractionEnabled = true
                setBottomButtonHidden(false)
                btnApplyForJob.setTitle(Constants.Strings.applyForJob, for: .normal)
            }
        }
        tblJobDetail.isHidden = false
        tblJobDetail.reloadData()
    }
    
    func configureJobApply(response: JSON) {
        
        if response[Constants.ServerKey.status].boolValue {
            alertMessage(title: Constants.AlertMessage.congratulations, message: Constants.AlertMessage.jobApplied, buttonText: kOkButtonTitle, completionHandler: {
            })
            job?.isApplied = 2
            if let delegate = self.delegate {
                if fromTrack {
                    delegate.jobApplied!(job: job!)
                }
            }
            DispatchQueue.main.async { [weak self] in
                self?.setBottomButtonHidden(true)
                self?.btnApplyForJob.setTitle(Constants.Strings.appliedForThisJob, for: .normal)
                self?.tblJobDetail.reloadData()
            }
            //NotificationCenter.default.post(name: .refreshAppliedJobs, object: nil)
            
        } else {
            if response[Constants.ServerKey.statusCode].intValue == 200 {
                alertMessage(title: "", message: response[Constants.ServerKey.message].stringValue, buttonText: "Ok", completionHandler: {
                })
            } else {
                DispatchQueue.main.async {
                    kAppDelegate?.showOverlay(isJobSeekerVerified: true)
                }
            }
        }
    }
    
    func configureSaveUnsave(status: Int) {
        
        self.job?.isSaved = status
        if let delegate = self.delegate {
            delegate.jobUpdate!(job: self.job!)
        }
        DispatchQueue.main.async { [weak self] in
            self?.tblJobDetail.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .none)
        }
        NotificationCenter.default.post(name: .refreshSavedJobs, object: nil, userInfo: nil)
        NotificationCenter.default.post(name: .jobSavedUnsaved, object: self.job, userInfo: nil)
    }
}

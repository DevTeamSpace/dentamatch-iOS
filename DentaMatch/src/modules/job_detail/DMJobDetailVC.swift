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
    var isReadMore = false
    var isReadMoreOffice = false
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
        
        setup()
        tblJobDetail.isHidden = true
        setBottomButtonHidden(true)
        
        viewOutput?.didLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if viewOutput?.fromTrack == true {
            navigationItem.leftBarButtonItem = backBarButton()
            navigationController?.setNavigationBarHidden(false, animated: true)
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if viewOutput?.fromTrack == true {
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
    }

    // MARK: - @IBAction

    @IBAction func actionApplyForJob(_: UIButton) {
        viewOutput?.onBottomButtonTapped()
    }
}

extension DMJobDetailVC: DMJobDetailViewInput {
    
    func configureFetch(job: Job) {
        
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
            if job.jobType == 3, job.isApplied == 1, viewOutput?.notificationId != nil {
                btnApplyForJob.isUserInteractionEnabled = true
                setBottomButtonHidden(false)
                btnApplyForJob.setTitle(Constants.Strings.acceptJob, for: .normal)
                
            } else {
                
                btnApplyForJob.isUserInteractionEnabled = false
                setBottomButtonHidden(true)
                btnApplyForJob.setTitle(Constants.Strings.appliedForThisJob, for: .normal)
            }
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
    
    func configureJobApply() {
        DispatchQueue.main.async { [weak self] in
            self?.setBottomButtonHidden(true)
            self?.btnApplyForJob.setTitle(Constants.Strings.appliedForThisJob, for: .normal)
            self?.tblJobDetail.reloadData()
        }
    }
    
    func reloadRows(at indexPaths: [IndexPath]) {
        DispatchQueue.main.async { [weak self] in
            self?.tblJobDetail.reloadRows(at: indexPaths, with: .none)
        }
    }
}

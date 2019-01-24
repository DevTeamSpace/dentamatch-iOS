//
//  DMJobDetailVC.swift
//  DentaMatch
//
//  Created by Shailesh Tyagi on 20/01/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

@objc protocol JobSavedStatusUpdateDelegate {
    @objc optional func jobUpdate(job: Job)
    @objc optional func jobApplied(job: Job)
}

class DMJobDetailVC: DMBaseVC {
    @IBOutlet var tblJobDetail: UITableView!
    @IBOutlet var btnApplyForJob: UIButton!
    @IBOutlet var constraintBtnApplyJobHeight: NSLayoutConstraint!
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
    

    enum TableViewCellHeight: CGFloat {
        case jobTitle = 115.0
        case about = 190.0
        case jobDescAndOfficeDesc = 175.0
        case map = 199.0
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        tblJobDetail.isHidden = true
        btnApplyForJob.isHidden = true
        fetchJobAPI(params: jobDetailParams)
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
        applyJobAPI(params: jobDetailParams)
    }
}

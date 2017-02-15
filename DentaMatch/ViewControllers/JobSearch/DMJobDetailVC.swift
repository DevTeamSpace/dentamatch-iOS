//
//  DMJobDetailVC.swift
//  DentaMatch
//
//  Created by Shailesh Tyagi on 20/01/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

protocol JobSavedStatusUpdateDelegate {
    func jobUpdate(job:Job)
}

class DMJobDetailVC: DMBaseVC {
    
    @IBOutlet weak var tblJobDetail: UITableView!
    @IBOutlet weak var btnApplyForJob: UIButton!
    var headerHeight : CGFloat = 49.0
    var jobDetailParams = [String : Any]()
    var job:Job?
    var isReadMore = false
    var delegate:JobSavedStatusUpdateDelegate?
    var fromTrack = false
    @IBOutlet weak var constraintBtnApplyJobHeight: NSLayoutConstraint!
    
    enum TableViewCellHeight: CGFloat {
        case jobTitle = 115.0
        case about = 190.0
        case jobDescAndOfficeDesc = 175.0
        case map = 199.0
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
        self.tblJobDetail.isHidden = true
        self.btnApplyForJob.isHidden = true
        self.fetchJobAPI(params: jobDetailParams)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if fromTrack {
            self.navigationItem.leftBarButtonItem = self.backBarButton()
            self.navigationController?.setNavigationBarHidden(false, animated: true)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if fromTrack {
            self.navigationController?.setNavigationBarHidden(true, animated: true)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    //MARK :- Private Method
    
    func setup() {
        self.title = Constants.ScreenTitleNames.jobDetails
        self.tblJobDetail.rowHeight = UITableViewAutomaticDimension
        self.tblJobDetail.register(UINib(nibName: "DentistDetailCell", bundle: nil), forCellReuseIdentifier: "DentistDetailCell")
        self.tblJobDetail.register(UINib(nibName: "AboutCell", bundle: nil), forCellReuseIdentifier: "AboutCell")
        self.tblJobDetail.register(UINib(nibName: "JobDescriptionCell", bundle: nil), forCellReuseIdentifier: "JobDescriptionCell")
        self.tblJobDetail.register(UINib(nibName: "OfficeDescriptionCell", bundle: nil), forCellReuseIdentifier: "OfficeDescriptionCell")
        self.tblJobDetail.register(UINib(nibName: "MapCell", bundle: nil), forCellReuseIdentifier: "MapCell")
        self.navigationItem.leftBarButtonItem = self.backBarButton()
        jobDetailParams = [
            Constants.ServerKey.jobId:job?.jobId ?? 0
        ]
    }
    
    //MARK:- @IBAction
    
    @IBAction func actionApplyForJob(_ sender: UIButton) {
        self.applyJobAPI(params: jobDetailParams)
    }
    
}

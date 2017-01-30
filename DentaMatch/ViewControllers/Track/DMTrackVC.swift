//
//  DMTrackVC.swift
//  DentaMatch
//
//  Created by Sanjay Kumar Yadav on 22/01/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

class DMTrackVC: DMBaseVC {

    enum SegmentControlOption:Int {
        case saved
        case applied
        case shortlisted
    }
    
    let savedJobs = [Job]()
    let appliedJobs = [Job]()
    let shortListedJobs = [Job]()
    
    @IBOutlet weak var segmentedControl: CustomSegmentControl!
    override func viewDidLoad() {
        super.viewDidLoad()
        let params = [
            "type":"1",
            "page":"1",
            "lat":"\(UserManager.shared().activeUser.latitude!)",
            "lng":"\(UserManager.shared().activeUser.longitude!)"
        ]
        self.getJobList(params: params)
        setup()
        // Do any additional setup after loading the view.
    }
    
    func setup() {
    
    }

    @IBAction func segmentControlValueChanged(_ sender: UISegmentedControl) {
        let segmentControlOptions = SegmentControlOption(rawValue: sender.selectedSegmentIndex)!
        
        switch segmentControlOptions {
            
        case .saved:
            print("saved")
        case .applied:
            print("applied")
        case .shortlisted:
            print("shortlisted")
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

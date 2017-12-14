//
//  DMJobTitleVC.swift
//  DentaMatch
//
//  Created by Shailesh Tyagi on 11/01/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit
import SwiftyJSON

@objc protocol DMJobTitleVCDelegate {
    @objc optional func setSelectedJobType(jobTitles : [JobTitle])
    @objc optional func setSelectedPreferredLocations(preferredLocations : [PreferredLocation])
}

class DMJobTitleVC: DMBaseVC {
    
    @IBOutlet weak var headingLabel: UILabel!
    @IBOutlet weak var tblJobTitle: UITableView!
    var jobTitles = [JobTitle]()
    var selectedJobs = [JobTitle]()
    var preferredLocations = [PreferredLocation]()
    var selectedPreferredLocations = [PreferredLocation]()
    var rightBarBtn : UIButton = UIButton()
    var rightBarButtonItem : UIBarButtonItem = UIBarButtonItem()
    var cellHeight : CGFloat = 56.0
    var rightBarButtonWidth : CGFloat = 40.0
    var forPreferredLocations = false
    weak var delegate : DMJobTitleVCDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUp()
        if forPreferredLocations {
            self.headingLabel.text = "You can select more than one location"
            self.getPreferredJobs()
        } else {
            self.headingLabel.text = "You can select more than one job title"
            self.getJobsAPI()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc override func actionRightNavigationItem() {
        if forPreferredLocations {
            self.selectedPreferredLocations.removeAll()
            self.selectedPreferredLocations = self.preferredLocations.filter({$0.isSelected})
            if selectedPreferredLocations.count == 0 {
                self.makeToast(toastString: Constants.AlertMessage.selectPreferredLocation)
                return
            }
            delegate?.setSelectedPreferredLocations!(preferredLocations: self.selectedPreferredLocations)
            _ = self.navigationController?.popViewController(animated: true)
            
        } else {
            self.selectedJobs.removeAll()
            for objTitle in self.jobTitles {
                if objTitle.jobSelected == true {
                    self.selectedJobs.append(objTitle)
                }
            }
            if self.selectedJobs.count == 0 {
                makeToast(toastString: Constants.AlertMessage.selectTitle)
            }
            else {
                _ =  self.navigationController?.popViewController(animated: true)
                delegate?.setSelectedJobType!(jobTitles: self.selectedJobs)
            }
        }
    }
    
    //MARK : Private Method
    func setUp() {
        if forPreferredLocations {
            self.title = "PREFERRED LOCATIONS"
        } else {
            self.title = Constants.ScreenTitleNames.jobTitle
        }
        self.tblJobTitle.rowHeight = UITableViewAutomaticDimension
        self.tblJobTitle.register(UINib(nibName: "JobTitleCell", bundle: nil), forCellReuseIdentifier: "JobTitleCell")
        self.navigationItem.leftBarButtonItem = self.backBarButton()
        self.setRightBarButton(title: Constants.Strings.save, imageName : "" ,width : rightBarButtonWidth, font : UIFont.fontRegular(fontSize: 16.0)!)
    }
    
}

extension DMJobTitleVC : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if forPreferredLocations {
            return preferredLocations.count
        }
        return jobTitles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "JobTitleCell") as! JobTitleCell
        cell.selectionStyle = .none
        cell.lblJobTitle.textColor = Constants.Color.jobSearchSelectedLabel
        if forPreferredLocations {
            let preferredLocation = preferredLocations[indexPath.row]
            cell.lblJobTitle.text = preferredLocation.preferredLocationName
            if preferredLocation.isSelected == true {
                cell.btnTick.setTitle(Constants.DesignFont.acceptTermsSelected, for: .normal)
                cell.btnTick.setTitleColor(Constants.Color.tickSelectColor, for: .normal)
            }
            else {
                cell.btnTick.setTitle(Constants.DesignFont.acceptTermsDeSelected, for: .normal)
                cell.btnTick.setTitleColor(Constants.Color.tickDeselectColor, for: .normal)
            }
        } else {
            let objJob = jobTitles[indexPath.row]
            cell.lblJobTitle.text = objJob.jobTitle
            if objJob.jobSelected == true {
                cell.btnTick.setTitle(Constants.DesignFont.acceptTermsSelected, for: .normal)
                cell.btnTick.setTitleColor(Constants.Color.tickSelectColor, for: .normal)
            }
            else {
                cell.btnTick.setTitle(Constants.DesignFont.acceptTermsDeSelected, for: .normal)
                cell.btnTick.setTitleColor(Constants.Color.tickDeselectColor, for: .normal)
            }
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as? JobTitleCell
        
        if forPreferredLocations {
            let preferredLocation = preferredLocations[indexPath.row]
            if preferredLocation.isSelected == false {
                preferredLocation.isSelected = true
                cell?.btnTick.setTitle(Constants.DesignFont.acceptTermsSelected, for: .normal)
                cell?.btnTick.setTitleColor(Constants.Color.tickSelectColor, for: .normal)
            }
            else {
                preferredLocation.isSelected = false
                cell?.btnTick.setTitle(Constants.DesignFont.acceptTermsDeSelected, for: .normal)
                cell?.btnTick.setTitleColor(Constants.Color.tickDeselectColor, for: .normal)
            }
        } else {
            let objJob = jobTitles[indexPath.row]
            if objJob.jobSelected == false {
                objJob.jobSelected = true
                cell?.btnTick.setTitle(Constants.DesignFont.acceptTermsSelected, for: .normal)
                cell?.btnTick.setTitleColor(Constants.Color.tickSelectColor, for: .normal)
            }
            else {
                objJob.jobSelected = false
                cell?.btnTick.setTitle(Constants.DesignFont.acceptTermsDeSelected, for: .normal)
                cell?.btnTick.setTitleColor(Constants.Color.tickDeselectColor, for: .normal)
            }
        }
        
        
    }
}

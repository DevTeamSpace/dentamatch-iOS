//
//  DMJobTitleVC.swift
//  DentaMatch
//
//  Created by Shailesh Tyagi on 11/01/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import SwiftyJSON
import UIKit

protocol DMJobTitleVCDelegate: class {
    func setSelectedJobType(jobTitles: [JobTitle])
    func setSelectedPreferredLocations(preferredLocations: [PreferredLocation])
}

class DMJobTitleVC: DMBaseVC {
    @IBOutlet var headingLabel: UILabel!
    @IBOutlet var tblJobTitle: UITableView!
    
    var rightBarBtn: UIButton = UIButton()
    var rightBarButtonItem: UIBarButtonItem = UIBarButtonItem()
    var cellHeight: CGFloat = 56.0
    var rightBarButtonWidth: CGFloat = 40.0
    weak var delegate: DMJobTitleVCDelegate?
    
    var viewOutput: DMJobTitleViewOutput?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        setUp()
        viewOutput?.didLoad()
    }
    
    @objc override func actionRightNavigationItem() {
        viewOutput?.onRightNavigationItemTap()
    }

    func setUp() {
        tblJobTitle.rowHeight = UITableView.automaticDimension
        tblJobTitle.register(UINib(nibName: "JobTitleCell", bundle: nil), forCellReuseIdentifier: "JobTitleCell")
        navigationItem.leftBarButtonItem = backBarButton()
        setRightBarButton(title: Constants.Strings.save, imageName: "", width: rightBarButtonWidth, font: UIFont.fontRegular(fontSize: 16.0))
    }
}

extension DMJobTitleVC: DMJobTitleViewInput {
    
    func configureTitle(_ title: String, headingText: String) {
        
        self.title = title
        headingLabel.text = headingText
    }
    
    func reloadData() {
        
        tblJobTitle.reloadData()
    }
}

extension DMJobTitleVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return viewOutput?.forPreferredLocations == true ? viewOutput?.preferredLocations.count ?? 0 : viewOutput?.jobTitles.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let viewOutput = viewOutput else { return UITableViewCell() }
        let cell = tableView.dequeueReusableCell(withIdentifier: "JobTitleCell") as! JobTitleCell
        cell.selectionStyle = .none
        cell.lblJobTitle.textColor = Constants.Color.jobSearchSelectedLabel
        
        if viewOutput.forPreferredLocations == true {
            let preferredLocation = viewOutput.preferredLocations[indexPath.row]
            cell.lblJobTitle.text = preferredLocation.preferredLocationName
            
            if preferredLocation.isSelected == true {
                cell.btnTick.setTitle(Constants.DesignFont.acceptTermsSelected, for: .normal)
                cell.btnTick.setTitleColor(Constants.Color.tickSelectColor, for: .normal)
            } else {
                cell.btnTick.setTitle(Constants.DesignFont.acceptTermsDeSelected, for: .normal)
                cell.btnTick.setTitleColor(Constants.Color.tickDeselectColor, for: .normal)
            }
        } else {
            let objJob = viewOutput.jobTitles[indexPath.row]
            cell.lblJobTitle.text = objJob.jobTitle
            if objJob.jobSelected == true {
                cell.btnTick.setTitle(Constants.DesignFont.acceptTermsSelected, for: .normal)
                cell.btnTick.setTitleColor(Constants.Color.tickSelectColor, for: .normal)
            } else {
                cell.btnTick.setTitle(Constants.DesignFont.acceptTermsDeSelected, for: .normal)
                cell.btnTick.setTitleColor(Constants.Color.tickDeselectColor, for: .normal)
            }
        }

        return cell
    }

    func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_: UITableView, estimatedHeightForRowAt _: IndexPath) -> CGFloat {
        return cellHeight
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as? JobTitleCell

        if viewOutput?.forPreferredLocations == true {
            
            if viewOutput?.preferredLocations[indexPath.row].isSelected == false {
                viewOutput?.preferredLocations[indexPath.row].isSelected = true
                cell?.btnTick.setTitle(Constants.DesignFont.acceptTermsSelected, for: .normal)
                cell?.btnTick.setTitleColor(Constants.Color.tickSelectColor, for: .normal)
            } else {
                viewOutput?.preferredLocations[indexPath.row].isSelected = false
                cell?.btnTick.setTitle(Constants.DesignFont.acceptTermsDeSelected, for: .normal)
                cell?.btnTick.setTitleColor(Constants.Color.tickDeselectColor, for: .normal)
            }
        } else {
            
            if viewOutput?.jobTitles[indexPath.row].jobSelected == false {
                viewOutput?.jobTitles[indexPath.row].jobSelected = true
                cell?.btnTick.setTitle(Constants.DesignFont.acceptTermsSelected, for: .normal)
                cell?.btnTick.setTitleColor(Constants.Color.tickSelectColor, for: .normal)
            } else {
                viewOutput?.jobTitles[indexPath.row].jobSelected = false
                cell?.btnTick.setTitle(Constants.DesignFont.acceptTermsDeSelected, for: .normal)
                cell?.btnTick.setTitleColor(Constants.Color.tickDeselectColor, for: .normal)
            }
        }
    }
}

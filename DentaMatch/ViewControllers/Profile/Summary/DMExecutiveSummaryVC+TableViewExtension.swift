//
//  DMExecutiveSummaryVC+TableViewExtension.swift
//  DentaMatch
//
//  Created by Rajan Maheshwari on 10/01/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import Foundation

extension DMExecutiveSummaryVC : UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let executiveSummaryOption = ExecutiveSummary(rawValue: indexPath.section)!
        
        switch executiveSummaryOption {
        case .profileHeader:
            return 213
        case .aboutMe:
            return 256
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let executiveSummaryOption = ExecutiveSummary(rawValue: indexPath.section)!
        
        switch executiveSummaryOption {
            
        case .profileHeader:
            let cell = tableView.dequeueReusableCell(withIdentifier: "PhotoNameCell") as! PhotoNameCell
            cell.nameLabel.text = "Executive Summary"
            cell.jobTitleLabel.text = "Describe about your work and things you are passionate about."
            cell.photoButton.progressBar.setProgress(profileProgress, animated: true)
            return cell
            
        case .aboutMe:
            let cell = tableView.dequeueReusableCell(withIdentifier: "AboutMeCell") as! AboutMeCell
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

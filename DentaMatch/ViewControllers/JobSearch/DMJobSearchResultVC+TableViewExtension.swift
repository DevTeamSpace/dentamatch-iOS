//
//  DMJobSearchResult+TableViewExtension.swift
//  DentaMatch
//
//  Created by Shailesh Tyagi on 30/01/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import Foundation

extension DMJobSearchResultVC : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.jobs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "JobSearchResultCell") as! JobSearchResultCell
        let objJob = jobs[indexPath.row]
        cell.setCellData(job: objJob)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let jobDetailVC = UIStoryboard.jobSearchStoryBoard().instantiateViewController(type: DMJobDetailVC.self)!
        self.navigationController?.pushViewController(jobDetailVC, animated: true)
    }
}

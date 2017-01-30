//
//  DMCalenderVC+TableViewExtension.swift
//  DentaMatch
//
//  Created by Sanjay Kumar Yadav on 30/01/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import Foundation

extension DMCalenderVC:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SectionHeadingTableCell") as? SectionHeadingTableCell
            cell?.headingLabel.text = "BOOKED JOBS"
            return cell!
        }
        return UITableViewCell()
    }
}

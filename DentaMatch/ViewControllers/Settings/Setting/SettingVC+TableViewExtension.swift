//
//  SettingVC+TableViewExtension.swift
//  DentaMatch
//
//  Created by Sanjay Kumar Yadav on 20/01/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import Foundation

extension SettingVC : UITableViewDataSource,UITableViewDelegate {
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 58
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingTableCell") as! SettingTableCell
        cell.selectionStyle = .none
        switch indexPath.row {
        case 0:
            cell.TextLabel.text = "Change Home Location"
        case 1:
            cell.TextLabel.text = "Reset Password"
        case 2:
            cell.TextLabel.text = "Terms & Conditions"
        case 3:
            cell.TextLabel.text = "Privacy Policy"
        case 4:
            cell.TextLabel.text = " Logout"
        default: break
            
        }
        return cell
    }
    
}

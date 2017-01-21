//
//  DMSettingVC+TableViewExtension.swift
//  DentaMatch
//
//  Created by Sanjay Kumar Yadav on 21/01/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import Foundation

extension DMSettingVC : UITableViewDataSource,UITableViewDelegate {
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
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
            cell.leftIconLabel.text = "d"
        case 1:
            cell.TextLabel.text = "Reset Password"
            cell.leftIconLabel.text = "e"
        case 2:
            cell.TextLabel.text = "Terms & Conditions"
            cell.leftIconLabel.text = "i"

        case 3:
            cell.TextLabel.text = "Privacy Policy"
            cell.leftIconLabel.text = "i"
        case 4:
            cell.TextLabel.text = " Logout"
            cell.leftIconLabel.text = "i"

        default: break
            
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            break
        case 1:
            self.performSegue(withIdentifier: Constants.StoryBoard.SegueIdentifier.goToChangePassword, sender: self)
        case 2:
            break
        case 3:
            break
        case 4:
            //logout
            openLogin()
            break
        default: break
            
        }
        
    }
    func openLogin() {
        
        UserManager.shared().deleteActiveUser()
        let registrationContainer = UIStoryboard.registrationStoryBoard().instantiateViewController(withIdentifier: Constants.StoryBoard.Identifer.registrationNav) as! UINavigationController
        
        UIView.transition(with: self.view.window!, duration: 0.25, options: .transitionCrossDissolve, animations: {
            kAppDelegate.window?.rootViewController = registrationContainer
        }) { (bool:Bool) in
            //completion
        }
        
    }
    
}

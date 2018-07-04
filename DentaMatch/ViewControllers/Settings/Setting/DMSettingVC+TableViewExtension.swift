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
        //Made preferred job cell to hide
        if indexPath.row == 0 {
            return 0
        }
        return 60
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingTableCell") as! SettingTableCell
        cell.selectionStyle = .none
        cell.leftIconImageView.isHidden = true
        cell.leftIconImageView.contentMode = .scaleAspectFill
        switch indexPath.row {
        case 0:
            cell.TextLabel.text = "Preferred Job Location"
            cell.leftIconLabel.text = ""
            cell.leftIconImageView.image = UIImage(named: "preferredLocationIcon")
            cell.leftIconImageView.isHidden = false

        case 1:
            cell.TextLabel.text = "Reset Password"
            cell.leftIconLabel.font = UIFont.designFont(fontSize: 19.0)
            cell.leftIconLabel.text = "e"
            cell.leftConstraintLabel.constant = 18
        case 2:
            cell.TextLabel.text = "Terms & Conditions"
            cell.leftIconLabel.text = "i"

        case 3:
            cell.TextLabel.text = "Privacy Policy"
            cell.leftIconLabel.text = "i"
        case 4:
            cell.TextLabel.text = "Logout"
            cell.leftIconLabel.text = ""
            cell.leftIconImageView.image = UIImage(named: "logOut")
            cell.leftIconImageView.isHidden = false


        default: break
            
        }
        cell.contentView.layoutIfNeeded()
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            let mapVC = UIStoryboard.registrationStoryBoard().instantiateViewController(type: DMRegisterMapsVC.self)!
            mapVC.fromSettings = true
            mapVC.delegate = self
            self.navigationController?.pushViewController(mapVC, animated: true)
        case 1:
            self.performSegue(withIdentifier: Constants.StoryBoard.SegueIdentifier.goToChangePassword, sender: self)
        case 2:
            let termsVC = UIStoryboard.registrationStoryBoard().instantiateViewController(type: DMTermsAndConditionsVC.self)!
            termsVC.isPrivacyPolicy = false
            self.navigationController?.pushViewController(termsVC, animated: true)
        case 3:
            let termsVC = UIStoryboard.registrationStoryBoard().instantiateViewController(type: DMTermsAndConditionsVC.self)!
            termsVC.isPrivacyPolicy = true
            self.navigationController?.pushViewController(termsVC, animated: true)
        case 4:
            //logout
            openLogin()
            break
        default: break
            
        }
        
    }
    func openLogin() {
        
        signOut { (check, error) in
            
            if check == true {
//                MixpanelOperations.trackMixpanelEvent(eventName: "Logout")
                MixpanelOperations.mixpanepanelLogout()

                self.deleteFetchController()
                SocketManager.sharedInstance.closeConnection()
                UserManager.shared().deleteActiveUser()
                UserDefaultsManager.sharedInstance.clearCache()
                let registrationContainer = UIStoryboard.registrationStoryBoard().instantiateViewController(withIdentifier: Constants.StoryBoard.Identifer.registrationNav) as! UINavigationController
                UserDefaultsManager.sharedInstance.isLoggedOut = true
                UIView.transition(with: self.view.window!, duration: 0.25, options: .transitionCrossDissolve, animations: {
                    kAppDelegate.window?.rootViewController = registrationContainer
                }) { (bool:Bool) in
                    //completion
                    DatabaseManager.clearDB()
                }

            }
            
        }
    }
    
    func deleteFetchController() {
        NotificationCenter.default.post(name: .deleteFetchController, object: nil)
    }
}

//MARK:- LocationAddress Delegate
extension DMSettingVC:LocationAddressDelegate {
    func locationAddress(location: Location) {
        if let address = location.address {
            //debugPrint(address)
            UserManager.shared().activeUser.preferredJobLocation = address
            UserManager.shared().activeUser.zipCode = location.postalCode
            UserManager.shared().activeUser.state = location.state
            UserManager.shared().activeUser.city = location.city
            UserManager.shared().activeUser.country = location.country
            UserManager.shared().activeUser.latitude = "\(location.coordinateSelected!.latitude)"
            UserManager.shared().activeUser.longitude = "\(location.coordinateSelected!.longitude)"
            UserManager.shared().saveActiveUser()
        } else {
            //debugPrint("Address is empty")
        }
    }
}


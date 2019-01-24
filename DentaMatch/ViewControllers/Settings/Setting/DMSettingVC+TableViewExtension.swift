//
//  DMSettingVC+TableViewExtension.swift
//  DentaMatch
//
//  Created by Sanjay Kumar Yadav on 21/01/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import Foundation

extension DMSettingVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // Made preferred job cell to hide
        if indexPath.row == 0 {
            return 0
        }
        return 60
    }

    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return 5
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingTableCell") as! SettingTableCell
        cell.selectionStyle = .none
        cell.leftIconImageView.isHidden = true
        cell.leftIconImageView.contentMode = .scaleAspectFill
        switch indexPath.row {
        case 0:
            cell.TextLabel.text = "Looking for Jobs In"
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

    func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            if let mapVC = DMRegisterMapsInitializer.initialize() as? DMRegisterMapsVC {
                mapVC.fromSettings = true
                mapVC.delegate = self
                navigationController?.pushViewController(mapVC, animated: true)
            }
        case 1:
            performSegue(withIdentifier: Constants.StoryBoard.SegueIdentifier.goToChangePassword, sender: self)
        case 2:
            if let vc = DMTermsAndConditionsInitializer.initialize() as? DMTermsAndConditionsVC {
                vc.isPrivacyPolicy = false
                navigationController?.pushViewController(vc, animated: true)
            }
        case 3:
            if let vc = DMTermsAndConditionsInitializer.initialize() as? DMTermsAndConditionsVC {
                vc.isPrivacyPolicy = true
                navigationController?.pushViewController(vc, animated: true)
            }
        case 4:
            // logout
            self.alertMessage(title: "Logout", message: "Are you sure you want to logout?", leftButtonText: "Yes", rightButtonText: "No", completionHandler: { [weak self](isLeft: Bool) in
                if isLeft {
                  self?.openLogin()
                }
            })
            
            break
        default: break
        }
    }

    func openLogin() {
        signOut { check, _ in

            if check == true {
                AppDelegate.delegate().resetBadgeCount()
                MixpanelOperations.mixpanepanelLogout()
                self.deleteFetchController()
                SocketManager.sharedInstance.closeConnection()
                UserManager.shared().deleteActiveUser()
                UserDefaultsManager.sharedInstance.clearCache()
                
                let navController = UINavigationController(rootViewController: DMRegistrationContainerInitializer.initialize())
                navController.setNavigationBarHidden(true, animated: false)
                
                UserDefaultsManager.sharedInstance.isLoggedOut = true
                UIView.transition(with: self.view.window!, duration: 0.25, options: .transitionCrossDissolve, animations: {
                    kAppDelegate?.window?.rootViewController = navController
                }) { (_: Bool) in
                    // completion
                    DatabaseManager.clearDB()
                }
            }
        }
    }

    func deleteFetchController() {
        NotificationCenter.default.post(name: .deleteFetchController, object: nil)
    }
}

// MARK: - LocationAddress Delegate

extension DMSettingVC: LocationAddressDelegate {
    func locationAddress(location: Location) {
        if let address = location.address {
            // debugPrint(address)
            UserManager.shared().activeUser.preferredJobLocation = address
            UserManager.shared().activeUser.zipCode = location.postalCode
            UserManager.shared().activeUser.state = location.state
            UserManager.shared().activeUser.city = location.city
            UserManager.shared().activeUser.country = location.country
            UserManager.shared().activeUser.latitude = "\(location.coordinateSelected!.latitude)"
            UserManager.shared().activeUser.longitude = "\(location.coordinateSelected!.longitude)"
            UserManager.shared().saveActiveUser()
        } else {
            // debugPrint("Address is empty")
        }
    }
}

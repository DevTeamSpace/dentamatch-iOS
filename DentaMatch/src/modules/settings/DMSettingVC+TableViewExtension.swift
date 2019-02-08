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
            viewOutput?.openRegisterMaps(delegate: self)
        case 1:
            viewOutput?.openResetPassword()
        case 2:
            viewOutput?.openTermsAndConditions(isPrivacyPolicy: false)
        case 3:
            viewOutput?.openTermsAndConditions(isPrivacyPolicy: true)
        case 4:
            // logout
            self.alertMessage(title: "Logout", message: "Are you sure you want to logout?", leftButtonText: "Yes", rightButtonText: "No", completionHandler: { [weak self] (isLeft: Bool) in
                if isLeft {
                  self?.viewOutput?.signOut()
                }
            })
            
            break
        default: break
        }
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

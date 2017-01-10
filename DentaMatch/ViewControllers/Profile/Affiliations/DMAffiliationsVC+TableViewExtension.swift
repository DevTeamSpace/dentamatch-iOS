//
//  DMAffiliationsVC+TableViewExtension.swift
//  DentaMatch
//
//  Created by Rajan Maheshwari on 10/01/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import Foundation

extension DMAffiliationsVC : UITableViewDataSource,UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let affiliationOption = Affiliations(rawValue: section)!
        
        switch affiliationOption {
        case .profileHeader:
            return 2
            
        case .affiliation:
            return 4
            
        case .affiliationOther:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let affiliationOption = Affiliations(rawValue: indexPath.section)!
        
        switch affiliationOption {
            
        case .profileHeader:
            switch indexPath.row {
            case 0:
                return 213
            case 1:
                return 46
            default:
                return 0
            }
            
        case .affiliation:
            return 56
            
        case .affiliationOther:
            let returnValue = isOtherSelected ? 186: 54
            return CGFloat(returnValue)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let affiliationOption = Affiliations(rawValue: indexPath.section)!
        
        switch affiliationOption {
            
        case .profileHeader:
            switch indexPath.row {
                
            case 0:
                let cell = tableView.dequeueReusableCell(withIdentifier: "PhotoNameCell") as! PhotoNameCell
                cell.nameLabel.text = "Affiliations"
                cell.jobTitleLabel.text = "Lorem Ipsum is simply dummy text for the typing and printing industry"
                cell.photoButton.progressBar.setProgress(profileProgress, animated: true)
                return cell
                
            case 1:
                let cell = tableView.dequeueReusableCell(withIdentifier: "SectionHeadingTableCell") as! SectionHeadingTableCell
                cell.headingLabel.text = "PROFESSIONAL AFFILIATIONS"
                return cell
                
            default:
                return UITableViewCell()
            }
            
        case .affiliation:
            let cell = tableView.dequeueReusableCell(withIdentifier: "AffiliationsCell") as! AffiliationsCell
            return cell
            
        case .affiliationOther:
            let cell = tableView.dequeueReusableCell(withIdentifier: "AffliliationsOthersCell") as! AffliliationsOthersCell
            cell.tickButton.isEnabled = false
            if isOtherSelected {
                cell.tickButton.setTitle(Constants.DesignFont.acceptTermsSelected, for: .normal)
                cell.tickButton.setTitleColor(Constants.Color.textFieldColorSelected, for: .normal)
            } else {
                cell.tickButton.setTitle(Constants.DesignFont.acceptTermsDeSelected, for: .normal)
                cell.tickButton.setTitleColor(Constants.Color.textFieldPlaceHolderColor, for: .normal)

            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let affiliationOption = Affiliations(rawValue: indexPath.section)!

        switch affiliationOption {
        case .affiliation:
            print("select affiliation")
            
        case .affiliationOther:
            isOtherSelected = isOtherSelected ? false:true
            self.affiliationsTableView.reloadSections(IndexSet(integer: affiliationOption.rawValue), with: .automatic)
            DispatchQueue.main.async {
                self.affiliationsTableView.scrollToRow(at: IndexPath(row: 0, section: affiliationOption.rawValue), at: .bottom, animated: true)
            }
        default:
            break
        }
    }
}

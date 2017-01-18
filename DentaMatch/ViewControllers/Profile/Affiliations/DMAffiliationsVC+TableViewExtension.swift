//
//  DMAffiliationsVC+TableViewExtension.swift
//  DentaMatch
//
//  Created by Rajan Maheshwari on 10/01/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import Foundation

extension DMAffiliationsVC : UITableViewDataSource,UITableViewDelegate,UITextViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let affiliationOption = Affiliations(rawValue: section)!
        
        switch affiliationOption {
        case .profileHeader:
            return 2
            
        case .affiliation:
            return affiliations.count - 1
            
        case .affiliationOther:
            if affiliations.count > 0 {
                return 1
            } else {
                return 0
            }
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
            let affiliation = affiliations[affiliations.count - 1]
            let returnValue = affiliation.isSelected ? 186: 54
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
                if let imageURL = URL(string: UserManager.shared().activeUser.profileImageURL!) {
                    cell.photoButton.sd_setImage(with: imageURL, for: .normal, placeholderImage: kPlaceHolderImage)
                }
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
            let affiliation = affiliations[indexPath.row]
            cell.affiliationLabel.text = affiliation.affiliationName
            if affiliation.isSelected {
                cell.tickButton.setTitle(Constants.DesignFont.acceptTermsSelected, for: .normal)
                cell.tickButton.setTitleColor(Constants.Color.textFieldColorSelected, for: .normal)
            } else {
                cell.tickButton.setTitle(Constants.DesignFont.acceptTermsDeSelected, for: .normal)
                cell.tickButton.setTitleColor(Constants.Color.textFieldPlaceHolderColor, for: .normal)
                
            }
            
            return cell
            
        case .affiliationOther:
            let cell = tableView.dequeueReusableCell(withIdentifier: "AffliliationsOthersCell") as! AffliliationsOthersCell
            let affiliation = affiliations[affiliations.count - 1]
            cell.tickButton.isEnabled = false
            cell.otherAffiliationTextView.delegate = self
            cell.otherAffiliationTextView.inputAccessoryView = self.addToolBarOnTextView()
            if affiliation.isSelected {
                cell.otherAffiliationTextView.text = affiliation.otherAffiliation
                otherText = affiliation.affiliationName
                cell.tickButton.setTitle(Constants.DesignFont.acceptTermsSelected, for: .normal)
                cell.tickButton.setTitleColor(Constants.Color.textFieldColorSelected, for: .normal)
            } else {
                cell.otherAffiliationTextView.text = ""
                otherText = ""
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
            affiliations[indexPath.row].isSelected = affiliations[indexPath.row].isSelected ? false : true
            DispatchQueue.main.async {
                self.affiliationsTableView.reloadRows(at: [indexPath], with: .automatic)
            }
            
        case .affiliationOther:
            affiliations[affiliations.count - 1].isSelected = affiliations[affiliations.count - 1].isSelected ? false : true
            isOtherSelected = affiliations[affiliations.count - 1].isSelected
            self.affiliationsTableView.reloadSections(IndexSet(integer: affiliationOption.rawValue), with: .automatic)
            DispatchQueue.main.async {
                self.affiliationsTableView.scrollToRow(at: IndexPath(row: 0, section: affiliationOption.rawValue), at: .bottom, animated: true)
            }
        default:
            break
        }
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        
        self.affiliationsTableView.contentInset =  UIEdgeInsetsMake(0, 0, 200, 0)
        DispatchQueue.main.async {
            self.affiliationsTableView.scrollToRow(at: IndexPath(row: 0, section: 2), at: .bottom, animated: true)
        }
        return true
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        self.affiliationsTableView.contentInset =  UIEdgeInsetsMake(0, 0, 0, 0)

        return true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        let affiliation = affiliations[affiliations.count - 1]
        affiliation.otherAffiliation = textView.text!
        otherText = textView.text
    }
}

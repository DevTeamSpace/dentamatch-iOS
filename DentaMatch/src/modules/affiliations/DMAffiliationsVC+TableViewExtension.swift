//
//  DMAffiliationsVC+TableViewExtension.swift
//  DentaMatch
//
//  Created by Rajan Maheshwari on 10/01/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import Foundation

extension DMAffiliationsVC: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in _: UITableView) -> Int {
        return 2
    }

    func tableView(_: UITableView, numberOfRowsInSection section: Int) -> Int {
        let affiliationOption = Affiliations(rawValue: section)!

        switch affiliationOption {
        case .profileHeader:
            if isEditMode {
                return 0
            }
            return 2

        case .affiliation:
            return affiliations.count

        case .affiliationOther:
            if affiliations.count > 0 {
                return 1
            } else { return 0 }
        }
    }

    func tableView(_: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let affiliationOption = Affiliations(rawValue: indexPath.section)!

        switch affiliationOption {
        case .profileHeader:
            switch indexPath.row {
            case 0:
                if isEditMode {
                    return 0
                }

                return 213
            case 1:
                if isEditMode {
                    return 0
                }
                return 46
            default:
                return 0
            }

        case .affiliation:
            let affiliation = affiliations[indexPath.row]
            if affiliation.affiliationId == "9" {
                let returnValue = affiliation.isSelected ? 186 : 54
                return CGFloat(returnValue)
            }

            return 56

        case .affiliationOther:
            let affiliation = affiliations[affiliations.count - 1]
            let returnValue = affiliation.isSelected ? 186 : 54
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
                    cell.photoButton.setImage(for: .normal, url: imageURL, placeholder: kPlaceHolderImage)
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
            // debugPrint("affiliationName:-  \(affiliation.affiliationName)")
            cell.affiliationLabel.text = affiliation.affiliationName
            if affiliation.isSelected {
                cell.tickButton.setTitle(Constants.DesignFont.acceptTermsSelected, for: .normal)
                cell.tickButton.setTitleColor(Constants.Color.textFieldColorSelected, for: .normal)
            } else {
                cell.tickButton.setTitle(Constants.DesignFont.acceptTermsDeSelected, for: .normal)
                cell.tickButton.setTitleColor(Constants.Color.textFieldPlaceHolderColor, for: .normal)
            }
            if affiliation.affiliationId == "9" {
                let cell = tableView.dequeueReusableCell(withIdentifier: "AffliliationsOthersCell") as! AffliliationsOthersCell
//                //debugPrint("affiliationName Other:-  \(String(describing: affiliation.otherAffiliation))")
                cellSetpUpForOther(cell: cell, indexPath: indexPath)
                return cell
            }

            return cell

        case .affiliationOther:
            let cell = tableView.dequeueReusableCell(withIdentifier: "AffliliationsOthersCell") as! AffliliationsOthersCell
            let affiliation = affiliations[affiliations.count - 1]
            cell.tickButton.isEnabled = false
            cell.otherAffiliationTextView.delegate = self
            cell.otherAffiliationTextView.inputAccessoryView = addToolBarOnTextView()
            // debugPrint("affiliationName Other:-  \(String(describing: affiliation.otherAffiliation))")

            if affiliation.isSelected {
                cell.otherAffiliationTextView.text = affiliation.otherAffiliation
                otherText = affiliation.otherAffiliation!
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

    func cellSetpUpForOther(cell: AffliliationsOthersCell, indexPath: IndexPath) {
        let affiliation = affiliations[indexPath.row]
        cell.tickButton.isEnabled = false
        cell.otherAffiliationTextView.delegate = self
        cell.otherAffiliationTextView.inputAccessoryView = addToolBarOnTextView()
        // debugPrint("affiliationName Other:-  \(String(describing: affiliation.otherAffiliation))")

        if affiliation.isSelected {
            cell.otherAffiliationTextView.text = affiliation.otherAffiliation
            otherText = affiliation.otherAffiliation!
            cell.tickButton.setTitle(Constants.DesignFont.acceptTermsSelected, for: .normal)
            cell.tickButton.setTitleColor(Constants.Color.textFieldColorSelected, for: .normal)
        } else {
            cell.otherAffiliationTextView.text = ""
            otherText = ""
            cell.tickButton.setTitle(Constants.DesignFont.acceptTermsDeSelected, for: .normal)
            cell.tickButton.setTitleColor(Constants.Color.textFieldPlaceHolderColor, for: .normal)
        }
    }

    func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
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
            affiliationsTableView.reloadSections(IndexSet(integer: affiliationOption.rawValue), with: .automatic)
            DispatchQueue.main.async {
                self.affiliationsTableView.scrollToRow(at: IndexPath(row: 0, section: affiliationOption.rawValue), at: .bottom, animated: true)
            }
        default:
            break
        }
    }
}
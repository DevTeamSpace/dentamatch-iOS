//
//  DMEditProfileVC+TableViewExtension.swift
//  DentaMatch
//
//  Created by Rajan Maheshwari on 17/01/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import Foundation

extension DMEditProfileVC: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in _: UITableView) -> Int {
        return 8
    }

    func tableView(_: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let profileOptions = EditProfileOptions(rawValue: indexPath.section)!
        switch profileOptions {
        case .profileHeader:
            if (UserManager.shared().activeUser.aboutMe?.isEmptyField)! {
                return 305
            }
            let aboutTextHeight = EditProfileHeaderTableCell.calculateHeight(text: UserManager.shared().activeUser.aboutMe!)
            return 305 + aboutTextHeight

        case .dentalStateboard:
            // Dental Stateboard Removed
//            if dentalStateBoardURL.isEmpty {
//                if indexPath.row == 0 {
//                    return 45
//                } else {
//                    return 72
//                }
//            } else {
//                return 230
//            }
            return 0

        case .experience:
            if indexPath.row == 0 {
                return 45
            }
            if experiences.count == 0 {
                return 72
            } else {
                // Experience Cell
                let row = indexPath.row - 1
                let references = experiences[row].references.count

                if references == 0 {
                    return 128
                } else if references == 1 {
                    // 200 if one reference is present
                    // 128 if no reference is present
                    let height = checkReferenceIsAvaialble(ref: experiences[row].references[0]) == true ? 200 : 120

                    if indexPath.row == experiences.count {
                        // maintain space to bottom
                        return CGFloat(height + 20)
                    }
                    return CGFloat(height)

                } else if references == 2 {
                    if indexPath.row == experiences.count {
                        return 285
                    }
                    // 2 reference
                    return 265
                }
                return 72
            }

        case .schooling:
            if indexPath.row == 0 {
                return 45
            } else {
                var height: CGFloat = 0
                height = schoolCategories.count == 0 ? CGFloat(72) : EditProfileSchoolCell.requiredHeight(school: schoolCategories[indexPath.row - 1])
                return height
            }

        case .keySkills:
            if indexPath.row == 0 {
                return 45
            }
            if skills.count == 0 {
                return 72
            } else {
                // Brick skill cell height
                if indexPath.row == skills.count {
                    return (getHeightForSkillsRow(indexPath: indexPath) + 55)
                }
                return (getHeightForSkillsRow(indexPath: indexPath) + 35)
            }

        case .affiliations:
            if indexPath.row == 0 {
                return 45
            }
            if affiliations.count == 0 {
                return 72
            } else {
                // Brick affiliation cell height
                return (getHeightForAffilation(affiliations: affiliations) + 60)
//                return 72
            }

        case .licenseNumber:
//            if indexPath.row == 0 {
//                return 45
//            } else {
//                if let _ = license {
//                    return 87
//                }
//                return 72
//            }
            return 0

        case .certifications:
            let certificate = certifications[indexPath.row]
            if (certificate.certificateImageURL?.isEmpty)! {
                return 110
            } else {
                return 285
            }
        }
    }

    func tableView(_: UITableView, numberOfRowsInSection section: Int) -> Int {
        let profileOptions = EditProfileOptions(rawValue: section)!

        switch profileOptions {
        case .profileHeader:
            return 1
        case .dentalStateboard:
            if dentalStateBoardURL.isEmpty {
                return 2
            } else {
                return 1
            }

        case .keySkills:
            if skills.count == 0 {
                return 2
            } else {
                return skills.count + 1
            }

        case .schooling:
            if schoolCategories.count == 0 {
                return 2
            } else {
                return schoolCategories.count + 1
            }

        case .affiliations:
            return 2
        case .certifications:
            return certifications.count
        case .experience:
            if experiences.count > 0 {
                return experiences.count + 1
            } else {
                return 2
            }
        default: return 2
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let profileOptions = EditProfileOptions(rawValue: indexPath.section)!

        switch profileOptions {
        case .profileHeader:
            let cell = tableView.dequeueReusableCell(withIdentifier: "EditProfileHeaderTableCell") as! EditProfileHeaderTableCell
            cell.delegate = self
            cell.updateBadge()
            cell.nameLabel.text = UserManager.shared().activeUser.fullName()
            cell.profileButton.progressBar.setProgress(1.0, animated: false)

            let address = UserManager.shared().activeUser.preferredJobLocation
            cell.placeLabel.attributedText = cell.fillPlaceAndJobTitle(jobTitle: UserManager.shared().activeUser.jobTitle!, place: address!)
            cell.profileButton.progressBar.progressBarTrackColor = UIColor.clear

            cell.statusButton.isHidden = true

            if isJobSeekerVerified == "0" || isJobSeekerVerified == "2" {
                cell.statusButton.isHidden = false
                cell.statusButton.setBackgroundImage(UIImage(named: "pendingButton"), for: .normal)
                cell.statusButton.setTitle("Pending", for: .normal)
                cell.profileButton.progressBar.progressBarProgressColor = UIColor.color(withHexCode: "e7aa4d")
            } else if isProfileCompleted == "0" {
                cell.statusButton.isHidden = false
                cell.statusButton.setBackgroundImage(UIImage(named: "needsAttention"), for: .normal)
                cell.statusButton.setTitle("Needs Attention", for: .normal)
                cell.profileButton.progressBar.progressBarProgressColor = UIColor.color(withHexCode: "fc3238")
            }

            if isJobSeekerVerified == "1" && isProfileCompleted == "1" {
                cell.statusButton.isHidden = false
                cell.statusButton.setBackgroundImage(UIImage(named: "activeButton"), for: .normal)
                cell.statusButton.setTitle("Active", for: .normal)
                cell.profileButton.progressBar.progressBarProgressColor = UIColor.color(withHexCode: "a4d87c")
            }

            cell.editButton.addTarget(self, action: #selector(openEditPublicProfileScreen), for: .touchUpInside)
            cell.statusButton.addTarget(self, action: #selector(statusButtonPressed), for: .touchUpInside)
            cell.settingButton.addTarget(self, action: #selector(openSettingScreen), for: .touchUpInside)
            cell.aboutTextView.text = UserManager.shared().activeUser.aboutMe
    
            if let imageUrl = URL(string: UserManager.shared().activeUser.profileImageURL!) {
                cell.profileButton.sd_setImage(with: imageUrl, for: .normal, placeholderImage: kPlaceHolderImage)
            }
            return cell

        case .dentalStateboard:
            if dentalStateBoardURL.isEmpty {
                if indexPath.row == 0 {
                    let cell = makeHeadingCell(heading: "DENTAL STATE BOARD")
                    return cell
                } else {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "AddProfileOptionTableCell") as! AddProfileOptionTableCell
                    cell.profileOptionLabel.text = "Add dental state board"
                    return cell
                }
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "EditCertificateTableCell") as! EditCertificateTableCell
                cell.certificateHeadingLabel.text = "DENTAL STATE BOARD"
                cell.validityDateAttributedLabel.isHidden = true
                cell.certificateNameLabel.isHidden = true
                cell.editButton.removeTarget(nil, action: nil, for: .allEvents)
                cell.editButton.addTarget(self, action: #selector(openDentalStateBoardScreen), for: .touchUpInside)
                cell.editButton.isHidden = false
                if let imageUrl = URL(string: dentalStateBoardURL) {
                    cell.certificateImageView.sd_setImage(with: imageUrl, placeholderImage: kCertificatePlaceHolder)
                }
                return cell
            }

        case .experience:
            if indexPath.row == 0 {
                let cell = makeHeadingCell(heading: "EXPERIENCE")
                cell.editButton.isHidden = experiences.count > 0 ? false : true
                cell.editButton.removeTarget(nil, action: nil, for: .allEvents)
                cell.editButton.addTarget(self, action: #selector(openWorkExperienceScreen), for: .touchUpInside)
                return cell
            } else {
                if experiences.count == 0 {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "AddProfileOptionTableCell") as! AddProfileOptionTableCell
                    cell.profileOptionLabel.text = "Add work experience"
                    return cell
                } else {
                    // Experience Cell
                    let cell = tableView.dequeueReusableCell(withIdentifier: "EditProfileExperienceCell") as! EditProfileExperienceCell
                    let experience = experiences[indexPath.row - 1]
                    cell.jobTitleLabel.text = experience.jobTitle
//                    let yearExp:Double = Double(experience.experienceInMonth)/12
                    let expInText = calculateMothsAndYear(expInMoth: experience.experienceInMonth)
//                    let roundValue = yearExp.roundTo(places: 3)
                    cell.yearOfExperienceLabel.text = expInText
                    cell.officeNameLabel.text = experience.officeName
                    cell.officeAddressLabel.text = "\(experience.officeAddress!) \n\(experience.cityName!)"
                    cell.reference1Name.isHidden = true
                    cell.reference1Email.isHidden = true
                    cell.reference1Mobile.isHidden = true

                    cell.reference2Name.isHidden = true
                    cell.reference2Email.isHidden = true
                    cell.reference2Mobile.isHidden = true
                    cell.contactInformationLabel.isHidden = true

                    if experience.references.count > 0 {
                        cell.contactInformationLabel.isHidden = false
                        cell.reference1Name.isHidden = false
                        cell.reference1Email.isHidden = false
                        cell.reference1Mobile.isHidden = false

                        if checkReferenceIsAvaialble(ref: experience.references[0]) {
                            cell.contactInformationLabel.isHidden = false

                        } else {
                            cell.contactInformationLabel.isHidden = true
                        }

                        let reference = experience.references[0]
                        cell.reference1Name.text = (reference.referenceName?.trim().count)! > 0 ? reference.referenceName : "N/A"
                        cell.reference1Email.text = (reference.email?.trim().count)! > 0 ? reference.email : "N/A"
                        cell.reference1Mobile.text = (reference.mobileNumber?.trim().count)! > 0 ? reference.mobileNumber : "N/A"
                    }
                    if experience.references.count > 1 {
                        cell.reference2Name.isHidden = false
                        cell.reference2Email.isHidden = false
                        cell.reference2Mobile.isHidden = false
                        if checkReferenceIsAvaialble(ref: experience.references[1]) {
                            cell.contactInformationLabel.isHidden = false

                        } else {
                            cell.contactInformationLabel.isHidden = true
                        }

                        let reference = experience.references[1]
                        cell.reference2Name.text = (reference.referenceName?.trim().count)! > 0 ? reference.referenceName : "N/A"
                        cell.reference2Email.text = (reference.email?.trim().count)! > 0 ? reference.email : "N/A"
                        cell.reference2Mobile.text = (reference.mobileNumber?.trim().count)! > 0 ? reference.mobileNumber : "N/A"
                    }

                    return cell
                }
            }

        case .schooling:
            if indexPath.row == 0 {
                let cell = makeHeadingCell(heading: "EDUCATION / TRAINING")
                cell.editButton.isHidden = schoolCategories.count > 0 ? false : true
                cell.editButton.removeTarget(nil, action: nil, for: .allEvents)
                cell.editButton.addTarget(self, action: #selector(openSchoolsScreen), for: .touchUpInside)
                return cell
            } else {
                if schoolCategories.count == 0 {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "AddProfileOptionTableCell") as! AddProfileOptionTableCell
                    cell.profileOptionLabel.text = "Add education and training"
                    return cell
                } else {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "EditProfileSchoolCell") as! EditProfileSchoolCell
                    let school = schoolCategories[indexPath.row - 1]
                    cell.schoolCategoryLabel.text = school.schoolCategoryName
                    cell.universityNameLabel.text = EditProfileSchoolCell.makeUniversityText(school: school)
                    return cell
                }
            }

        case .keySkills:
            if indexPath.row == 0 {
                let cell = makeHeadingCell(heading: "KEY SKILLS")
                cell.editButton.isHidden = skills.count > 0 ? false : true
                cell.editButton.removeTarget(nil, action: nil, for: .allEvents)
                cell.editButton.addTarget(self, action: #selector(openSkillsScreen), for: .touchUpInside)
                return cell
            } else {
                if skills.count == 0 {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "AddProfileOptionTableCell") as! AddProfileOptionTableCell
                    cell.profileOptionLabel.text = "Add skills category"
                    return cell
                } else {
                    // Brick Skill Cell
                    let skill = skills[indexPath.row - 1]
                    let cell = tableView.dequeueReusableCell(withIdentifier: "EditProfileSkillBrickCell") as! EditProfileSkillBrickCell
                    cell.skillLabel.text = skill.skillName
                    cell.updateSkills(subSkills: skill.subSkills)
                    return cell
                }
            }

        case .affiliations:
            if indexPath.row == 0 {
                let cell = makeHeadingCell(heading: "PROFESSIONAL AFFILIATIONS")
                cell.editButton.isHidden = affiliations.count > 0 ? false : true
                cell.editButton.removeTarget(nil, action: nil, for: .allEvents)
                cell.editButton.addTarget(self, action: #selector(openAffiliationsScreen), for: .touchUpInside)
                return cell
            } else {
                if affiliations.count == 0 {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "AddProfileOptionTableCell") as! AddProfileOptionTableCell
                    cell.profileOptionLabel.text = "Add professional affiliations"
                    return cell
                } else {
                    // Affiliation brick cell
                    let cell = tableView.dequeueReusableCell(withIdentifier: "EditProfileAffiliationBrickCell") as! EditProfileAffiliationBrickCell
                    cell.updateAffiliations(affiliation: affiliations)
                    return cell
                }
            }

        case .licenseNumber:
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "SectionHeadingTableCell") as! SectionHeadingTableCell
                cell.headingLabel.text = "LICENSE NUMBER"
                cell.editButton.isHidden = true
                cell.editButton.removeTarget(nil, action: nil, for: .allEvents)
                cell.editButton.addTarget(self, action: #selector(openEditLicenseScreen), for: .touchUpInside)
                if let _ = license {
                    cell.editButton.isHidden = false
                }
                return cell
            } else {
                if let _ = license {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "EditLicenseTableCell") as! EditLicenseTableCell
                    cell.stateLabel.text = license?.state
                    cell.licenceNumberLabel.text = license?.number
                    return cell
                } else {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "AddProfileOptionTableCell") as! AddProfileOptionTableCell
                    cell.profileOptionLabel.text = "Add license details. Your license Number is ONLY Visible to DentaMatch for Verification purpose."
                    return cell
                }
            }

        case .certifications:
            let certificate = certifications[indexPath.row]
            // Certificate not uploaded cell
            if (certificate.certificateImageURL?.isEmpty)! {
                let cell = tableView.dequeueReusableCell(withIdentifier: "EmptyCertificateTableViewCell") as! EmptyCertificateTableViewCell
                cell.certificateNameLabel.text = certificate.certificationName.uppercased()
                return cell
            } else {
                // Certificate  uploaded cell
                let cell = tableView.dequeueReusableCell(withIdentifier: "EditCertificateTableCell") as! EditCertificateTableCell
                cell.certificateNameLabel.text = certificate.certificationName.uppercased()
                cell.certificateHeadingLabel.text = certificate.certificationName.uppercased()
                cell.validityDateAttributedLabel.isHidden = false
                cell.certificateNameLabel.isHidden = false
                cell.validityDateAttributedLabel.attributedText = cell.createValidityDateAttributedText(date: certificate.validityDate)
                if certificate.certificationName == "Resume" {
                    cell.validityDateAttributedLabel.isHidden = true
                }else{
                   cell.validityDateAttributedLabel.isHidden = false
                }
                cell.editButton.tag = indexPath.row
                cell.editButton.isHidden = false
                cell.editButton.removeTarget(nil, action: nil, for: .allEvents)
                cell.editButton.addTarget(self, action: #selector(openCertificateScreen), for: .touchUpInside)
                if let imageUrl = URL(string: certificate.certificateImageURL!) {
                    cell.certificateImageView.sd_setImage(with: imageUrl, placeholderImage: kCertificatePlaceHolder)
                }
                return cell
            }
        }
    }

    func calculateMothsAndYear(expInMoth: Int) -> String {
        let year = expInMoth / 12
        let month = expInMoth % 12
        var text: String = ""

        if year <= 1 {
            if year != 0 {
                text.append("\(year) yr")
            }
        } else {
            text.append("\(year) yrs")
        }

        if month <= 1 {
            if month != 0 {
                text.append(" \(month) month")
            }
        } else {
            text.append(" \(month) months")
        }

        return text
    }

    func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        let profileOptions = EditProfileOptions(rawValue: indexPath.section)!

        switch profileOptions {
        case .dentalStateboard:
            if dentalStateBoardURL.isEmpty {
                openDentalStateBoardScreen(isEditMode: false)
            }
        case .licenseNumber:
            guard let _ = license else {
                // debugPrint("License Not added")
                openEditLicenseScreen(editMode: false)
                return
            }

        case .experience:
            if experiences.count == 0 {
                openWorkExperienceScreen()
            }

        case .schooling:
            if schoolCategories.count == 0 {
                openSchoolsScreen()
            }

        case .keySkills:
            if skills.count == 0 {
                openSkillsScreen()
            }

        case .affiliations:
            if affiliations.count == 0 {
                openAffiliationsScreen()
            }

        case .certifications:
            let button = UIButton()
            button.tag = indexPath.row

            // Only open on cell touch when no certificate is there for the category
            if (certifications[indexPath.row].certificateImageURL?.isEmpty)! {
                openCertificateScreen(sender: button)
            }

        default:
            break
        }
    }

    func makeHeadingCell(heading: String) -> SectionHeadingTableCell {
        let cell = editProfileTableView.dequeueReusableCell(withIdentifier: "SectionHeadingTableCell") as! SectionHeadingTableCell
        cell.headingLabel.text = heading
        cell.editButton.isHidden = true
        return cell
    }

    func checkReferenceIsAvaialble(ref: EmployeeReferenceModel) -> Bool {
        if ((ref.email?.trim())?.count)! > 0 || ((ref.mobileNumber?.trim())?.count)! > 0 || ((ref.referenceName?.trim())?.count)! > 0 {
            return true
        }
        return false
    }

    func getHeightForAffilation(affiliations: [Affiliation]) -> CGFloat {
        let tagList: TagList = {
            let view = TagList()
            view.backgroundColor = Constants.Color.jobSkillBrickColor
            view.tagMargin = UIEdgeInsets(top: 3, left: 5, bottom: 3, right: 5)
            //            view.separator.image = UIImage(named: "")!
            view.separator.size = CGSize(width: 16, height: 16)
            view.separator.margin = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
            return view
        }()

        tagList.frame = CGRect(origin: CGPoint.zero, size: CGSize(width: Utilities.ScreenSize.SCREEN_WIDTH - 20, height: 0))

        for subSkill in affiliations {
            if let otherText = subSkill.otherAffiliation, (subSkill.affiliationName == "Other" || subSkill.affiliationId == "9") {
                let result = otherText.split(separator: ",")
                for otherString in result {
                    tagList.tags.append(createTag(tagString: String(otherString)))
                }
            } else {
                tagList.tags.append(createTag(tagString: subSkill.affiliationName))
            }

//            let tag = Tag(content: TagPresentableText(subSkill.affiliationName) {
//                $0.label.font = UIFont.fontRegular(fontSize: 14.0)
//                }, onInit: {
//                    $0.padding = UIEdgeInsets(top: 8, left: 10, bottom: 8, right: 10)
//                    $0.layer.borderColor = UIColor.cyan.cgColor
//                    $0.layer.borderWidth = 2
//                    $0.layer.cornerRadius = 5
//            }, onSelect: {
//                $0.backgroundColor = $0.isSelected ? UIColor.orange : UIColor.white
//            })
//            tagList.tags.append(tag)
        }
        return tagList.frame.size.height
    }

    func createTag(tagString: String) -> Tag {
        let tag = Tag(content: TagPresentableText(tagString) {
            $0.label.font = UIFont.fontRegular(fontSize: 14.0)
        }, onInit: {
            $0.padding = UIEdgeInsets(top: 8, left: 10, bottom: 8, right: 10)
            $0.layer.borderColor = UIColor.cyan.cgColor
            $0.layer.borderWidth = 2
            $0.layer.cornerRadius = 5
        }, onSelect: {
            $0.backgroundColor = $0.isSelected ? UIColor.orange : UIColor.white
        })
        return tag
    }

    func getHeightForSkillsRow(indexPath: IndexPath) -> CGFloat {
        let subSkills = skills[indexPath.row - 1].subSkills
        let tagList: TagList = {
            let view = TagList()
            view.backgroundColor = Constants.Color.jobSkillBrickColor
            view.tagMargin = UIEdgeInsets(top: 3, left: 5, bottom: 3, right: 5)
            //            view.separator.image = UIImage(named: "")!
            view.separator.size = CGSize(width: 16, height: 16)
            view.separator.margin = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
            return view
        }()
        tagList.frame = CGRect(origin: CGPoint.zero, size: CGSize(width: Utilities.ScreenSize.SCREEN_WIDTH - 30, height: 0))

        for subSkill in subSkills {
            let tag = Tag(content: TagPresentableText(subSkill.subSkillName) {
                $0.label.font = UIFont.fontRegular(fontSize: 14.0)
            }, onInit: {
                $0.padding = UIEdgeInsets(top: 8, left: 10, bottom: 8, right: 10)
                $0.layer.borderColor = UIColor.cyan.cgColor
                $0.layer.borderWidth = 2
                $0.layer.cornerRadius = 5
            }, onSelect: {
                $0.backgroundColor = $0.isSelected ? UIColor.orange : UIColor.white
            })
            tagList.tags.append(tag)
        }
        return tagList.frame.size.height
    }
}

extension Double {
    /// Rounds the double to decimal places value
    func roundTo(places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}

extension DMEditProfileVC: EditProfileHeaderTableCellDelegate {
    func showNotificationList() {
        let notification = UIStoryboard.notificationStoryBoard().instantiateViewController(type: DMNotificationVC.self)!
        notification.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(notification, animated: true)
    }
    
}

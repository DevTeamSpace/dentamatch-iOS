//
//  DMEditProfileVC+TableViewExtension.swift
//  DentaMatch
//
//  Created by Rajan Maheshwari on 17/01/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import Foundation

extension DMEditProfileVC : UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 8
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let profileOptions = EditProfileOptions(rawValue: indexPath.section)!
        switch profileOptions {
        case .profileHeader:
            return 426
            
        case .dentalStateboard:
            if dentalStateBoardURL.isEmpty {
                if indexPath.row == 0 {
                    return 45
                } else {
                    return 72
                }
            } else {
                return 230
            }
            
        case .experience:
            if indexPath.row == 0 {
                return 45
            }
            if self.experiences.count == 0 {
                return 72
            }
            else {
                //Experience Cell
                let row  =  indexPath.row - 1
                let references = experiences[row].references.count
                

                
                if references == 0 {
                    return 128
                }else if references == 1 {
                    let height = checkReferenceIsAvaialble(ref: experiences[row].references[0]) == true ? 200 : 128
                    return CGFloat(height)


                }else if references == 2 {
                    return 280
                }
                return 72
            }
            
        case .schooling:
            if indexPath.row == 0 {
                return 45
            } else {
                var height = 0
                height = self.schoolCategories.count == 0 ? 72 : 70
                return CGFloat(height)
            }
            
        case .keySkills:
            if indexPath.row == 0 {
                return 45
            }
            if self.skills.count == 0 {
                return 72
            } else {
                //Brick skill cell height
                if indexPath.row == self.skills.count {
                    return (self.getHeightForSkillsRow(indexPath:indexPath) + 55)

                }
                return (self.getHeightForSkillsRow(indexPath:indexPath) + 35)
            }
            
        case .affiliations:
            if indexPath.row == 0 {
                return 45
            }
            if affiliations.count == 0 {
                return 72
            } else {
                //Brick affiliation cell height
               return (self.getHeightForAffilation(affiliations: self.affiliations) + 60)
//                return 72
            }
            
        case .licenseNumber:
            if indexPath.row == 0 {
                return 45
            } else {
                if let _ = license {
                    return 87
                }
                return 72
            }
            
        case .certifications:
            let certificate = certifications[indexPath.row]
            if (certificate.certificateImageURL?.isEmpty)! {
                return 110
            } else {
                return 285
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
            if self.skills.count == 0 {
                return 2
            } else {
                return skills.count + 1
            }
            
        case .schooling:
            if self.schoolCategories.count == 0 {
                return 2
            } else {
                return self.schoolCategories.count + 1
            }
            
        case .affiliations:
            return 2
        case .certifications:
            return certifications.count
        case .experience:
            if self.experiences.count > 0 {
                return self.experiences.count + 1
            }else {
                return 2
            }
        default : return 2
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let profileOptions = EditProfileOptions(rawValue: indexPath.section)!
        
        switch profileOptions {
        case .profileHeader:
            let cell = tableView.dequeueReusableCell(withIdentifier: "EditProfileHeaderTableCell") as! EditProfileHeaderTableCell
            cell.nameLabel.text = UserManager.shared().activeUser.fullName()
            cell.placeLabel.attributedText = cell.fillPlaceAndJobTitle(jobTitle: UserManager.shared().activeUser.jobTitle!, place: "New Delhi")
            cell.editButton.addTarget(self, action: #selector(openEditPublicProfileScreen), for: .touchUpInside)
            cell.settingButton.addTarget(self, action: #selector(openSettingScreen), for: .touchUpInside)
            cell.aboutTextView.text = UserManager.shared().activeUser.aboutMe
            cell.profileButton.progressBar.progressBarTrackColor = UIColor.clear
            cell.profileButton.progressBar.progressBarProgressColor = UIColor.clear
            if let imageUrl = URL(string: UserManager.shared().activeUser.profileImageURL!) {
                cell.profileButton.sd_setImage(with: imageUrl, for: .normal, placeholderImage: kPlaceHolderImage)
            }
            return cell
            
        case .dentalStateboard:
            if dentalStateBoardURL.isEmpty {
                if indexPath.row == 0 {
                    let cell = makeHeadingCell(heading: "DENTAL STATE BOARD")
                    return cell
                }else {
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
                if let imageUrl = URL(string:dentalStateBoardURL) {
                    cell.certificateImageView.sd_setImage(with: imageUrl, placeholderImage: kCertificatePlaceHolder)
                }
                return cell
            }
            
        case .experience:
            if indexPath.row == 0 {
                let cell = makeHeadingCell(heading: "EXPERIENCE")
                cell.editButton.isHidden = self.experiences.count > 0 ? false:true
                cell.editButton.removeTarget(nil, action: nil, for: .allEvents)
                cell.editButton.addTarget(self, action: #selector(openWorkExperienceScreen), for: .touchUpInside)
                return cell
            } else {
                if self.experiences.count == 0 {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "AddProfileOptionTableCell") as! AddProfileOptionTableCell
                    cell.profileOptionLabel.text = "Add more experience"
                    return cell
                } else {
                    //Experience Cell
                    let cell = tableView.dequeueReusableCell(withIdentifier: "EditProfileExperienceCell") as! EditProfileExperienceCell
                    
                    let experience  =  self.experiences[indexPath.row - 1]
                    cell.jobTitleLabel.text = experience.jobTitle
                    let yearExp:Float = Float(experience.experienceInMonth/12)
                    cell.yearOfExperienceLabel.text = "\(yearExp) year"
                    cell.officeNameLabel.text = experience.officeName
                    cell.officeAddressLabel.text = "\(experience.officeAddress!) \n\(experience.cityName!)"
                    if experience.references.count > 0 {
                        let reference  = experience.references[0]
                        cell.reference1Name.text = (reference.referenceName?.trim().characters.count)! > 0 ? reference.referenceName : "N/A"
                        cell.reference1Email.text = (reference.email?.trim().characters.count)! > 0 ? reference.email : "N/A"
                        cell.reference1Mobile.text = (reference.mobileNumber?.trim().characters.count)! > 0 ? reference.mobileNumber : "N/A"
                    }
                    if experience.references.count > 1 {
                        let reference  = experience.references[1]
                        cell.reference2Name.text = (reference.referenceName?.trim().characters.count)! > 0 ? reference.referenceName : "N/A"
                        cell.reference2Email.text = (reference.email?.trim().characters.count)! > 0 ? reference.email : "N/A"
                        cell.reference2Mobile.text = (reference.mobileNumber?.trim().characters.count)! > 0 ? reference.mobileNumber : "N/A"
                    }

                    
                    
                    return cell
                }
            }
            
        case .schooling:
            if indexPath.row == 0 {
                let cell = makeHeadingCell(heading: "SCHOOLING AND CERTIFICATION")
                cell.editButton.isHidden = self.schoolCategories.count > 0 ? false:true
                cell.editButton.removeTarget(nil, action: nil, for: .allEvents)
                cell.editButton.addTarget(self, action: #selector(openSchoolsScreen), for: .touchUpInside)
                return cell
            } else {
                if self.schoolCategories.count == 0 {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "AddProfileOptionTableCell") as! AddProfileOptionTableCell
                    cell.profileOptionLabel.text = "Add schooling and certification"
                    return cell
                } else {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "EditProfileSchoolCell") as! EditProfileSchoolCell
                    let school = self.schoolCategories[indexPath.row - 1]
                    cell.schoolCategoryLabel.text = school.schoolCategoryName
                    cell.universityNameLabel.text = cell.makeUniversityText(school: school)
                    return cell
                }
            }
            
        case .keySkills:
            if indexPath.row == 0 {
                let cell = makeHeadingCell(heading: "KEY SKILLS")
                cell.editButton.isHidden = self.skills.count > 0 ? false:true
                cell.editButton.removeTarget(nil, action: nil, for: .allEvents)
                cell.editButton.addTarget(self, action: #selector(openSkillsScreen), for: .touchUpInside)
                return cell
            } else {
                if self.skills.count == 0 {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "AddProfileOptionTableCell") as! AddProfileOptionTableCell
                    cell.profileOptionLabel.text = "Add skills category"
                    return cell
                }
                else {
                    //Brick Skill Cell
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
                cell.editButton.isHidden = self.affiliations.count > 0 ? false:true
                cell.editButton.removeTarget(nil, action: nil, for: .allEvents)
                cell.editButton.addTarget(self, action: #selector(openAffiliationsScreen), for: .touchUpInside)
                return cell
            } else {
                if affiliations.count == 0 {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "AddProfileOptionTableCell") as! AddProfileOptionTableCell
                    cell.profileOptionLabel.text = "Add professional affiliations"
                    return cell
                }else {
                    // Affiliation brick cell
                    let cell = tableView.dequeueReusableCell(withIdentifier: "EditProfileAffiliationBrickCell") as! EditProfileAffiliationBrickCell
                    cell.updateAffiliations(affiliation: self.affiliations)
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
                    cell.profileOptionLabel.text = "Add license details"
                    return cell
                }
            }
            
        case .certifications:
            let certificate = certifications[indexPath.row]
            
            //Certificate not uploaded cell
            if (certificate.certificateImageURL?.isEmpty)! {
                let cell = tableView.dequeueReusableCell(withIdentifier: "EmptyCertificateTableViewCell") as! EmptyCertificateTableViewCell
                cell.certificateNameLabel.text = certificate.certificationName
                return cell
            } else {
                //Certificate  uploaded cell
                let cell = tableView.dequeueReusableCell(withIdentifier: "EditCertificateTableCell") as! EditCertificateTableCell
                cell.certificateNameLabel.text = certificate.certificationName
                cell.certificateHeadingLabel.text = certificate.certificationName
                cell.validityDateAttributedLabel.isHidden = false
                cell.certificateNameLabel.isHidden = false
                cell.validityDateAttributedLabel.attributedText = cell.createValidityDateAttributedText(date: certificate.validityDate)
                cell.editButton.tag = indexPath.row
                cell.editButton.isHidden = false
                cell.editButton.removeTarget(nil, action: nil, for: .allEvents)
                cell.editButton.addTarget(self, action: #selector(openCertificateScreen), for: .touchUpInside)
                if let imageUrl = URL(string:certificate.certificateImageURL!) {
                    cell.certificateImageView.sd_setImage(with: imageUrl, placeholderImage: kCertificatePlaceHolder)
                }
                return cell
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let profileOptions = EditProfileOptions(rawValue: indexPath.section)!
        
        switch profileOptions {
        case .dentalStateboard:
            if dentalStateBoardURL.isEmpty {
                openDentalStateBoardScreen(isEditMode: false)
            }
        case .licenseNumber:
            guard let _ = license else {
                print("License Not added")
                openEditLicenseScreen(editMode: false)
                return
            }
            
        case .keySkills:
            if self.skills.count == 0 {
                openSkillsScreen()
            }
            
        case .affiliations:
            openAffiliationsScreen()
            
        case .certifications:
            let button = UIButton()
            button.tag = indexPath.row
            openCertificateScreen(sender: button)
            
        default:
            break
        }
    }
    
    func makeHeadingCell(heading:String) -> SectionHeadingTableCell {
        let cell = self.editProfileTableView.dequeueReusableCell(withIdentifier: "SectionHeadingTableCell") as! SectionHeadingTableCell
        cell.headingLabel.text = heading
        cell.editButton.isHidden = true
        return cell
    }
    func checkReferenceIsAvaialble(ref:EmployeeReferenceModel) -> Bool {
        if ((ref.email?.trim())?.characters.count)! > 0 || ((ref.mobileNumber?.trim())?.characters.count)! > 0 || ((ref.referenceName?.trim())?.characters.count)! > 0 {
            return true
        }
        return false
    }
    func getHeightForExperience(indexPath:IndexPath) {
        let experience  = self.experiences[indexPath.row-1]
        for ref in experience.references {
            if (ref.email?.characters.count)! > 0 || (ref.mobileNumber?.characters.count)! > 0 || (ref.referenceName?.characters.count)! > 0 {
                
            }
        }
    }
    
    func getHeightForAffilation (affiliations:[Affiliation]) -> CGFloat  {
        
        let tagList: TagList = {
            let view = TagList()
            view.backgroundColor = UIColor(red: 233.0/255.0, green: 233.0/255.0, blue: 233.0/255.0, alpha: 1.0)
            view.tagMargin = UIEdgeInsets(top: 3, left: 5, bottom: 3, right: 5)
            //            view.separator.image = UIImage(named: "")!
            view.separator.size = CGSize(width: 16, height: 16)
            view.separator.margin = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
            return view
        }()
        tagList.frame = CGRect(origin: CGPoint.zero, size: CGSize(width: editProfileTableView.frame.width - 20, height: 0))
        
        for subSkill in affiliations {
            
            let tag = Tag(content: TagPresentableText(subSkill.affiliationName) {
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
        
        debugPrint("Height \(tagList.intrinsicContentSize.height)")
        return tagList.frame.size.height
    }
    
    func getHeightForSkillsRow(indexPath:IndexPath) -> CGFloat {
        
        let subSkills = self.skills[indexPath.row - 1].subSkills
        let tagList: TagList = {
            let view = TagList()
            view.backgroundColor = UIColor(red: 233.0/255.0, green: 233.0/255.0, blue: 233.0/255.0, alpha: 1.0)
            view.tagMargin = UIEdgeInsets(top: 3, left: 5, bottom: 3, right: 5)
            //            view.separator.image = UIImage(named: "")!
            view.separator.size = CGSize(width: 16, height: 16)
            view.separator.margin = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
            return view
        }()
        tagList.frame = CGRect(origin: CGPoint.zero, size: CGSize(width: editProfileTableView.frame.width - 20, height: 0))
        
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
        
        debugPrint("Height \(tagList.intrinsicContentSize.height)")
        return tagList.frame.size.height

    }
}

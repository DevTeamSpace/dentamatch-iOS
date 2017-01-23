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
            } else {
                return 72
            }
            
        case .schooling:
            if indexPath.row == 0 {
                return 45
            } else {
                return 72
            }
            
        case .keySkills:
            if indexPath.row == 0 {
                return 45
            }
            if self.skills.count == 0 {
                return 72
            } else {
                //Brick skill cell height
                return 74
            }
            
        case .affiliations:
            if indexPath.row == 0 {
                return 45
            }
            if affliations.count == 0 {
                return 72
            } else {
                //Brick affiliation cell height
               return (self.getHeightForAffilation(affiliations: self.affliations) + 60)
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
            
        case .affiliations:
            return 2
        case .certifications:
            return certifications.count
        default : return 2
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let profileOptions = EditProfileOptions(rawValue: indexPath.section)!
        
        switch profileOptions {
        case .profileHeader:
            let cell = tableView.dequeueReusableCell(withIdentifier: "EditProfileHeaderTableCell") as! EditProfileHeaderTableCell
            cell.nameLabel.text = UserManager.shared().activeUser.fullName()
            cell.editButton.addTarget(self, action: #selector(openEditPublicProfileScreen), for: .touchUpInside)
            cell.settingButton.addTarget(self, action: #selector(openSettingScreen), for: .touchUpInside)
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
                return cell
            }
            
        case .experience:
            if indexPath.row == 0 {
                let cell = makeHeadingCell(heading: "EXPERIENCE")
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "AddProfileOptionTableCell") as! AddProfileOptionTableCell
                cell.profileOptionLabel.text = "Add more experience"
                return cell
            }
            
        case .schooling:
            if indexPath.row == 0 {
                let cell = makeHeadingCell(heading: "SCHOOLING AND CERTIFICATION")
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "AddProfileOptionTableCell") as! AddProfileOptionTableCell
                cell.profileOptionLabel.text = "Add schooling and certification"
                return cell
            }
            
        case .keySkills:
            if indexPath.row == 0 {
                let cell = makeHeadingCell(heading: "KEY SKILLS")
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
                    let cell = tableView.dequeueReusableCell(withIdentifier: "AddProfileOptionTableCell") as! AddProfileOptionTableCell
                    cell.profileOptionLabel.text = "Add skills category"
                    return cell
                }
            }
            
        case .affiliations:
            if indexPath.row == 0 {
                let cell = makeHeadingCell(heading: "PROFESSIONAL AFFILIATIONS")
                cell.editButton.isHidden = self.affliations.count > 0 ? false:true
                cell.editButton.addTarget(self, action: #selector(openAffiliationsScreen), for: .touchUpInside)
                return cell
            } else {
                if affliations.count == 0 {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "AddProfileOptionTableCell") as! AddProfileOptionTableCell
                    cell.profileOptionLabel.text = "Add professional affiliations"
                    return cell
                }else {
                    // Affiliation brick cell
                    let cell = tableView.dequeueReusableCell(withIdentifier: "EditProfileAffiliationBrickCell") as! EditProfileAffiliationBrickCell
                    cell.updateAffiliations(affiliation: self.affliations)
                    return cell
                }
            }
            
        case .licenseNumber:
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "SectionHeadingTableCell") as! SectionHeadingTableCell
                cell.headingLabel.text = "LICENSE NUMBER"
                cell.editButton.isHidden = true
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
                cell.editButton.addTarget(self, action: #selector(openCertificateScreen), for: .touchUpInside)
                if let imageUrl = URL(string:certificate.certificateImageURL!) {
                    cell.certificateImageView.sd_setImage(with: imageUrl, placeholderImage: nil)
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
                print("Open add")
            }
        case .licenseNumber:
            guard let _ = license else {
                print("License Not added")
                return
            }
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
                $0.label.font = UIFont.systemFont(ofSize: 16)
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
        return 10.0
    }
}

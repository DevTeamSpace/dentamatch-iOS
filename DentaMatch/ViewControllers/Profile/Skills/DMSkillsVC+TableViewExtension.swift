//
//  DMSkillsVC+TableViewExtension.swift
//  DentaMatch
//
//  Created by Rajan Maheshwari on 12/01/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import Foundation

extension DMSkillsVC: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in _: UITableView) -> Int {
        return 3
    }

    func tableView(_: UITableView, numberOfRowsInSection section: Int) -> Int {
        let skillsOption = Skills(rawValue: section)!

        switch skillsOption {
        case .profileHeader:
            return 2

        case .skills:
            return skills.count

        case .other:
            return 1
        }
    }

    func tableView(_: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let skillOption = Skills(rawValue: indexPath.section)!

        switch skillOption {
        case .profileHeader:
            switch indexPath.row {
            case 0:
                // Profile Header
                return 213
            case 1:
                // Heading

                return 44
            default:
                return 0
            }
        case .skills:

            let height = getHeightOFCellForSkill(subSkills: skills[indexPath.row].subSkills.filter({ $0.isSelected == true }))
            return 56 + height

        case .other:
            return 144
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let skillsOption = Skills(rawValue: indexPath.section)!

        switch skillsOption {
        case .profileHeader:
            switch indexPath.row {
            case 0:
                // Profile Header
                let cell = tableView.dequeueReusableCell(withIdentifier: "PhotoNameCell") as! PhotoNameCell
                cell.nameLabel.text = "Skills & Experience"
                cell.jobTitleLabel.text = "Lorem Ipsum is simply dummy text for the typing and printing industry"
                if let imageURL = URL(string: UserManager.shared().activeUser.profileImageURL!) {
                    cell.photoButton.sd_setImage(with: imageURL, for: .normal, placeholderImage: kPlaceHolderImage)
                }
                cell.photoButton.progressBar.setProgress(profileProgress, animated: true)
                return cell

            case 1:
                // Heading
                let cell = tableView.dequeueReusableCell(withIdentifier: "SectionHeadingTableCell") as! SectionHeadingTableCell
                cell.headingLabel.text = "KEY SKILLS"
                return cell

            default:
                return UITableViewCell()
            }
        case .skills:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SkillsTableCell") as! SkillsTableCell
            let skill = skills[indexPath.row]
            cell.subSkillsTagView.tag = indexPath.row

            cell.updateSkills(subSkills: skills[indexPath.row].subSkills.filter({ $0.isSelected == true }))

            cell.skillLabel.text = skill.skillName
            return cell

        case .other:
            let cell = tableView.dequeueReusableCell(withIdentifier: "OtherSkillCell") as! OtherSkillCell
            cell.otherTextView.delegate = self
            if let _ = otherSkill {
                cell.otherTextView.text = otherSkill?.otherText
            }
            return cell
        }
    }

    func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        let skillsOption = Skills(rawValue: indexPath.section)!

        switch skillsOption {
        case .skills:
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "getSubSkillData"), object: nil, userInfo: ["skill": skills[indexPath.row]])
            presentRightMenuViewController()

        default:
            break
        }
    }

    func getHeightOFCellForSkill(subSkills: [SubSkill]) -> CGFloat {
        let tagList: TagList = {
            let view = TagList()
            view.backgroundColor = Constants.Color.jobSkillBrickColor
            view.tagMargin = UIEdgeInsets(top: 3, left: 5, bottom: 3, right: 5)
//            view.separator.image = UIImage(named: "")!
            view.separator.size = CGSize(width: 16, height: 16)
            view.separator.margin = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
            return view
        }()
        tagList.frame = CGRect(origin: CGPoint.zero, size: CGSize(width: skillsTableView.frame.width - 20, height: 0))

        for subSkill in subSkills {
            let tag = Tag(content: TagPresentableText(subSkill.subSkillName) {
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

        // debugPrint("Height \(tagList.intrinsicContentSize.height)")
        return tagList.frame.size.height
    }
}

extension DMSkillsVC: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        if let _ = otherSkill {
            otherSkill?.otherText = textView.text.trim()
        }
    }

    func textViewShouldBeginEditing(_: UITextView) -> Bool {
        skillsTableView.contentInset = UIEdgeInsetsMake(0, 0, 200, 0)
        DispatchQueue.main.async {
            self.skillsTableView.scrollToRow(at: IndexPath(row: 0, section: 2), at: .bottom, animated: true)
        }
        return true
    }

    func textViewShouldEndEditing(_: UITextView) -> Bool {
        skillsTableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
        return true
    }

    func textView(_ textView: UITextView, shouldChangeTextIn _: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
}

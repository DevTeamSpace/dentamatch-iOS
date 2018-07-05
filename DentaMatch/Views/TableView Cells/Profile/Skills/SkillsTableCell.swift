//
//  SkillsTableCell.swift
//  DentaMatch
//
//  Created by Rajan Maheshwari on 12/01/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

class SkillsTableCell: UITableViewCell, TagListDelegate {
    @IBOutlet var subSkillsTagView: UIScrollView!
    @IBOutlet var subSkillCollectionViewHeight: NSLayoutConstraint!
    @IBOutlet var skillLabel: UILabel!
    @IBOutlet var subSkillsCollectionView: UICollectionView!

    var tagList: TagList = {
        let view = TagList()
        view.backgroundColor = UIColor.clear
        view.tagMargin = UIEdgeInsets(top: 3, left: 5, bottom: 3, right: 5)
//        view.separator.image = UIImage(named: "")!
        view.separator.size = CGSize(width: 16, height: 16)
        view.separator.margin = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        return view
    }()

    override func awakeFromNib() {
        super.awakeFromNib()
        subSkillsTagView.clipsToBounds = true
        subSkillsTagView.addSubview(tagList)
        tagList.frame = CGRect(origin: CGPoint.zero, size: CGSize(width: UIScreen.main.bounds.width - 30, height: 0))
        subSkillsTagView.isUserInteractionEnabled = false
    }

    func getHeight() -> CGFloat {
        return subSkillsTagView.contentSize.height
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

    func updateSkills(subSkills: [SubSkill]) {
        tagList.tags.removeAll()
        for subSkill in subSkills {
            // If we want to print Other value, then uncomment this
            var subSkillName = ""
            if subSkill.isOther {
                subSkillName = subSkill.otherText
            } else {
                subSkillName = subSkill.subSkillName
            }
//
            let tag = Tag(content: TagPresentableText(subSkillName) {
                $0.label.font = UIFont.fontRegular(fontSize: 14.0)
                $0.label.textColor = Constants.Color.brickTextColor
            }, onInit: {
                $0.padding = UIEdgeInsets(top: 8, left: 10, bottom: 8, right: 10)
                $0.layer.borderColor = UIColor.clear.cgColor
                $0.layer.borderWidth = 1
                $0.layer.cornerRadius = 2
            }, onSelect: {
                $0.backgroundColor = Constants.Color.jobSkillBrickColor // $0.isSelected ? UIColor.orange : UIColor.white
            })
            tagList.tags.append(tag)
        }
        if subSkills.count > 0 {
            subSkillsTagView.isHidden = false
        } else {
            subSkillsTagView.isHidden = true
        }
    }

    func tagListUpdated(tagList: TagList) {
        subSkillsTagView.contentSize = tagList.intrinsicContentSize
    }

    func tagActionTriggered(tagList _: TagList, action _: TagAction, content _: TagPresentable, index _: Int) {
        // For tapping tag action
    }
}

//
//  EditProfileAffiliationBrickCell.swift
//  DentaMatch
//
//  Created by Sanjay Kumar Yadav on 23/01/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

class EditProfileAffiliationBrickCell: UITableViewCell,TagListDelegate {
    @IBOutlet weak var tagScrollView: UIScrollView!
    
    var tagList: TagList = {
        let view = TagList()
        view.backgroundColor = UIColor.clear
        view.isAutowrap = true
        view.tagMargin = UIEdgeInsets(top: 3, left: 5, bottom: 3, right: 5)
        //        view.separator.image = UIImage(named: "")!
        view.separator.size = CGSize(width: 16, height: 16)
        view.separator.margin = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        return view
    }()
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.tagScrollView.clipsToBounds = true
        tagScrollView.addSubview(tagList)
        tagList.frame = CGRect(origin: CGPoint.zero, size: CGSize(width: UIScreen.main.bounds.width - 30, height: 0))
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func updateSkills(subSkills:[SubSkill]) {
        tagList.tags.removeAll()
        for subSkill in subSkills {
            let tag = Tag(content: TagPresentableText(subSkill.subSkillName) {
                $0.label.font = UIFont.systemFont(ofSize: 16)
                }, onInit: {
                    $0.padding = UIEdgeInsets(top: 8, left: 10, bottom: 8, right: 10)
                    $0.layer.borderColor = UIColor.clear.cgColor
                    $0.layer.borderWidth = 1
                    $0.layer.cornerRadius = 2
            }, onSelect: {
                $0.backgroundColor = Constants.Color.jobSkillBrickColor //$0.isSelected ? UIColor.orange : UIColor.white
            })
            tagList.tags.append(tag)
        }
        if subSkills.count > 0 {
            self.tagScrollView.isHidden = false
        }else {
            self.tagScrollView.isHidden = true
        }
    }
    
    func updateAffiliations(affiliation:[Affiliation]) {
        tagList.tags.removeAll()
        for subSkill in affiliation {
            let tag = Tag(content: TagPresentableText(subSkill.affiliationName) {
                $0.label.font = UIFont.fontRegular(fontSize: 14.0)
                $0.label.textColor = Constants.Color.brickTextColor
                }, onInit: {
                    $0.padding = UIEdgeInsets(top: 8, left: 10, bottom: 8, right: 10)
                    $0.layer.borderColor = UIColor.clear.cgColor
                    $0.layer.borderWidth = 1
                    $0.layer.cornerRadius = 2
            }, onSelect: {
                $0.backgroundColor = Constants.Color.jobSkillBrickColor //$0.isSelected ? UIColor.orange : UIColor.white
            })
            tagList.tags.append(tag)
        }
        if affiliation.count > 0 {
            self.tagScrollView.isHidden = false
        }else {
            self.tagScrollView.isHidden = true
        }
    }
    
    func tagListUpdated(tagList: TagList) {
        self.tagScrollView.contentSize = tagList.intrinsicContentSize
    }
    
    func tagActionTriggered(tagList: TagList, action: TagAction, content: TagPresentable, index: Int) {
        //Tapping of tag action
    }
    
    
    
}

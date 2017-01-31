//
//  SkillsTableCell.swift
//  DentaMatch
//
//  Created by Rajan Maheshwari on 12/01/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

class SkillsTableCell: UITableViewCell,TagListDelegate {
    
    @IBOutlet weak var subSkillsTagView: UIScrollView!
    @IBOutlet weak var subSkillCollectionViewHeight: NSLayoutConstraint!
    @IBOutlet weak var skillLabel: UILabel!
    @IBOutlet weak var subSkillsCollectionView: UICollectionView!
    
    
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
//        subSkillsTagView.tagColorTheme = .raspberry
        self.subSkillsTagView.clipsToBounds = true
        subSkillsTagView.addSubview(tagList)
        tagList.frame = CGRect(origin: CGPoint.zero, size: CGSize(width: UIScreen.main.bounds.width - 30, height: 0))
        // Initialization code
        
//        self.subSkillsCollectionView.register(UINib(nibName: "SubSkillCollectionCell", bundle: nil), forCellWithReuseIdentifier: "SubSkillCollectionCell")
//        self.subSkillsCollectionView.dataSource = self
//        self.subSkillsCollectionView.delegate = self
//        let collectionViewFlowLayout = subSkillsCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
//        collectionViewFlowLayout.estimatedItemSize = CGSize(width: 34, height: 50)
 
    }

    func getHeight() -> CGFloat {
        return self.subSkillsTagView.contentSize.height
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    func updateSkills(subSkills:[SubSkill]) {
        tagList.tags.removeAll()
        for subSkill in subSkills {
            
            //If we want to print Other value, then uncomment this
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
                $0.backgroundColor = Constants.Color.jobSkillBrickColor //$0.isSelected ? UIColor.orange : UIColor.white
            })
            tagList.tags.append(tag)
        }
        if subSkills.count > 0 {
            self.subSkillsTagView.isHidden = false
        }else {
            self.subSkillsTagView.isHidden = true
        }
    }
    
    func tagListUpdated(tagList: TagList) {
        self.subSkillsTagView.contentSize = tagList.intrinsicContentSize
    }
    
    func tagActionTriggered(tagList: TagList, action: TagAction, content: TagPresentable, index: Int) {
    }

    
}

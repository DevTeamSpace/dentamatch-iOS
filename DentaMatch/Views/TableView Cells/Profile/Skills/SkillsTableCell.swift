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
//            var subSkillName = ""
//            if subSkill.isOther {
//                subSkillName = subSkill.otherText
//            } else {
//                subSkillName = subSkill.subSkillName
//            }
//            
            let tag = Tag(content: TagPresentableText(subSkill.subSkillName) {
                $0.label.font = UIFont.systemFont(ofSize: 16)
                }, onInit: {
                    $0.padding = UIEdgeInsets(top: 8, left: 10, bottom: 8, right: 10)
                    $0.layer.borderColor = UIColor.clear.cgColor
                    $0.layer.borderWidth = 1
                    $0.layer.cornerRadius = 2
            }, onSelect: {
                $0.backgroundColor = UIColor(red: 233.0/255.0, green: 233.0/255.0, blue: 233.0/255.0, alpha: 1.0) //$0.isSelected ? UIColor.orange : UIColor.white
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
//        if tagList != selectedTagList {
//            selectedTagList.tags = tagList.selectedTagPresentables().map({ (tag) -> Tag in
//                Tag(content: TagPresentableText(tag.tag) {
//                    $0.label.font = UIFont.systemFont(ofSize: 16)
//                    }, onInit: {
//                        $0.padding = UIEdgeInsets(top: 3, left: 5, bottom: 3, right: 5)
//                        $0.layer.borderColor = UIColor.cyan.cgColor
//                        $0.layer.borderWidth = 2
//                        $0.layer.cornerRadius = 5
//                })
//            })
//        }
    }

    
//    func setCollectionViewHeight()  {
//        self.subSkillCollectionViewHeight.constant = self.subSkillsCollectionView.contentSize.height
//        self.subSkillsCollectionView.layoutIfNeeded()
//        self.layoutIfNeeded()
//    }
//    
//    func updateCollectionViewData() {
//        self.subSkillsCollectionView.reloadData()
//        self.setCollectionViewHeight()
//    }
//    
//    func numberOfSections(in collectionView: UICollectionView) -> Int {
//        return 1;
//    }
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return 10
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SubSkillCollectionCell", for: indexPath) as! SubSkillCollectionCell
//        cell.subSkillLabel.text = "Rajan"
//        return cell
//    }
//    
//    func collectionView(_ collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        
//       // let text = self.arrAllData[indexPath.row] as? String
//        let width = "Rajan".widthWithConstraintHeight(height: 25, font: UIFont.fontRegular(fontSize: 14.0)!)
//        return CGSize(width: width+25, height: 25)
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        return 5
//    }
}

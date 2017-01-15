//
//  SkillsTableCell.swift
//  DentaMatch
//
//  Created by Rajan Maheshwari on 12/01/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

class SkillsTableCell: UITableViewCell {
    
    @IBOutlet weak var subSkillsTagView: ASJTagsView!
    @IBOutlet weak var subSkillCollectionViewHeight: NSLayoutConstraint!
    @IBOutlet weak var skillLabel: UILabel!
    @IBOutlet weak var subSkillsCollectionView: UICollectionView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        subSkillsTagView.tagColorTheme = .raspberry

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

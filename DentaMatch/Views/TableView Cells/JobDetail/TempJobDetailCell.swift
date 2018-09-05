//
//  TempJobDetailCell.swift
//  DentaMatch
//
//  Created by Prashant Gautam on 22/08/18.
//  Copyright © 2018 Appster. All rights reserved.
//

import UIKit
/*@objc protocol TempJobDetailCellDelegate {
 @objc optional func favouriteAction()
 }*/
class TempJobDetailCell: UITableViewCell {
    @IBOutlet var lblPercentSkill: UILabel!
    @IBOutlet var lblDentistName: UILabel!
    @IBOutlet var btnFavourite: UIButton!
    @IBOutlet var btnJobType: UIButton!
    @IBOutlet var btnSeeMore: UIButton?
    @IBOutlet weak var daysCollectionView: UICollectionView!
    @IBOutlet weak var daysCollectionViewHeight: NSLayoutConstraint?
    //@IBOutlet weak var tagList: TagList!
    //@IBOutlet weak var tagListViewHeight: NSLayoutConstraint?
    @IBOutlet var lblPostTime: UILabel!
    @IBOutlet var lblApplied: UILabel!
    
    var jobTypeDates = [String]()
    private var datesCount : Int = 0
    weak var delegate: DentistDetailCellDelegate?
    var isTagExpanded: Bool = false
    private let cellWidth: CGFloat =  70.0
    
    private var seeMoreHidden: Bool {
        if UIDevice.current.screenType == .iPhone6Plus {
            return self.jobTypeDates.count < 8
        }
        return self.jobTypeDates.count < 6
    }
    
    private var tagsCount: Int {
        if self.jobTypeDates.count == 0 {
            return 0
        }
        if UIDevice.current.screenType == .iPhone6Plus {
            return isTagExpanded ? self.jobTypeDates.count + 1 : minimumNumberOfItems
        }
        return isTagExpanded ? self.jobTypeDates.count + 1 : minimumNumberOfItems
    }
    
    private var minimumNumberOfItems : Int {
        if UIDevice.current.screenType == .iPhone6Plus {
            return self.seeMoreHidden ? self.jobTypeDates.count : 8
        }
        return self.seeMoreHidden ? self.jobTypeDates.count : 6
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        btnJobType.layer.cornerRadius = 3
        lblApplied.isHidden = true
        daysCollectionView.register(UINib(nibName: "TagCell", bundle: nil), forCellWithReuseIdentifier: "TagCell")
        daysCollectionView.collectionViewLayout = DGCollectionViewLeftAlignFlowLayout()
        
        /*tagList.tagMargin = UIEdgeInsets(top: 3, left: 5, bottom: 3, right: 5)
         //        view.separator.image = UIImage(named: "")!
         tagList.separator.size = CGSize(width: 16, height: 16)
         tagList.separator.margin = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)*/
        
    }
    
    @IBAction func actionFavourite(_: UIButton) {
        delegate?.saveOrUnsaveJob!()
    }
    
    @IBAction func seeMoreAction(sender: UIButton) {
        //self.isTagExpanded = !self.isTagExpanded
        sender.isSelected = !sender.isSelected
        //if sender.isSelected {
            delegate?.seeMoreTags!(isExpanded: sender.isSelected)
            //sender.setTitle("See less", for: .selected)
        //}else{
           // delegate?.seeMoreTags!(isExpanded: false)
           // sender.setTitle("See more", for: .normal)
        //}
        
    }
    
    func setCellData(job: Job, isTagExpanded: Bool = false) {
        /* For Job status
         INVITED = 1
         APPLIED = 2
         SHORTLISTED = 3
         HIRED = 4
         REJECTED = 5
         CANCELLED = 6
         */
        lblApplied.isHidden = true
        
        switch job.isApplied {
        case 1:
            lblApplied.text = "INVITED"
            lblApplied.isHidden = false
            
        case 2:
            lblApplied.text = "APPLIED"
            lblApplied.isHidden = false
            
        case 3:
            lblApplied.text = "INTERVIEWING"
            lblApplied.isHidden = false
            
        case 4:
            lblApplied.text = "HIRED"
            lblApplied.isHidden = false
            
        case 5:
            lblApplied.text = "REJECTED"
            lblApplied.isHidden = false
            
        case 6:
            lblApplied.text = "CANCELLED"
            lblApplied.isHidden = false
            
        default:
            break
        }
        
        if job.isSaved == 0 {
            self.btnFavourite.setTitle(Constants.DesignFont.notFavourite, for: .normal)
            self.btnFavourite.titleLabel?.textColor = Constants.Color.unSaveJobColor
            self.btnFavourite.setImage(UIImage(named: ""), for: .normal)
        } else {
            btnFavourite.setImage(UIImage(named: "saveStar"), for: .normal)
            btnFavourite.setTitle("", for: .normal)
        }
        if job.jobType == 1 {
            btnJobType.setTitle(Constants.Strings.fullTime, for: .normal)
            btnJobType.backgroundColor = Constants.Color.fullTimeBackgroundColor
        } else if job.jobType == 2 {
            btnJobType.setTitle(Constants.Strings.partTime, for: .normal)
            btnJobType.backgroundColor = Constants.Color.partTimeDaySelectColor
        }
        lblDentistName.text = job.jobtitle
        if job.jobPostedTimeGap == Constants.Strings.zero {
            lblPostTime.text = Constants.Strings.today.uppercased()
        } else if job.jobPostedTimeGap == Constants.Strings.one {
            lblPostTime.text = job.jobPostedTimeGap + Constants.Strings.whiteSpace + Constants.Strings.dayAgo
        } else {
            lblPostTime.text = job.jobPostedTimeGap + Constants.Strings.whiteSpace + Constants.Strings.daysAgo
        }
        //tagList.tags.removeAll()
        self.jobTypeDates.removeAll()
        if job.jobType == 3 {
            for date in job.jobTypeDates {
                self.jobTypeDates.append(Date.commonDateFormatEEMMDD(dateString: date))
            }
            self.daysCollectionView.reloadData()
            self.isTagExpanded = isTagExpanded
            if isTagExpanded {
               //self.btnSeeMore.setTitle("See less", for: .selected)
               self.daysCollectionViewHeight?.constant = self.daysCollectionView.collectionViewLayout.collectionViewContentSize.height
            } else {
                self.daysCollectionViewHeight?.constant = self.daysCollectionView.collectionViewLayout.collectionViewContentSize.height
                //self.btnSeeMore.setTitle("See more", for: .normal)
            }
            
            //self.tagListViewHeight?.constant = self.tagList.intrinsicContentSize.height
        }
        lblPercentSkill.text = String(format: "%.2f", job.percentSkillsMatch) + "%"
        //self.btnSeeMore?.isHidden = seeMoreHidden
    }
}


extension TempJobDetailCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    // MARK: - UICollectionViewDataSource Methods
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        
        return tagsCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TagCell", for: indexPath) as! TagCell
        if indexPath.item == tagsCount - 1 && !seeMoreHidden {
            let text = self.isTagExpanded ? "See Less" : "See More"
            cell.setTag(with: text, type: .seeMore)
        }else{
            let name = jobTypeDates[indexPath.item]
            cell.setTag(with: name)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout _: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        /*var width = CGFloat(0)
        let title = jobTypeDates[indexPath.item]
        width = title.widthWithConstrainetHeight(20, font: UIFont.fontRegular(fontSize: 10)!)
        LogManager.logDebug("\(width + 10)")
        // return CGSize(width: width + 10, height: 20)*/
        return CGSize(width: cellWidth , height: 20.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: false)
        if indexPath.item == tagsCount - 1 && !seeMoreHidden {
            isTagExpanded = !isTagExpanded
            delegate?.seeMoreTags!(isExpanded: isTagExpanded)
        }
    }
    
}


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
    @IBOutlet weak var daysCollectionView: UICollectionView!
    @IBOutlet weak var daysCollectionViewHeight: NSLayoutConstraint?
    //@IBOutlet weak var tagList: TagList!
    //@IBOutlet weak var tagListViewHeight: NSLayoutConstraint?
    @IBOutlet var lblPostTime: UILabel!
    @IBOutlet var lblApplied: UILabel!
    var jobTypeDates = [String]()
    weak var delegate: DentistDetailCellDelegate?
    
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
    
    func setCellData(job: Job) {
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
        var partTimeJobDays = [String]()
        if job.isSunday == 1 {
            partTimeJobDays.append(Constants.DaysAbbreviation.sunday)
        }
        if job.isMonday == 1 {
            partTimeJobDays.append(Constants.DaysAbbreviation.monday)
        }
        if job.isTuesday == 1 {
            partTimeJobDays.append(Constants.DaysAbbreviation.tuesday)
        }
        if job.isWednesday == 1 {
            partTimeJobDays.append(Constants.DaysAbbreviation.wednesday)
        }
        if job.isThursday == 1 {
            partTimeJobDays.append(Constants.DaysAbbreviation.thursday)
        }
        if job.isFriday == 1 {
            partTimeJobDays.append(Constants.DaysAbbreviation.friday)
        }
        if job.isSaturday == 1 {
            partTimeJobDays.append(Constants.DaysAbbreviation.saturday)
        }
        //lblDays.text = partTimeJobDays.joined(separator: Constants.Strings.comma + Constants.Strings.whiteSpace)
        if job.jobPostedTimeGap == Constants.Strings.zero {
            lblPostTime.text = Constants.Strings.today.uppercased()
        } else if job.jobPostedTimeGap == Constants.Strings.one {
            lblPostTime.text = job.jobPostedTimeGap + Constants.Strings.whiteSpace + Constants.Strings.dayAgo
        } else {
            lblPostTime.text = job.jobPostedTimeGap + Constants.Strings.whiteSpace + Constants.Strings.daysAgo
        }
        //tagList.tags.removeAll()
        if job.jobType == 3 {
            for date in job.jobTypeDates {
                self.jobTypeDates.append(Date.commonDateFormatEEMMDD(dateString: date))
            }
            self.daysCollectionView.reloadData()
            self.daysCollectionViewHeight?.constant = self.daysCollectionView.collectionViewLayout.collectionViewContentSize.height
            //self.tagListViewHeight?.constant = self.tagList.intrinsicContentSize.height
        }
        lblPercentSkill.text = String(format: "%.2f", job.percentSkillsMatch) + "%"
    }
}


extension TempJobDetailCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    // MARK: - UICollectionViewDataSource Methods
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        
        return self.jobTypeDates.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TagCell", for: indexPath) as! TagCell
        let name = jobTypeDates[indexPath.item]
        cell.setTag(with: name)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout _: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var width = CGFloat(0)
        let title = jobTypeDates[indexPath.item]
        width = title.widthWithConstrainetHeight(20, font: UIFont.fontRegular(fontSize: 10)!)
        return CGSize(width: width + 10, height: 20)
    }
    
}


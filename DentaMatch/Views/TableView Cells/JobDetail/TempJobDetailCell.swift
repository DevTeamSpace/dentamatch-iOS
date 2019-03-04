import UIKit
import RealmSwift

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
    @IBOutlet weak var messageButton: UIButton! {
        didSet {
            messageButton.layer.cornerRadius = 3.0
            messageButton.addTarget(self, action: #selector(messageButtonAction), for: .touchUpInside)
        }
    }
    
    var jobTypeDates = [String]()
    private var datesCount : Int = 0
    weak var delegate: DentistDetailCellDelegate?
    var isTagExpanded: Bool = false
    private let cellWidth: CGFloat =  70.0
    
    var chatObject: ChatObject?
    @objc private func messageButtonAction() {
        guard let chatObject = chatObject else { return }
        
        delegate?.openChat(chatObject: chatObject)
    }
    
    private var seeMoreHidden: Bool {
        if UIDevice.current.screenType == .iPhone6Plus {
            return self.datesCount < 8
        }
        return self.datesCount < 6
    }
    
    private var tagsCount: Int {
        if self.datesCount == 0 {
            return 0
        }
        if UIDevice.current.screenType == .iPhone6Plus {
            return isTagExpanded ? self.datesCount + 1 : minimumNumberOfItems
        }
        return isTagExpanded ? self.datesCount + 1 : minimumNumberOfItems
    }
    
    private var minimumNumberOfItems : Int {
        if UIDevice.current.screenType == .iPhone6Plus {
            return self.seeMoreHidden ? self.datesCount : 8
        }
        return self.seeMoreHidden ? self.datesCount : 6
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        btnJobType.layer.cornerRadius = 3
        lblApplied.isHidden = true
        daysCollectionView.register(UINib(nibName: "TagCell", bundle: nil), forCellWithReuseIdentifier: "TagCell")
        daysCollectionView.collectionViewLayout = DGCollectionViewLeftAlignFlowLayout()
    }
    
    @IBAction func actionFavourite(_: UIButton) {
        delegate?.saveOrUnsaveJob()
    }
    
    @IBAction func seeMoreAction(sender: UIButton) {
        sender.isSelected = !sender.isSelected
        delegate?.seeMoreTags(isExpanded: sender.isSelected)
    }
    
    func setCellData(job: Job, isTagExpanded: Bool = false, recruiterId: String?) {
        /* For Job status
         INVITED = 1
         APPLIED = 2
         SHORTLISTED = 3
         HIRED = 4
         REJECTED = 5
         CANCELLED = 6
         */
        if let recruiterId = recruiterId {
            let isBlockedFromSeeker = try! Realm().objects(ChatListModel.self)
                .first(where: { $0.recruiterId == String(recruiterId) })?.isBlockedFromSeeker ?? false
            chatObject = ChatObject(recruiterId: recruiterId, officeName: job.officeName, isBlockFromSeeker: isBlockedFromSeeker)
        }
        
        messageButton.isHidden = true
        lblApplied.isHidden = true
        lblApplied.textColor = Constants.Color.jobAppliedGreenColor
        switch job.isApplied {
        case 1:
            lblApplied.text = "INVITED"
            lblApplied.isHidden = false
            messageButton.isHidden = !(recruiterId != nil)
            
        case 2:
            lblApplied.text = "APPLIED"
            lblApplied.isHidden = false
            
        case 3:
            lblApplied.text = "INTERVIEWING"
            lblApplied.isHidden = false
            messageButton.isHidden = !(recruiterId != nil)
            
        case 4:
            lblApplied.text = "HIRED"
            lblApplied.isHidden = false
            messageButton.isHidden = !(recruiterId != nil)
        case 5:
            lblApplied.text = "REJECTED"
            lblApplied.isHidden = false
            lblApplied.textColor = Constants.Color.rejectedJobColor
        case 6:
            lblApplied.text = "CANCELLED"
            lblApplied.isHidden = false
            lblApplied.textColor = Constants.Color.cancelledJobColor
            
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
            self.datesCount = self.jobTypeDates.count
            self.daysCollectionView.reloadData()
            self.isTagExpanded = isTagExpanded
            self.daysCollectionViewHeight?.constant = self.daysCollectionView.collectionViewLayout.collectionViewContentSize.height
        }
        self.lblPercentSkill.text = String(format: "%.2f", job.percentSkillsMatch) + "%"
    }
}


extension TempJobDetailCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    // MARK: - UICollectionViewDataSource Methods
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        return self.tagsCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TagCell", for: indexPath) as! TagCell
        if (indexPath.item == self.tagsCount - 1) && !self.seeMoreHidden {
            let text = self.isTagExpanded ? "See Less" : "See More"
            cell.setTag(with: text, type: .seeMore)
        }else{
            let name = self.jobTypeDates[indexPath.item]
            cell.setTag(with: name)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout _: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.cellWidth , height: 20.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: false)
        if indexPath.item == self.tagsCount - 1 && !self.seeMoreHidden {
            self.isTagExpanded = !self.isTagExpanded
            self.delegate?.seeMoreTags(isExpanded: self.isTagExpanded)
        }
    }
    
}


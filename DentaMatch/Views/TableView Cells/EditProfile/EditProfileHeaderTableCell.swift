//
//  EditProfileHeaderTableCell.swift
//  DentaMatch
//
//  Created by Rajan Maheshwari on 17/01/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit
protocol EditProfileHeaderTableCellDelegate: class {
    func showNotificationList()
}
class EditProfileHeaderTableCell: UITableViewCell {
    @IBOutlet var settingButton: UIButton!
    @IBOutlet var editButton: UIButton!
    @IBOutlet var placeLabel: UILabel!

    @IBOutlet var statusButton: UIButton!
    @IBOutlet var aboutTextView: UITextView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var profileButton: ProfileImageButton!
    @IBOutlet var bellButton: UIButton!
    @IBOutlet var notificationLabel: UILabel!
    weak var delegate: EditProfileHeaderTableCellDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        // self.aboutTextView.textContainer.lineFragmentPadding = 20.0
        clipsToBounds = true
        placeLabel.numberOfLines = 3
        // Initialization code
        bellButton.setTitle(Constants.DesignFont.notification, for: .normal)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func fillPlaceAndJobTitle(jobTitle: String, place: String) -> NSMutableAttributedString {
        if jobTitle.isEmptyField {
            let attributedString = NSMutableAttributedString()
            let placeText = NSAttributedString(string: place, attributes: [NSAttributedString.Key.font: UIFont.fontRegular(fontSize: 16.0), NSAttributedString.Key.foregroundColor: UIColor.white])
            attributedString.append(placeText)
            return attributedString
        } else {
            let attributedString = NSMutableAttributedString()
            let jobTitleText = NSAttributedString(string: jobTitle, attributes: [NSAttributedString.Key.font: UIFont.fontSemiBold(fontSize: 16.0), NSAttributedString.Key.foregroundColor: UIColor.white])
            let placeText = NSAttributedString(string: place, attributes: [NSAttributedString.Key.font: UIFont.fontRegular(fontSize: 16.0), NSAttributedString.Key.foregroundColor: UIColor.white])
            attributedString.append(jobTitleText)
            attributedString.append(NSAttributedString(string: "\n"))
            attributedString.append(placeText)
            return attributedString
        }
    }

    class func calculateHeight(text: String) -> CGFloat {
        let textView = UITextView()
        textView.font = UIFont.fontRegular(fontSize: 16.0)
        var newFrame: CGRect!
        textView.text = text

        let fixedWidth = UIScreen.main.bounds.width - 40
        textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        let newSize = textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        newFrame = textView.frame
        newFrame.size = CGSize(width: max(newSize.width, fixedWidth), height: newSize.height)

        // debugPrint("height \(newFrame.height)")
        if newFrame.height + 10 > 109 {
            return 109
        } else {
            return newFrame.height + 10
        }
    }
    
    /*func customLeftBarButton()  {
        notificationLabel = UILabel(frame: CGRect(x: 10, y: 0, width: 15, height: 15))
        notificationLabel?.backgroundColor = UIColor.red
        notificationLabel?.layer.cornerRadius = (notificationLabel?.bounds.size.height)! / 2
        notificationLabel?.font = UIFont.fontRegular(fontSize: 10)
        notificationLabel?.textAlignment = .center
        notificationLabel?.textColor = UIColor.white
        notificationLabel?.clipsToBounds = true
        notificationLabel?.text = ""
        notificationLabel?.isHidden = true
        let customButton = UIButton(type: .system)
        customButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        customButton.titleLabel?.font = UIFont.designFont(fontSize: 18)
        customButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 0)
        customButton.setTitle(Constants.DesignFont.notification, for: .normal)
        //customButton.addTarget(self, action: #selector(actionLeftNavigationItem), for: .touchUpInside)
        customButton.addSubview(notificationLabel!)
        self.contentView.addSubview(customButton)
        
    }*/
    
    func updateBadge(){
        self.setNotificationLabelText(count: AppDelegate.delegate().badgeCount())
    }
    
   private func setNotificationLabelText(count: Int) {
        if count != 0 {
            notificationLabel?.text = "\(count)"
            notificationLabel?.isHidden = false
            notificationLabel?.adjustsFontSizeToFitWidth = true
            
        } else {
            notificationLabel?.isHidden = true
        }
    }
    
    @IBAction func openNotificationList(_:Any){
        delegate?.showNotificationList()
    }
}

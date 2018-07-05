//
//  MessageSenderTableCell.swift
//  DentaMatch
//
//  Created by Rajan Maheshwari on 06/02/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

class MessageSenderTableCell: UITableViewCell {
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var chatTextView: UITextView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        chatTextView.layer.cornerRadius = 5.0
        chatTextView.textContainerInset = UIEdgeInsets(top: 9, left: 8, bottom: 8, right: 8)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    class func requiredHeight(message: String) -> CGFloat {
        let font = UIFont.fontRegular(fontSize: 14.0)

        var label: UILabel!
        label = UILabel(frame: CGRect(x: 0, y: 0, width: 260, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = message
        label.sizeToFit()

        return label.frame.height + 50
    }

    class func calculateHeight(text: String) -> CGFloat {
        let textView = UITextView()
        textView.font = UIFont.fontRegular(fontSize: 14.0)!
        var newFrame: CGRect!
        textView.text = text

        let fixedWidth: CGFloat = 260
        textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        let newSize = textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        newFrame = textView.frame
        newFrame.size = CGSize(width: max(newSize.width, fixedWidth), height: newSize.height)
        // self.chatTextView.frame = newFrame
        return newFrame.height + 40
    }
}

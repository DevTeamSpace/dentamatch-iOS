//
//  MessageSenderTableCell.swift
//  DentaMatch
//
//  Created by Rajan Maheshwari on 06/02/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

class MessageSenderTableCell: UITableViewCell {
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var bubbleView: UIView!
    @IBOutlet weak var chatMessageLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.bubbleView.layer.cornerRadius = 5.0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    class func requiredHeight(message:String) -> CGFloat{
        let font = UIFont.fontRegular(fontSize: 14.0)
        
        var label:UILabel!
        label = UILabel(frame: CGRect(x:0, y:0, width:260, height:CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = message
        label.sizeToFit()
        
        return label.frame.height + 50
    }
    
}

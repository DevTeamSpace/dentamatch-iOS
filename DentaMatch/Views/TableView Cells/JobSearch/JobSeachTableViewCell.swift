//
//  JobSeachTableViewCell.swift
//  DentaMatch
//
//  Created by Shailesh Tyagi on 06/01/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

class JobSeachTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var lblJobTitle: UILabel!
    @IBOutlet weak var JobSeachTableViewCell: UIButton!
    @IBOutlet weak var scrollViewJobTitle: UIScrollView!
    @IBOutlet weak var btnCheckFullTime: UIButton!
    @IBOutlet weak var btnCheckPartTime: UIButton!
    @IBOutlet weak var lblLocation: UILabel!
    
    @IBOutlet weak var viewWeakDays: UIView!
    @IBOutlet weak var btnSunday: UIButton!
    @IBOutlet weak var btnMonday: UIButton!
    @IBOutlet weak var btnTuesday: UIButton!
    @IBOutlet weak var btnWednesday: UIButton!
    @IBOutlet weak var btnThursday: UIButton!
    @IBOutlet weak var btnFriday: UIButton!
    
    @IBOutlet weak var viewJobTitle: UIView!
    @IBOutlet weak var viewJobType: UIView!
    @IBOutlet weak var viewCurrLocation: UIView!
    @IBOutlet weak var btnSaturday: UIButton!
    
    var jobTitleArr : [NSString] = ["asadasd", "sadfsdf", "asdfsadf", "asadasd", "sa", "asdfsadf", "asadasd", "sadfsdf", "asdfsadf", "asadasd", "sadfsdf", "asdfsadf"]
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.setUpUIControls()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func setUpUIControls() {
        btnThursday.layer.cornerRadius = btnThursday.frame.size.height / 2
        btnThursday.backgroundColor = UIColor.init(colorLiteralRed: 142.0/255.0, green: 207.0/255.0, blue: 125.0/255.0, alpha: 1.0)
        btnThursday.titleLabel?.textColor = UIColor.white
        
        btnFriday.layer.cornerRadius = btnFriday.frame.size.height / 2
        btnFriday.backgroundColor = UIColor.init(colorLiteralRed: 142.0/255.0, green: 207.0/255.0, blue: 125.0/255.0, alpha: 1.0)
        btnFriday.titleLabel?.textColor = UIColor.white
        
        viewJobTitle.layer.borderColor = UIColor.init(colorLiteralRed: 229.0/255.0, green: 229.0/255.0, blue: 229.0/255.0, alpha: 1.0).cgColor
        viewJobTitle.layer.borderWidth = 1.0
        
        viewJobType.layer.borderColor = UIColor.init(colorLiteralRed: 229.0/255.0, green: 229.0/255.0, blue: 229.0/255.0, alpha: 1.0).cgColor
        viewJobType.layer.borderWidth = 1.0
        
        viewCurrLocation.layer.borderColor = UIColor.init(colorLiteralRed: 229.0/255.0, green: 229.0/255.0, blue: 229.0/255.0, alpha: 1.0).cgColor
        viewCurrLocation.layer.borderWidth = 1.0
        
        viewWeakDays.layer.borderColor = UIColor.init(colorLiteralRed: 229.0/255.0, green: 229.0/255.0, blue: 229.0/255.0, alpha: 1.0).cgColor
        viewWeakDays.layer.borderWidth = 1.0
    }
    
    func updateJobTitle(){
        
        self.scrollViewJobTitle.subviews.forEach ({
            if $0 is UILabel {
                $0.removeFromSuperview()
            }
        })
        
        var topMargin : CGFloat = 5.0;
        var leftMargin : CGFloat = 0.0;
        let rightMargin : CGFloat = 8.0;
        var totalHeight : CGFloat = 5.0;
        let widthPadding :CGFloat = 10.0
        let heightPadding :CGFloat = 5.0
        
        for title in jobTitleArr {
            let font = UIFont.fontRegular(fontSize: 14.0)
            
            let textAttributes = [NSFontAttributeName: font]
            let textSize = title.boundingRect(with: CGSize(width : self.frame.size.width,height : 30), options: .usesLineFragmentOrigin, attributes: textAttributes, context: nil)
            
            if leftMargin + textSize.width + rightMargin + widthPadding >= self.scrollViewJobTitle.frame.size.width{
                leftMargin = 5.0
                topMargin =  topMargin + textSize.height + heightPadding + 5.0
            }
            
            let label = UILabel(frame: CGRect(x : leftMargin,y : topMargin,width : textSize.width + widthPadding,height :  34.0))
            label.textAlignment = NSTextAlignment.center
            label.font = font
            label.textColor = UIColor(red: 169.0/255.0, green: 169.0/255.0, blue: 169.0/255.0, alpha: 1.0)
            label.text = title as String
            label.layer.borderWidth  = 1
            label.layer.borderColor = UIColor(red: 169.0/255.0, green: 169.0/255.0, blue: 169.0/255.0, alpha: 1.0).cgColor
            label.layer.cornerRadius = 10.0
            label.clipsToBounds = true
            self.scrollViewJobTitle.addSubview(label)
            leftMargin = leftMargin + textSize.width + widthPadding + 5.0
            totalHeight =  topMargin + textSize.height + heightPadding + 5.0
            
        }
        
        self.scrollViewJobTitle.contentSize = CGSize(width : self.scrollViewJobTitle.frame.size.width,height : totalHeight + 10)
        
        // Set scrollview height equals to totlaHeight
        
        
    }
    
}

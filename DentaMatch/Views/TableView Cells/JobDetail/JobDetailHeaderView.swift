//
//  JobDetailHeaderView.swift
//  DentaMatch
//
//  Created by Shailesh Tyagi on 20/01/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

class JobDetailHeaderView: UIView {
    
    @IBOutlet weak var btnIcon: UIButton!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var viewParent: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        viewParent.layer.borderColor = Constants.Color.jobSearchBorderColor.cgColor
        viewParent.layer.borderWidth = 1.0
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //fatalError("init(coder:) has not been implemented")
    }
    
    func setHeaderData(iconText : String, headerText : String) {
        self.btnIcon.titleLabel?.text = iconText
        self.lblDescription?.text = headerText
    }

}

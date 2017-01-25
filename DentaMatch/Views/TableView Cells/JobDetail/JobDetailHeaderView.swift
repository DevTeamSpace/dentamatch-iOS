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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        let nib =  Bundle.main.loadNibNamed("JobDetailHeaderView", owner: self, options: nil)
        self.addSubview(nib?.last as! UIView)
        //self.viewParent.layer.borderWidth = 1.0
        //self.viewParent.layer.borderColor = UIColor.init(colorLiteralRed: 229.0/255.0, green: 229.0/255.0, blue: 229.0/255.0, alpha: 1.0).cgColor
    }
    
    func setHeaderData(iconText : String, headerText : String) {
        self.btnIcon.titleLabel?.text = iconText
        self.lblDescription?.text = headerText
    }

}

//
//  JobSearchTypeCell.swift
//  DentaMatch
//
//  Created by Shailesh Tyagi on 09/01/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit



class JobSearchTypeCell: UITableViewCell {
    
    @IBOutlet weak var viewJobType: UIView!
    @IBOutlet weak var btnFullTime: UIButton!
    @IBOutlet weak var btnPartTime: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.setUp()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    
    func setUp() {
        viewJobType.layer.borderColor = UIColor.init(colorLiteralRed: 229.0/255.0, green: 229.0/255.0, blue: 229.0/255.0, alpha: 1.0).cgColor
        viewJobType.layer.borderWidth = 1.0
    }
    
    //MARK : IBOutlet Action
    
    @IBAction func actionFullTime(_ sender: UIButton) {
    }
    
    @IBAction func actionPartTime(_ sender: UIButton) {
    }
    
    
}

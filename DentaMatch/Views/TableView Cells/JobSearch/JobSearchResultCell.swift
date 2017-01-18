//
//  JobSearchResultCell.swift
//  DentaMatch
//
//  Created by Shailesh Tyagi on 12/01/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

class JobSearchResultCell: UITableViewCell {

    @IBOutlet weak var lblJobTitle: UILabel!
    @IBOutlet weak var lblFavourite: UIButton!
    @IBOutlet weak var lblType: UIButton!
    @IBOutlet weak var lblDistance: UILabel!
    @IBOutlet weak var lblDays: UILabel!
    @IBOutlet weak var lblDocName: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblJobPostTime: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.lblType.layer.cornerRadius = 3
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setCellData() {
        
    }
}

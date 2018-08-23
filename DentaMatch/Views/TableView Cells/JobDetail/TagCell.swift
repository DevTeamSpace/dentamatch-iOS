//
//  TagCell.swift
//  DentaMatch
//
//  Created by Prashant Gautam on 23/08/18.
//  Copyright © 2018 Appster. All rights reserved.
//

import UIKit

class TagCell: UICollectionViewCell {
    @IBOutlet private weak var textLabel: UILabel?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.textLabel?.font = UIFont.fontRegular(fontSize: 10)
        self.textLabel?.layer.cornerRadius = 10
        self.textLabel?.layer.masksToBounds = true
    }
    
    func setTag(with text: String) {
        self.textLabel?.text = text
    }

}

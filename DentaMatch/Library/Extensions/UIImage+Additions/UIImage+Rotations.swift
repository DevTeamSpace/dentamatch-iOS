//
//  UIImage+Rotations.swift
//  DentaMatch
//
//  Created by Rajan Maheshwari on 13/12/16.
//  Copyright © 2016 Appster. All rights reserved.
//

import Foundation

extension UIImage {
    func rotateImageWithScaling() -> UIImage {
        return UIImageRotate.scaleAndRotateImage(self)
    }
}

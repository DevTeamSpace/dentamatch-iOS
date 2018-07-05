//
//  UIView+Additions.swift
//  DentaMatch
//
//  Created by Rajan Maheshwari on 12/10/16.
//  Copyright © 2016 Appster. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    static func instanceFromNib<T: UIView>(type _: T.Type) -> T? {
        // debugPrint("type")
        var fullName: String = NSStringFromClass(T.self)
        if let range = fullName.range(of: ".", options: .backwards, range: nil, locale: nil) {
            fullName = fullName.substring(from: range.upperBound)
        }
        return UINib(nibName: fullName, bundle: nil).instantiate(withOwner: nil, options: nil)[0] as? T
    }

    static func makeTip(view: UIView, size: CGFloat, x _: CGFloat, y _: CGFloat) {
        // debugPrint("\(x) \(y)")
        let triangleLayer = CAShapeLayer()
        let trianglePath = UIBezierPath()

        trianglePath.move(to: CGPoint(x: view.bounds.size.width / 2 - size, y: view.bounds.size.height))
        trianglePath.addLine(to: CGPoint(x: view.bounds.size.width / 2, y: view.bounds.size.height - size))
        trianglePath.addLine(to: CGPoint(x: view.bounds.size.width / 2 + size, y: view.bounds.size.height))

        trianglePath.close()
        triangleLayer.path = trianglePath.cgPath
        triangleLayer.fillColor = UIColor.white.cgColor

        triangleLayer.name = "triangle"
        triangleLayer.zPosition = 2.0
        view.layer.addSublayer(triangleLayer)
    }

    static func removeTip(view: UIView) {
        for layer in view.layer.sublayers! {
            if layer.name == "triangle" {
                layer.removeFromSuperlayer()
            }
        }
    }
}

//
//  ZProgressAnimatedView.swift
//  ZProgressHUD
//
//  Created by ZhangZZZZ on 16/4/11.
//  Copyright © 2016年 ZhangZZZZ. All rights reserved.
//

import UIKit

class ZProgressAnimatedView: UIView {

    private var sharpLayer: CAShapeLayer?

    var radius: CGFloat = 18.0 {
        didSet {
            self.sharpLayer?.removeFromSuperlayer()
            self.sharpLayer = nil;
            if self.superview != nil {
                self.layoutAnimatedLayer()
            }
        }
    }
    
    var strokeThickness: CGFloat = 2.0 {
        didSet {
            self.sharpLayer?.lineWidth = self.strokeThickness
        }
    }
    
    var strokeColor: UIColor? {
        didSet {
            self.sharpLayer?.strokeColor = self.strokeColor?.cgColor
        }
    }
    var strokeEnd: CGFloat = 0.0 {
        didSet {
            self.sharpLayer?.strokeEnd = self.strokeEnd
        }
    }
    
    override var frame: CGRect {
        didSet {
            if self.frame.equalTo(super.frame) {
                super.frame = frame
                if self.superview != nil {
                    self.layoutAnimatedLayer()
                }
            }
        }
    }
    
    override func willMove(toSuperview newSuperview: UIView?) {
        if newSuperview == nil {
            self.sharpLayer?.removeFromSuperlayer()
            self.sharpLayer = nil
        } else {
            self.layer.addSublayer(self.animatedLayer())
            self.frame = self.sharpLayer!.bounds
        }
    }
    
    func layoutAnimatedLayer() {
        
        let widthDiff = self.bounds.width - self.sharpLayer!.bounds.width;
        let heightDiff = self.bounds.height - self.sharpLayer!.bounds.height;
        
        self.sharpLayer?.position = CGPoint(x:self.bounds.width - self.sharpLayer!.bounds.width / 2 - widthDiff / 2, y:self.bounds.height - self.sharpLayer!.bounds.height / 2 - heightDiff / 2);
    }
    
    private func animatedLayer() -> CAShapeLayer {
        if(self.sharpLayer != nil) {
            let arcCenter = CGPoint(x:self.radius+self.strokeThickness/2+5, y: self.radius+self.strokeThickness/2+5);
        let smoothedPath = UIBezierPath(arcCenter: arcCenter, radius: self.radius, startAngle: CGFloat(M_PI*3/2), endAngle: CGFloat(M_PI/2+M_PI*5), clockwise: true)
        self.sharpLayer = CAShapeLayer()
        self.sharpLayer?.contentsScale = UIScreen.main.scale
            
        self.sharpLayer?.frame = CGRect(x:0.0, y:0.0, width:arcCenter.x*2, height:arcCenter.y*2);
        self.sharpLayer?.fillColor = UIColor.clear.cgColor;
        self.sharpLayer?.strokeColor = self.strokeColor?.cgColor;
        self.sharpLayer?.lineWidth = self.strokeThickness;
        self.sharpLayer?.lineCap = kCALineCapRound;
        self.sharpLayer?.lineJoin = kCALineJoinBevel;
        self.sharpLayer?.path = smoothedPath.cgPath;
        }
        return self.sharpLayer!
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
            return CGSize(width:(self.radius+self.strokeThickness/2+5)*2, height:(self.radius+self.strokeThickness/2+5)*2)
    }
}

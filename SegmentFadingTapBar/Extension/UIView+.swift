//
//  UIView+.swift
//  SegmentFadingTapBar
//
//  Created by Neldrick on 28/2/2019.
//  Copyright © 2019 fundroots. All rights reserved.
//

import Foundation

extension UIView {
    func roundCorners(corners: UIRectCorner, radius: CGFloat, withBorder:Bool) -> CAShapeLayer? {
        
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        
        
        layer.mask = mask
        
        if withBorder{
            let borderPath = UIBezierPath.init(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
            let borderLayer = CAShapeLayer()
            borderLayer.path = borderPath.cgPath
            borderLayer.lineWidth = 1
            borderLayer.strokeColor = UIColor.black.cgColor
            borderLayer.fillColor = UIColor.clear.cgColor
            borderLayer.frame = self.bounds
            self.layer.addSublayer(borderLayer)
            return borderLayer
        }
        return nil
    }
}

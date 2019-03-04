//
//  UIScrollView+.swift
//  SegmentFadingTapBar
//
//  Created by Neldrick on 28/2/2019.
//  Copyright © 2019 fundroots. All rights reserved.
//

import Foundation

extension UIScrollView {
    
    var minContentOffset: CGPoint {
        return CGPoint(
            x: -contentInset.left,
            y: -contentInset.top)
    }
    
    var maxContentOffset: CGPoint {
        return CGPoint(
            x: contentSize.width - bounds.width + contentInset.right,
            y: contentSize.height - bounds.height + contentInset.bottom)
    }
    
    func scrollToMinContentOffset(animated: Bool) {
        setContentOffset(minContentOffset, animated: animated)
    }
    
    func scrollToMaxContentOffset(animated: Bool) {
        setContentOffset(maxContentOffset, animated: animated)
    }
}


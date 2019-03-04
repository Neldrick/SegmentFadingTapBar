//
//  SegmentFadingTapBarPreference.swift
//  SegmentFadingTapBar
//
//  Created by Neldrick on 4/3/2019.
//  Copyright © 2019 fundroots. All rights reserved.
//

import Foundation

public class SegmentFadingTapBarPreference{
    public var scrollSpeed:CGFloat = 0.3
    public var numberOfItemVisible = 4
    public var numberOfScalingItem = 3
    
    public var cellColor = UIColor.white
    public var selectedCellColor = UIColor.white
    public var normalTextColor = UIColor.white
    public var selectedTextColor = UIColor.white
    public var normalOpacity:CGFloat = 0.1
    public var fadingOpacity:CGFloat = 0.05
    public var onSelectedOpacity:CGFloat = 0.3
    public var normalTextOpacity:CGFloat = 0.8
    public var fadingTextOpacity:CGFloat = 0.65
    public var onSelectedTextOpacity:CGFloat = 1
    public var corneradius:CGFloat = 26
    public var cellFontSize:CGFloat? = nil
    public var withBorder:Bool = false
    
    public init(){
        
    }
}

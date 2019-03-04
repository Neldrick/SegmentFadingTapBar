//
//  SegmentFadingCollectionItem.swift
//  SegmentFadingTapBar
//
//  Created by Neldrick on 28/2/2019.
//  Copyright © 2019 fundroots. All rights reserved.
//

import UIKit

public class SegmentFadingCollectionItem: UICollectionViewCell {
    
    @IBOutlet weak var mainTextLabel: UILabel!
    @IBOutlet weak var labelLeading: NSLayoutConstraint!
    
    @IBOutlet weak var labelTrailing: NSLayoutConstraint!
    var borderLayer:CAShapeLayer?
    public override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    public func setupCell(fontSize:CGFloat, contents:[String], currentRow:Int, selectedRow:Int, preference:SegmentFadingTapBarPreference){
        
        mainTextLabel.text = contents[currentRow]
        mainTextLabel.font = mainTextLabel.font.withSize(fontSize)
        mainTextLabel.textColor = preference.normalTextColor.withAlphaComponent(preference.normalTextOpacity)
        
        
        if currentRow == selectedRow{
            self.backgroundColor = preference.selectedCellColor.withAlphaComponent(preference.onSelectedOpacity)
            mainTextLabel.textColor = preference.selectedTextColor.withAlphaComponent(preference.onSelectedTextOpacity)
        }else{
            self.backgroundColor = preference.cellColor.withAlphaComponent(preference.normalOpacity)
        }
       
        if borderLayer != nil {
            borderLayer?.removeFromSuperlayer()
        }
        self.layer.mask = nil
        
        if currentRow == 0 {
            borderLayer = self.roundCorners(corners: [.topLeft,.bottomLeft], radius: preference.corneradius, withBorder: preference.withBorder)
        }else if currentRow == contents.count - 1{
            borderLayer = self.roundCorners(corners: [.topRight,.bottomRight], radius: preference.corneradius, withBorder: preference.withBorder)
        }else{
            if preference.withBorder{
                self.layer.borderColor = UIColor.black.cgColor
                self.layer.borderWidth = 1
            }
        }
        
    }
    
    public func setBackgroundOpacity(_ type:OpacityType, preference:SegmentFadingTapBarPreference){
        if self.backgroundColor?.cgColor.alpha != preference.onSelectedOpacity{
            switch type {
            case .dimmer:
                self.backgroundColor =  preference.cellColor.withAlphaComponent(preference.fadingOpacity)
                self.mainTextLabel.textColor = preference.normalTextColor.withAlphaComponent(preference.fadingTextOpacity)
            case .normal:
                self.backgroundColor =  preference.cellColor.withAlphaComponent(preference.normalOpacity)
                self.mainTextLabel.textColor = preference.normalTextColor.withAlphaComponent(preference.normalTextOpacity)
            }
        }
       
    }
    
    public enum OpacityType{
        case dimmer
        case normal
    }
}

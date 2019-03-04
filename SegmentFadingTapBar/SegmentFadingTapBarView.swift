//
//  SegmentFadingTapBarView.swift
//  SegmentFadingTapBar
//
//  Created by Neldrick on 28/2/2019.
//  Copyright © 2019 fundroots. All rights reserved.
//

import UIKit

public class SegmentFadingTapBarView: UIView {
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    let reuseCellId = "segmentCell"
    
    public var delegate:SegmentFadingTapBarDelegate?
    public var preference:SegmentFadingTapBarPreference = SegmentFadingTapBarPreference()
    public var dataText:[String]?
    
    var isScalLoadPerfixRequired = true
    var isScalLoadSurfixRequired = false
    var selectedRow = -1
    
    
   
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    public override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "SegmentFadingTapBarView", bundle: bundle)
        self.contentView = nib.instantiate(withOwner: self, options: nil).first as? UIView
        self.addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    
        
        let layout = UICollectionViewFlowLayout()
        // The size of each item. Pick a suitable height so that the items do not get stacked:
        
        // The most important part:
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: collectionView.frame.width / CGFloat(preference.numberOfItemVisible), height: collectionView.frame.height)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        // Then initialize collectionView
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.collectionViewLayout = layout
        collectionView.decelerationRate = UIScrollView.DecelerationRate(rawValue: preference.scrollSpeed)
        
        collectionView.register(UINib(nibName: "SegmentFadingCollectionItem", bundle:bundle ), forCellWithReuseIdentifier: reuseCellId)
    }
}
extension SegmentFadingTapBarView:UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    private func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (dataText?.count ?? 0)
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseCellId, for: indexPath) as! SegmentFadingCollectionItem
        let fontSize = preference.cellFontSize ?? (collectionView.frame.width / CGFloat(preference.numberOfItemVisible) * 0.1)
        cell.setupCell(fontSize: fontSize, contents: dataText ?? [], currentRow: indexPath.row, selectedRow: selectedRow, preference: preference)
        
        if isScalLoadPerfixRequired{
            if indexPath.row >= preference.numberOfScalingItem{
                transform(cell)
                if indexPath.row == preference.numberOfItemVisible{
                    isScalLoadPerfixRequired = false
                }
            }
        }
        if isScalLoadSurfixRequired{
            if indexPath.row <= ((dataText?.count ?? 0) - preference.numberOfScalingItem - 1){
                transform(cell)
                if indexPath.row == ((dataText?.count ?? 0) - preference.numberOfScalingItem - 1){
                    isScalLoadSurfixRequired = false
                }
            }
        }
        
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = self.collectionView.frame.width / CGFloat(preference.numberOfItemVisible)
        return CGSize(width: width, height: collectionView.frame.height)
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if indexPath.row != selectedRow{
            selectedRow = indexPath.row
            let visibleCellRowIndex = collectionView.indexPathsForVisibleItems.filter{$0.row == 0 || $0.row == (dataText?.count ?? 0) - 1}
            if visibleCellRowIndex.first?.row == 0{
                isScalLoadPerfixRequired = true
            }else if visibleCellRowIndex.first?.row == (dataText?.count ?? 0) - 1 {
                isScalLoadSurfixRequired = true
            }
            collectionView.reloadData()
            DispatchQueue.main.async {
                collectionView.scrollToItem(at: indexPath, at:.centeredHorizontally , animated: true)
            }
            delegate?.onTap(index: indexPath.row)
        }
        
    }
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scaleCell(scrollView: scrollView, collectionView: self.collectionView)
    }
}
extension SegmentFadingTapBarView{
    func transform(_ cell:UICollectionViewCell,smaller:Bool = true){
        let scaleCell = cell as! SegmentFadingCollectionItem
        if smaller{
            scaleCell.transform = CGAffineTransform(scaleX: 1, y: 0.8)
            scaleCell.setBackgroundOpacity(.dimmer,preference: preference)
        }else{
            scaleCell.transform = CGAffineTransform.identity
            scaleCell.setBackgroundOpacity(.normal,preference: preference)
        }
    }
    
    func scaleCell(scrollView:UIScrollView,collectionView:UICollectionView){
        if collectionView.visibleCells.count >= preference.numberOfItemVisible {
            // x1.......center.......x2
            let visibleItemCount:CGFloat = CGFloat(preference.numberOfItemVisible)
            let numberOfScalingItemCount:CGFloat = CGFloat(preference.numberOfScalingItem)
            let centerX = scrollView.contentOffset.x + scrollView.frame.size.width/2
            let itemWidth:CGFloat = (collectionView.frame.width / visibleItemCount)
            // add 20% for onselect adjustment
            let x1 = centerX - (itemWidth * ((numberOfScalingItemCount )/2) + (itemWidth * 0.2))
            let x2 = centerX + (itemWidth * ((numberOfScalingItemCount )/2) - (itemWidth * 0.2))
            
            //TODO: find out [15] & [45]'s real ratio
            if scrollView.contentOffset.x < 15{
                for i in 0...self.collectionView.visibleCells.count-1{
                    let cell = self.collectionView.visibleCells[i]
                    if cell.center.x > (scrollView.contentOffset.x + (itemWidth * numberOfScalingItemCount)){
                        transform(cell)
                    }else{
                        transform(cell, smaller: false)
                    }
                }
            }else if scrollView.contentOffset.x >= (scrollView.maxContentOffset.x - 45) {
                for i in 0...self.collectionView.visibleCells.count-1{
                    let cell = self.collectionView.visibleCells[i]
                    let scaleDistance = (scrollView.contentOffset.x + (itemWidth * (visibleItemCount - numberOfScalingItemCount)))
                    if cell.center.x < scaleDistance{
                        transform(cell)
                    }else{
                        transform(cell, smaller: false)
                    }
                }
                
            }else{
                for i in 0...self.collectionView.visibleCells.count-1{
                    let cell = self.collectionView.visibleCells[i]
                    if  cell.center.x < x1 ||  cell.center.x > x2{
                        transform(cell)
                    }else{
                        transform(cell, smaller: false)
                    }
                }
            }
        }
    }
    
}



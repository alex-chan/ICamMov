//
//  FilterCollectionViewController.swift
//  ICamMov
//
//  Created by Alex Chan on 15/4/10.
//  Copyright (c) 2015年 sunset. All rights reserved.
//

import Foundation


enum FilterType{
    case Original
    case Filter0
    
}

protocol FilterCollectionViewDelegate {
    func filterSelected(filterIndex: Int)
    
}

class FilterCollectionViewController: UICollectionViewController, UICollectionViewDataSource, UICollectionViewDelegate{
    
    
    
    var delegate: FilterCollectionViewDelegate?
    
    var curSelectedCellIndex:  NSIndexPath? {
        didSet {
            delegate?.filterSelected(curSelectedCellIndex!.item) // After selected, I could not be nil again
        }
    }
    
    
    // MARK: UICollectionViewDataSource
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        var cell = collectionView.dequeueReusableCellWithReuseIdentifier("FilterReuseID", forIndexPath: indexPath) as FilterCollectionViewCell
//        cell.backgroundColor = UIColor.appGlobalColor()
        
        
        var imageName = "filter\(indexPath.item)"
        if indexPath.item <= 9 {
            imageName = "filter0\(indexPath.item)"
        }
        
        cell.filterImage.image = UIImage(named: imageName)
        cell.filterName.text = imageName
        
        if indexPath == curSelectedCellIndex {
            cell.backgroundColor = UIColor.appGlobalColor()
        }else{
            cell.backgroundColor = UIColor.clearColor()
        }
        
        
        return cell
    }
    
    
    // MARK: UICollectionViewDelegates
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        var cell = collectionView.cellForItemAtIndexPath(indexPath)
        if curSelectedCellIndex != nil {
            collectionView.cellForItemAtIndexPath(curSelectedCellIndex!)?.backgroundColor = UIColor.clearColor()
        }
        cell?.backgroundColor = UIColor.appGlobalColor()
        curSelectedCellIndex = indexPath
    }
}
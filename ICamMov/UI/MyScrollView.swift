//
//  MyScrollView.swift
//  ICamMov
//
//  Created by Alex Chan on 15/4/15.
//  Copyright (c) 2015年 sunset. All rights reserved.
//

import Foundation
import UIKit


class MyScrollView: UIScrollView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.adjustContentSize()
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.adjustContentSize()
        
    }
    
    func adjustContentSize(){
        
        println("frame: \(self.frame)")
        println("bounds: \(self.bounds)")
        println("contentSize: \(self.contentSize)")
        println("center: \(self.center)")
        var maxY = CGFloat(0)
        
        for view in self.subviews {
            println("subFrame:\(view.frame)")
            println("subBound:\(view.bounds)")
            
            var y = CGRectGetMaxY(view.frame)
            maxY = max(maxY, y)
        }
        
        maxY = max(maxY, self.frame.size.height+40 )
        
        println("contentSize Height:\(self.contentSize.height)")
        self.contentSize.height = maxY
//        self.contentSize.width = self.bounds.size.width
        println("contentSize Height:\(self.contentSize.height)")
        
    }
}
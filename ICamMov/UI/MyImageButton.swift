//
//  MyImageButton.swift
//  ICamMov
//
//  Created by Alex Chan on 15/4/10.
//  Copyright (c) 2015年 sunset. All rights reserved.
//

import Foundation


class MyImageButton: UIButton {
    
    override class func buttonWithType(buttonType: UIButtonType)->AnyObject{
        
        
        var button = super.buttonWithType(buttonType) as UIButton
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Center
        button.contentVerticalAlignment = UIControlContentVerticalAlignment.Center
        
        return button
        
    }
    
}
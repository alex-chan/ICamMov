//
//  SunsetOutput.swift
//  UsetCoreImage
//
//  Created by Alex Chan on 15/4/1.
//  Copyright (c) 2015年 Alex Chan. All rights reserved.
//

import Foundation


class SunsetOutput: NSObject{
    
    
    var targets : [SunsetInputDelegate] = []
    
    func addTarget(target: SunsetInputDelegate){
        
//        for obj  in targets {
//            if equal(target, obj){
//                return
//            }
//            
//        }
        
        targets.append(target)
        
    }
    
    func start(){
        
    }
    
}
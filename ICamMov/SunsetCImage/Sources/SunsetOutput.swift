//
//  SunsetOutput.swift
//  UsetCoreImage
//
//  Created by Alex Chan on 15/4/1.
//  Copyright (c) 2015年 Alex Chan. All rights reserved.
//

import Foundation


class SunsetOutput: NSObject{
    
    
    var targets : [SunsetInputDelegate] = []  //TODO: Use Dollar.swift? https://github.com/ankurp/Dollar.swift
    
    func addTarget(target: SunsetInputDelegate){
        
//        for obj  in targets {
//            if equal(target, obj){
//                return
//            }
//            
//        }
        
        targets.append(target)
        
    }
    
    func removeTarget(target: SunsetInputDelegate){
        for (index, value) in enumerate(targets){
            
            if value === target {
                targets.removeAtIndex(index)
                break
            }
        }
    }
    
    func removeAll(){
        targets.removeAll(keepCapacity: false)
    }
            
    
    func movieDuration(){
        
    }
    
    
    func start(){
        
    }
    
}
//
//  SunsetView.swift
//  UsetCoreImage
//
//  Created by Alex Chan on 15/4/1.
//  Copyright (c) 2015年 Alex Chan. All rights reserved.
//

import Foundation
import UIKit

class SunsetView: UIView, SunsetInputDelegate {
    
    
    enum FillType{
        case StretchFill
        case KeepRatioFill
        case KeepRatio
    }
    
    
    var duration : CGFloat?
    
    
    var fillMode: String  = kCAGravityResizeAspect
    

    
    func processMovieFrame(pixelBuffer: CVPixelBuffer) {
        
                var ciImage =  CIImage(CVPixelBuffer: pixelBuffer)
        var tempContext = CIContext(options: nil)
        
        var width = CGFloat(CVPixelBufferGetWidth(pixelBuffer))
        var height =  CGFloat( CVPixelBufferGetHeight(pixelBuffer) )
        
        
        var size = self.frame.size
        
        println("processMovieFrame, height:\(height), width:\(width)")
        
        
        var videoImage = tempContext.createCGImage(ciImage, fromRect: CGRectMake(0, 0, width, height))

        self.dispatchCGImage(videoImage)


    }
    
    
    func processAudioData(sampleBuffer: CMSampleBuffer) {
        // TODO: XXX
    }
    
    func dispatchCGImage(cgImage: CGImage){
        
//        println("dispatchCGImage")
        
        self.layer.contents = cgImage
        self.layer.contentsGravity = fillMode
        
    }

    func setMovieDuration(duration: CMTime) {
        var d = CMTimeGetSeconds(duration)
        
        self.duration = CGFloat(d)
        
        
    }
    
    
    
}
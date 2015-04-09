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
    
    
    var fillMode: String  = kCAGravityResizeAspect
    
    func processMovieFrame(pixelBuffer: CVPixelBuffer) {
        
        println("processMovieFrame")
        var ciImage =  CIImage(CVPixelBuffer: pixelBuffer)
        var tempContext = CIContext(options: nil)
        
        var width = CGFloat(CVPixelBufferGetWidth(pixelBuffer))
        var height =  CGFloat( CVPixelBufferGetHeight(pixelBuffer) )
        
        
        var size = self.frame.size
        
      
        
        
        var videoImage = tempContext.createCGImage(ciImage, fromRect: CGRectMake(0, 0, width, height))

        
        self.layer.contentsGravity = fillMode        
        self.layer.contents = kCAGravityBottomRight

//        self.layer.contentsScale = 2
        
//        self.layer.contentsRect = CGRectMake(0, 0, 1.5, 0.5)
        
    }
    
//    func prepareAudioData(maxFrames: CMItemCount, asbd: UnsafePointer<AudioStreamBasicDescription>) {
//        //
//    }
//    
//    func processAudioData(audioData: UnsafeMutablePointer<AudioBufferList>, framesNumber: UInt32) {
//        //
//    }
    
    func processAudioData(sampleBuffer: CMSampleBuffer) {
        // TODO: XXX
    }
    
    func dispatchCGImage(cgImage: CGImage){
        
        self.layer.contents = cgImage
    }
    
    
    
}
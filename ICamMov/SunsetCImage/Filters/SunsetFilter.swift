//
//  SunsetFilters.swift
//  UsetCoreImage
//
//  Created by Alex Chan on 15/4/1.
//  Copyright (c) 2015年 Alex Chan. All rights reserved.
//

import Foundation
import CoreImage

class SunsetFilter: SunsetOutput, SunsetInputDelegate  {
    
    
    var context: CIContext?
    var filter: CIFilter?
    var filterName: String?
    
    init(name: String){
        
        super.init()
        
        self.filterName = name
        self.setupContext()
    }
    
    func setupContext(){
        context = CIContext(options: nil)
        filter = CIFilter(name: filterName)
        
        
    }
    
//    func setFilterValue(value: AnyObject, forKey key: AnyObject){
//        filter!.setValue(value, forKey:key)
//        
//    }
    
    
    func applyFilter(ciImage: CIImage){
        
        filter!.setValue(ciImage, forKey: kCIInputImageKey)
        
        var outputImage = filter!.outputImage
        var cgImage = context!.createCGImage(outputImage, fromRect: outputImage.extent())
        
        
        for target in targets{
            target.dispatchCGImage(cgImage)
        }
        
    }
    
    func processMovieFrame(pixelBuffer: CVPixelBuffer) -> Void  {
        var ciImage = CIImage(CVPixelBuffer: pixelBuffer)
        
        self.applyFilter(ciImage)
        
    }
    
//    func prepareAudioData(maxFrames: CMItemCount, asbd: UnsafePointer<AudioStreamBasicDescription>) {
//        // TODO: XXX
//        return
//    }
    
    func processAudioData(sampleBuffer: CMSampleBuffer) {
        // TODO: XXX
        return 
    }
    
//    func processAudioData(audioData: UnsafeMutablePointer<AudioBufferList>, framesNumber: UInt32) {
//        for target in targets {
//            target.processAudioData(audioData, framesNumber: framesNumber)
//        }
//    }
    
    func dispatchCGImage(cgImage: CGImage){
        // we just ignore this method in filter
    }
    
}
//
//  SunsetInput.swift
//  UsetCoreImage
//
//  Created by Alex Chan on 15/4/1.
//  Copyright (c) 2015年 Alex Chan. All rights reserved.
//

import Foundation
import AVFoundation


protocol SunsetInputDelegate : NSObjectProtocol  {
    
    
    
    func processMovieFrame(pixelBuffer: CVPixelBuffer) -> Void
    func dispatchCGImage(image: CGImage) -> Void
//    func processAudioData(audioData: UnsafeMutablePointer<AudioBufferList>, framesNumber: UInt32) -> Void
    func processAudioData(sampleBuffer: CMSampleBuffer) -> Void
//    func prepareAudioData(maxFrames: CMItemCount, asbd: UnsafePointer<AudioStreamBasicDescription>) -> Void
    
//    func setMovieSize(size: CGSize) -> Void // Do not use , neither, just get it from SunsetMovie
//    
//    func setMovieDuration(duration: CMTime) -> Void // Seems not used, SunsetAVPlayerViewController observe duration from SunsetMovie
    

}
//
//  SunsetMovie.swift
//  UsetCoreImage
//
//  Created by Alex Chan on 15/4/1.
//  Copyright (c) 2015年 Alex Chan. All rights reserved.
//

import Foundation
import AVFoundation

class SunsetMovie: SunsetOutput, AVPlayerItemOutputPullDelegate, SunsetAudioTapProcessorDelegate {
    
    var player: AVPlayer!
    var playerItem: AVPlayerItem?
    var displayLink: CADisplayLink!
    var videoProcessQueue: dispatch_queue_t!
    
    var videoOutput: AVPlayerItemVideoOutput!
    var url: NSURL?

    var audioMix: AVAudioMix?
    
    var audioTapProcessor: SunsetAudioTapProcessor?
    
    init(URL: NSURL) {
        
        super.init()
        
        url = URL
        player = AVPlayer()
        
        displayLink = CADisplayLink(target: self, selector: "displayLinkCallback:")
        displayLink.addToRunLoop(NSRunLoop.currentRunLoop(), forMode: NSDefaultRunLoopMode)
        displayLink.paused = true
        
        // TODO: Get to know pixel formate type
        var pixBuffAttributes : [NSObject: AnyObject] = [ kCVPixelBufferPixelFormatTypeKey: kCVPixelFormatType_420YpCbCr8BiPlanarVideoRange]
        
        
        videoOutput = AVPlayerItemVideoOutput(pixelBufferAttributes: pixBuffAttributes)
        videoProcessQueue = dispatch_queue_create("sunsetVideoProcessQueue", DISPATCH_QUEUE_SERIAL)
        videoOutput.setDelegate(self, queue: videoProcessQueue)
        
        

        
    }
    
    override func start() {
        dispatch_async(videoProcessQueue, {
            self.processURL()
        })
    }
    
    func pause(){
        self.player.pause()
    }
    
    func play(){
        self.player.play()
    }
    
    func getAudioMix(asset: AVAsset) -> AVAudioMix?{
        if audioTapProcessor != nil {
            return audioTapProcessor!.audioMix
        }

 
        var audioTrack: AVAssetTrack?
        
        for track in asset.tracks as [AVAssetTrack]{
            if track.mediaType == AVMediaTypeAudio {
                audioTrack = track
                break
            }
        }
        
        if audioTrack == nil{
            return nil
        }
        
        
        audioTapProcessor = SunsetAudioTapProcessor(audioAssetTrack: audioTrack)
        
        if audioTapProcessor != nil {
            audioTapProcessor!.delegate = self
            return audioTapProcessor!.audioMix
        }
        
        
        return nil

    }
    


    
    
    func processURL(){
        println("processURL")
        playerItem = AVPlayerItem(URL: self.url)
        var asset = playerItem!.asset
        
        self.playerItem?.addOutput(self.videoOutput)
        self.player.replaceCurrentItemWithPlayerItem(self.playerItem!)
        self.videoOutput.requestNotificationOfMediaDataChangeWithAdvanceInterval(0.1)
        
        if let audioMix = self.getAudioMix(asset){
            self.playerItem!.audioMix = audioMix
        }
        
        
        self.player.play()
        
        
//        asset.loadValuesAsynchronouslyForKeys(["tracks"], completionHandler: {
//            if asset.statusOfValueForKey("tracks", error: nil) == .Loaded{
//                var tracks = asset.tracksWithMediaType(AVMediaTypeVideo)
//                if tracks.count > 0 {
//                    var videoTrack = tracks[0]
//                    
//                    self.playerItem?.addOutput(self.videoOutput)
//                    self.player.replaceCurrentItemWithPlayerItem(self.playerItem!)
//                    self.videoOutput.requestNotificationOfMediaDataChangeWithAdvanceInterval(0.1)
//                    dispatch_async(dispatch_get_main_queue(), {
//                        self.player.play()
//                    })
//                    
//                }
//                
//            }
//        })
        
    }
    
    
    
    // MARK: AVPlayerItemOutputPullDelegate Delegates
    
    func outputMediaDataWillChange(sender: AVPlayerItemOutput!) {
        displayLink.paused = false
    }
    
    
    // MARK: CADisplayLink Callback
    func displayLinkCallback(sender: CADisplayLink){
        var outputItemTime = kCMTimeInvalid
        var nextVSync = sender.timestamp + sender.duration
        
        
        outputItemTime = videoOutput.itemTimeForHostTime(nextVSync)
        
        if videoOutput.hasNewPixelBufferForItemTime(outputItemTime){
            var pixelBuffer : CVPixelBuffer?
            pixelBuffer = videoOutput.copyPixelBufferForItemTime(outputItemTime, itemTimeForDisplay: nil)
//            println("pixelBuffer:\(pixelBuffer)")
            
            for target in targets {
                target.processMovieFrame(pixelBuffer!)
            }
            
        }else{
//            println("no new pixel buffer for time:\(outputItemTime.value)")
        }
        
        
    }
    
    // MARK: SunsetAudioTapProcessorDelegate
//    func audioTapProcessor(audioTapProcessor: SunsetAudioTapProcessor!, audioData bufferList: UnsafeMutablePointer<AudioBufferList>, framesNumber: UInt32) {
////        println("audioTapProcessor")
//        for target in targets {
//            target.processAudioData(bufferList, framesNumber:framesNumber)
//        }
//    }
    
    func audioTapProcessor(audioTapProcessor: SunsetAudioTapProcessor!, sampleBuffer: CMSampleBuffer!) {
        for target in targets {
            target.processAudioData(sampleBuffer)
        }
    }
    
//    func audioTapPrepare(audioTapProcessor: SunsetAudioTapProcessor!, maxFrames: CMItemCount, asbd: UnsafePointer<AudioStreamBasicDescription>) {
//        for target in targets {
//            target.prepareAudioData(maxFrames, asbd: asbd)
//        }
//    }
    
}
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
    var videoProcessQueue: dispatch_queue_t
    
    var videoOutput: AVPlayerItemVideoOutput?
    var url: NSURL?

    var audioMix: AVAudioMix?
    
    var audioTapProcessor: SunsetAudioTapProcessor?
    
    
    // TODO: This is strange, If I change NSNumber to NSInteger, it will raise no-KVC compliant excpetion
    var duration: NSNumber?
    var playedTimePercent: NSNumber? //  indicate the played time percent form 0.0 to 1.0
    
    
    // Movie Size
    var movieSize:CGSize = CGSizeZero
    
    
    var MOVIE_DURATION_OBSERVATION = "MOVIE_DURATION_OBSERVATION"
    
    var timePeriodObserver: AnyObject!
    
    init(URL: NSURL) {
        
        videoProcessQueue = dispatch_queue_create("sunsetVideoProcessQueue", DISPATCH_QUEUE_SERIAL)
        
        super.init()
        
        url = URL

        displayLink = CADisplayLink(target: self, selector: "displayLinkCallback:")
        displayLink.addToRunLoop(NSRunLoop.currentRunLoop(), forMode: NSDefaultRunLoopMode)
        displayLink.paused = true
        
        var pixBuffAttributes : [NSObject: AnyObject] = [ kCVPixelBufferPixelFormatTypeKey: kCVPixelFormatType_420YpCbCr8BiPlanarVideoRange]
        videoOutput = AVPlayerItemVideoOutput(pixelBufferAttributes: pixBuffAttributes)
        videoOutput!.setDelegate(self, queue: videoProcessQueue)
        player = AVPlayer()
        timePeriodObserver = player.addPeriodicTimeObserverForInterval(CMTimeMake(3, 30), queue: nil, usingBlock: {
            nowTime in
            
            var sec = Double( CMTimeGetSeconds(nowTime) )
            if let dur = self.duration?.doubleValue{
                var per =  sec / dur
                
                self.setValue(NSNumber(double: per), forKey: "playedTimePercent")
                
                
            }
            
        })
        
        playerItem = AVPlayerItem(URL: self.url)
        
        self.calcMovieSize(playerItem!.asset)
        
        dispatch_async(videoProcessQueue, {
            self.processURL()
        })
        
    }
    
    deinit{
        
        player.removeTimeObserver(timePeriodObserver)
        
        displayLink.paused = true
        displayLink.invalidate()
    }
    
    
    

    
    override func start() {
        self.play()
    }
    
    
    func stop(){
        self.pause()        
        self.player.seekToTime(kCMTimeZero)
    }
    
    func pause(){
//        displayLink.paused = true
        self.player.pause()
    }
    
    func play(){
        displayLink.paused = false
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
    
    
    func calcMovieSize(asset: AVAsset){
        
        var track = asset.tracksWithMediaType(AVMediaTypeVideo)[0] as AVAssetTrack
        
        println("naturalSize: \(track.naturalSize )")
        println("perferTransform:\(track.preferredTransform)")
        
        self.movieSize = track.naturalSize

    }
    
    func getMovieSize() -> CGSize{
        return self.movieSize
    }
    
    func processURL(){
        
        
        println("processURL")

        // TODO: Get to know pixel formate type
        

        var asset = playerItem!.asset
        
        asset.loadValuesAsynchronouslyForKeys(["duration", "tracks"], completionHandler: {
            if asset.statusOfValueForKey("duration", error: nil) == .Loaded {
                
                println("is loadValuesAsynchronouslyForKeys runing in main thread:\(NSThread.isMainThread()) ")
                
                var duration = Double ( CMTimeGetSeconds( asset.duration ))
                self.setValue(NSNumber(double: duration), forKey: "duration")
                
                println("duration:\(self.duration)")

            }
            
            if asset.statusOfValueForKey("tracks", error: nil) == .Loaded{
                var tracks = asset.tracksWithMediaType(AVMediaTypeVideo)
                if tracks.count > 0 {
                    var videoTrack = tracks[0] as AVAssetTrack
                    
                    self.playerItem!.addOutput(self.videoOutput)
                    self.player.replaceCurrentItemWithPlayerItem(self.playerItem!)
                    
                }
                
            }
        })
        
    }
    
    
    
    // MARK: AVPlayerItemOutputPullDelegate Delegates
    
    func outputMediaDataWillChange(sender: AVPlayerItemOutput!) {
        println("displayLink paused false")
        displayLink.paused = false
    }
    
    
    // MARK: CADisplayLink Callback
    func displayLinkCallback(sender: CADisplayLink){
//        println("displayLinkCallback")
//        println("is displayLinkCallback runing in main thread:\(NSThread.isMainThread()) ")
        
        var outputItemTime = kCMTimeInvalid
        var nextVSync = sender.timestamp + sender.duration
        
        
        outputItemTime = videoOutput!.itemTimeForHostTime(nextVSync)
        
        if videoOutput!.hasNewPixelBufferForItemTime(outputItemTime){
            var pixelBuffer : CVPixelBuffer?
            pixelBuffer = videoOutput!.copyPixelBufferForItemTime(outputItemTime, itemTimeForDisplay: nil)
//            println("pixelBuffer:\(pixelBuffer)")
//            println("pixelBuffer")
            
            for target in targets {
                target.processMovieFrame(pixelBuffer!)
            }
            
        }else{
//            println("no new pixel buffer for time:\(outputItemTime.value)")
        }
        
        
    }
    
    // MARK: SunsetAudioTapProcessorDelegate

    
    func audioTapProcessor(audioTapProcessor: SunsetAudioTapProcessor!, sampleBuffer: CMSampleBuffer!) {
        for target in targets {
            target.processAudioData(sampleBuffer)
        }
    }

    
}
////
////  EditMovie2ViewController.swift
////  ICamMov
////
////  Created by Alex Chan on 15/3/24.
////  Copyright (c) 2015年 sunset. All rights reserved.
////
//
//import Foundation
//import GPUImage
//
//class EditMovie3ViewController: UIViewController {
//    
//    
//    // MARK: IBOutlets
//    
//    @IBOutlet weak var subtitleView: UIView!
//    
//    @IBOutlet weak var filterView: UIScrollView!
//    
//    @IBOutlet weak var previewView: GPUImageView!
//    
//
//    
//    @IBOutlet weak var upperMask: UIView!
//    @IBOutlet weak var bottomMask: UIView!
//    
//    @IBOutlet weak var playProgress: UISlider!
//    @IBOutlet weak var playBtn: UIButton!
//    
//    
//    
//    // MARK: Private variables
//    
//    var currentShowing: UIView?
//    
//    var player: AVPlayer?
//    var observer: AnyObject?
//    
//    
//    var duration = kCMTimeZero
//    
//    var isPlaying = false
//    
//    var playItem : AVPlayerItem?
//    
//    
//    
//    // MARK: Override
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        
//        var movieFile = GPUImageMovie(URL: Utils.getTestVideoUrl())
//        movieFile.runBenchmark = true
//        movieFile.playAtActualSpeed = false
//        
//        var filter = GPUImageGaussianBlurFilter()
//        movieFile.addTarget(filter)
//        
//        
//        
//        
//        
//        var filterView =  self.previewView
//        filterView.fillMode = kGPUImageFillModeStretch
//        
//        filter.addTarget(filterView)
//        
//        
//        
//        filter.blurRadiusInPixels = 10
//        
////        filter.fractionalWidthOfAPixel = 0.05
//        
//        
//        movieFile.startProcessing()
//        
//        
//        
//        
//    }
//    
//    override func viewWillAppear(animated: Bool) {
//        super.viewWillAppear(animated)
//        
//        return
//            
//        self.duration = kCMTimeZero
//        
//        var testURL = Utils.getTestVideoUrl()
//        var test2URL = Utils.getTestVideo2Url()
//        self.loadMovieItems([testURL])
//        
//    }
//    
//    override func viewWillDisappear(animated: Bool) {
//        
//        if let player = self.player {
//            
//            if let obs: AnyObject = self.observer {
//                player.removeTimeObserver(obs)
//            }
//            
//            self.removeObserverToPlayEnding()
//            
//            player.pause()
//        
//            self.player = nil
//            
//        }
//        
//        super.viewWillDisappear(animated)
//    }
//    
//    
//    
//    
//    // MARK: Selectors
//    func lastPlayerItemDidReachEnd(notification: NSNotification){
//        println("play to the end")
//
//        
//        
//        self.player!.pause()
//        
//        self.playItem!.seekToTime(kCMTimeZero)
//
//        
//        self.player?.seekToTime(kCMTimeZero)
//        
//        
//        self.isPlaying = false
//        
//    }
//    
//    
//    // MARK: Custom functions
//    func removeObserverToPlayEnding(){
//        // We assign the last play item will never change.
//        if let player = self.player {
//            
//            
//            NSNotificationCenter.defaultCenter().removeObserver(self, name: AVPlayerItemDidPlayToEndTimeNotification, object: self.playItem)
//        }
//        
//    }
//    
//    func addObserverToPlayEnding(lastItem: AVPlayerItem){
//        NSNotificationCenter.defaultCenter().addObserver(self, selector: "lastPlayerItemDidReachEnd:", name: AVPlayerItemDidPlayToEndTimeNotification, object: lastItem)
//        
//    }
//    
//    func syncUI(){
//        // TODO: CMTimeMake: to make more good
//        
//        self.player!.addPeriodicTimeObserverForInterval(CMTimeMake(3,30), queue: nil, usingBlock: {
//            (t: CMTime) in
//            
//            //            return
//            
//            var totalSecs = CMTimeGetSeconds( self.duration )
//            var curSec = CMTimeGetSeconds( t)
//
//            
//            
//            let val = Float(curSec / totalSecs)
//            
//            self.playProgress.value = val
//            
//            return
//            
//        })
//    }
//    
//    
//    func loadMovieItems(urls: [NSURL]){
//        
//        
//        
//        println("load movie items, currently only one item is allowed")
//        
//        
//        if urls.count != 1{
//            // TODO: Better hints to user
//            println("urls count is not 1, error")
//            return
//        }
//        
//        var url = urls[0]
//        
//            
//            var trackKey = "tracks"
//            var durationKey = "duration"
//            
//            var asset = AVURLAsset(URL: url, options: nil)
//            asset.loadValuesAsynchronouslyForKeys([durationKey, trackKey], completionHandler: {
//                
//                println("loaded key")
//                var error: NSError?
//                
//                var durationStatus = asset.statusOfValueForKey(durationKey, error: &error)
//                if durationStatus == AVKeyValueStatus.Loaded {
//                    println("duration status loaded")
//                    
//                    self.duration = asset.duration
//                    
//                }else{
//                    print("error load duration:")
//                    println(error)
//                }
//                
//                var status = asset.statusOfValueForKey(trackKey, error: &error)
//                
//                
//                if status == AVKeyValueStatus.Loaded {
//                    println("track status ok")
//                    var item = AVPlayerItem(asset: asset)
//                    self.playItem = item
//                    
//                }else{
//                    print("error load track:")
//                    println(error)
//                }
//                
//                
//                
//                println("construst AVQueuePlayer")
//                
//                
//                var player = AVPlayer(playerItem: self.playItem!)
//                
//                player.actionAtItemEnd = AVPlayerActionAtItemEnd.None
//                
////                self.previewView.player = player 
//                
//                self.player = player
//                
//                self.syncUI()
//                
//                self.addObserverToPlayEnding(self.playItem!)
//                
//                self.doPlay()
//                
//            })
// 
//        
//
//        
//    }
//    
//    
//    func doPlay(){
//        println("doPlay")
//        self.player?.play()
//        self.isPlaying = true
//    }
//    
//    func doPause(){
//        println("doPause")
//        self.player?.pause()
//        self.isPlaying = false
//    }
//    
//    
//    // MARK: Actions
//    
//    var  masking = true
//    
//    @IBAction func playAction(sender: UIButton) {
//        if self.isPlaying {
//            self.doPause()
//            
//        }else{
//            self.doPlay()
//        }
//        
//    }
//    
//    @IBAction func maskAction(sender: UIButton) {
//        
//        self.upperMask.hidden = !self.upperMask.hidden
//        self.bottomMask.hidden = !self.bottomMask.hidden
//        
//        
//    }
//    
//    
//    @IBAction func subtitleAction(sender: UIBarButtonItem) {
//        
//        if self.currentShowing != nil {
//            self.currentShowing!.hidden = true
//        }
//        
//        
//        if self.currentShowing != self.subtitleView {
//            self.subtitleView.hidden = false
//            self.currentShowing = self.subtitleView
//        }else{
//            self.currentShowing = nil
//        }
//        
//        
//        
//    }
//    
//    
//    @IBAction func filerAction(sender: UIBarButtonItem) {
//        
//        if self.currentShowing != nil {
//            self.currentShowing!.hidden = true
//        }
//        
//        if self.currentShowing != self.filterView {
//            self.filterView.hidden = false
//            self.currentShowing = self.filterView
//        }else{
//            self.currentShowing = nil
//        }
//        
//        
//    }
//    
//    @IBAction func progressChange(sender: UISlider) {
//        
//        self.doPause()
//        
//        var val = Float64(sender.value)
//        
//        
//        var seekTo = CMTimeMultiplyByFloat64(self.duration, val)
//        
//           println("seekTo:\(CMTimeGetSeconds(seekTo))")
//        
//        
//        
//                
//                var toleranceBefore = CMTimeAbsoluteValue( CMTimeSubtract( seekTo, CMTimeMake(2, 30) ) )
//                
//                var toleranceAfter = CMTimeAdd(CMTimeMake(2, 30), seekTo)
//                
//                self.playItem!.seekToTime(seekTo, toleranceBefore:toleranceBefore, toleranceAfter: toleranceAfter, completionHandler:{
//                    (succeed: Bool) in
//                    return
//                })
//                self.player!.seekToTime(seekTo, toleranceBefore:toleranceBefore, toleranceAfter: toleranceAfter, completionHandler:{
//                    (succeed: Bool) in
//                    return
//                })
//
//   
//        }
//        
//}
//
//  EditMovieViewController.swift
//  TryDemo
//
//  Created by Alex Chan on 14/12/5.
//  Copyright (c) 2014年 sunset. All rights reserved.
//


import Foundation
import AVFoundation
import UIKit
import AssetsLibrary
import MobileCoreServices


var AVLoopPlayerCurrentItemObservationContext = "AVLoopPlayerCurrentItemObservationContext"





class EditMovieViewController: UIViewController, SAVideoRangeSliderDelegate{
    
    var tmpMovieURL: NSURL?
    var finalMovieURL : NSURL?
    


    var queuePlayer: AVQueuePlayer?
    var stillMovie: StillMovieEffect?

    
    @IBOutlet weak var playerView: MoviePreviewView!
    
    @IBOutlet weak var prefixStepper: UIStepper!
    
    @IBOutlet weak var prefixStillSec: UILabel!
    
    // MARK: Override methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tmpMovieURL = Utils.getTestVideoUrl()
        
        println("viewDidLoad")
        
        self.prefixStepper.addTarget(self, action: "prefixStepperChanged:", forControlEvents: UIControlEvents.ValueChanged)
        self.addVideoRangeSlider()
        
    }
    
    override func shouldAutorotate() -> Bool {
        return false
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        println("viewWillAppear")
        
        
        self.loadMovieItems([self.tmpMovieURL!, self.tmpMovieURL!])
        
    }
    
    
    override func viewWillDisappear(animated: Bool) {
        
        println("viewWillDisappear")
        
        if let player = self.queuePlayer {
            player.removeObserver(self, forKeyPath: "currentItem", context: &AVLoopPlayerCurrentItemObservationContext)
            player.pause()
            player.removeAllItems()
            self.queuePlayer = nil
        }

        
        super.viewWillDisappear(animated)
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    
    override func observeValueForKeyPath(keyPath: String, ofObject object: AnyObject, change: [NSObject : AnyObject], context: UnsafeMutablePointer<Void>) {


        if context == &AVLoopPlayerCurrentItemObservationContext{

            var player:AVQueuePlayer = object as AVQueuePlayer
            var itemRemoved = change[NSKeyValueChangeOldKey] as MyAVPlayerItem
            if itemRemoved.isKindOfClass(MyAVPlayerItem){

                itemRemoved.seekToTime(kCMTimeZero)
                player.insertItem(itemRemoved, afterItem: nil)
                

            }
            
        }else{
            return super.observeValueForKeyPath(keyPath, ofObject: object , change: change, context: context)
        }
        
        
    }

    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "toShareMovieSegue" {
            print("toShareMovieSegue: \(self.finalMovieURL)")
            (segue.destinationViewController as ShareMovieViewController).toShareMovieURL  = self.finalMovieURL
            
        }
    }
    
    // MARK: selectors
    
    func prefixStepperChanged(stepper: UIStepper){
        
        self.prefixStillSec.text = String(format: "%1.0f", stepper.value)
    }
    
    func playerItemDidReachEnd(notification: NSNotification) {
        
        
        println("playerItemDidReachEnd \(self.queuePlayer!.items()) ")
        
//        self.queuePlayer!.items()[0].seekToTime(kCMTimeZero)
//        var p: AVPlayerItem = notification.object as AVPlayerItem
//        p.seekToTime(kCMTimeZero)
//        self.playMovies()

    }
    
    // MARK: actions
    
    @IBAction func previewMovie(sender: UIButton) {
        println("preview btn clicked")
        

        if (self.queuePlayer != nil && self.queuePlayer!.status == AVPlayerStatus.ReadyToPlay){
            
            println("ready to play")
            self.queuePlayer!.seekToTime(kCMTimeZero)
            
            self.queuePlayer!.play()
        }
    }
    
    @IBAction func finishEditing(sender: UIButton) {
        
        println("finish editing")
        self.finalMovieURL = self.tmpMovieURL
        
    }
    
    
    @IBAction func unwindToEditMovie(segue: UIStoryboardSegue) {
        
    }
    

    // MARK: SAVideoRangeSlider delegates and related
    
    var leftPos: CGFloat?
    var rightPos: CGFloat?
    var lastLeftPos: CGFloat?
    var lastRightPos: CGFloat?
    
    func videoRange(videoRange: SAVideoRangeSlider!, didChangeLeftPosition leftPosition: CGFloat, rightPosition: CGFloat) {
        println("leftPos:\(leftPosition),rightPos:\(rightPosition)")
        
        
        self.leftPos = leftPosition
        self.rightPos = rightPosition
        
        
        if self.lastLeftPos == nil {
            self.lastLeftPos = leftPosition
        }
        
        if abs(leftPosition - self.lastLeftPos!) >= 0.1 {
            
            self.lastLeftPos = leftPosition
            
            var sTime = CMTimeMake(Int64(leftPosition*30), 30)
            var toleranceBefore = CMTimeAbsoluteValue( CMTimeSubtract( sTime, CMTimeMake(2, 30) ) )            
            
            var toleranceAfter = CMTimeAdd(CMTimeMake(2, 30), sTime)
            
            self.queuePlayer!.pause()
            self.queuePlayer!.seekToTime(sTime, toleranceBefore:toleranceBefore, toleranceAfter: toleranceAfter, completionHandler:{
                (succeed: Bool) in
                return
            })
        }
        

        
        
    }
    
    func videoRange(videoRange: SAVideoRangeSlider!, didGestureStateEndedLeftPosition leftPosition: CGFloat, rightPosition: CGFloat) {
        
        println("gesture state ended")
    }

    func addVideoRangeSlider(){
        
        
        var viewWrap = self.view.viewWithTag(kSAVideoRangeSliderWrappViewTag)!
        
        
        println("viewWrap.frame:\(viewWrap.frame)")
        println("viewWrap.frame.size:\(viewWrap.frame.size)")
        println("viewWrap.bounds:\(viewWrap.bounds)")
        println("self.view.frame:\(self.view.frame)")
        
        
        var mySAVideoRangeSlider = SAVideoRangeSlider(frame: CGRectMake(0,0,self.view.frame.size.width, 44), videoUrl: self.tmpMovieURL)
        
        mySAVideoRangeSlider.setPopoverBubbleSize(160, height:80)
        mySAVideoRangeSlider.delegate = self
        
        
        
        // Yellow
        mySAVideoRangeSlider.topBorder.backgroundColor = UIColor(red: 0.996, green: 0.951, blue: 0.502, alpha: 1)
        
        mySAVideoRangeSlider.bottomBorder.backgroundColor = UIColor(red: 0.992, green: 0.902, blue: 0.004, alpha: 1)
        
        viewWrap.addSubview(mySAVideoRangeSlider)
        
    }
    
    // MARK: Image generate related functions
    
    func loadMovieItems(movieURLs: [NSURL]){
        // Assert the movieURLs' length is 2
        
        var tracksKey = "tracks"
        
        
        
        var asset1: AVURLAsset = AVURLAsset(URL: movieURLs[0], options: nil)
        
        
        asset1.loadValuesAsynchronouslyForKeys([tracksKey], completionHandler: {
            
            var error: NSError? = nil
            var status: AVKeyValueStatus = asset1.statusOfValueForKey(tracksKey, error: &error)
            
            if status == AVKeyValueStatus.Loaded{
                var item1 = MyAVPlayerItem(asset: asset1, itemType: MyAVPlayerItemType.PREFIX_ITEM)
                
                var asset2: AVURLAsset = AVURLAsset(URL: movieURLs[1], options: nil)
                
                asset2.loadValuesAsynchronouslyForKeys([tracksKey], completionHandler: {
                    
                    var error2: NSError? = nil
                    var status2: AVKeyValueStatus = asset2.statusOfValueForKey(tracksKey, error: &error)
                    
                    if status2 == AVKeyValueStatus.Loaded{
                        var item2 = MyAVPlayerItem(asset: asset2, itemType: MyAVPlayerItemType.MAIN_ITEM)
                        
                        dispatch_async(dispatch_get_main_queue(), {
                            self.constructQueyPlayerAndPlay(item1, item2: item2)
                        })
                        
                        
                        
                    }else{
                        println(error2)
                    }
                })
                
                
            }else{
                println(error)
            }
            
        })
        
    }
    
    
    
    func playMovies(){
        
        self.queuePlayer!.play()
    }
    
    func pauseMovies(){
        
        self.queuePlayer!.pause()
    }
    
    
    func constructQueyPlayerAndPlay(item1: MyAVPlayerItem, item2: MyAVPlayerItem){
        if self.queuePlayer == nil{
 
            
            self.queuePlayer = AVQueuePlayer( items: [item1, item2])
            
            self.playerView.player =  self.queuePlayer!
            
        }
        
        self.queuePlayer!.addObserver(self, forKeyPath: "currentItem", options: NSKeyValueObservingOptions.Old, context: &AVLoopPlayerCurrentItemObservationContext)
        
        self.queuePlayer!.actionAtItemEnd = AVPlayerActionAtItemEnd.Advance
        
        println("items ready to play :\(self.queuePlayer!.items() ) ")
//        self.queuePlayer!.play()
        
        
    }
    


}
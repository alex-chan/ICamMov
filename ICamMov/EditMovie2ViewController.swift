//
//  EditMovie2ViewController.swift
//  ICamMov
//
//  Created by Alex Chan on 15/3/24.
//  Copyright (c) 2015年 sunset. All rights reserved.
//

import Foundation

class EditMovie2ViewController: UIViewController {
    
    
    // MARK: IBOutlets
    
    @IBOutlet weak var subtitleView: UIView!
    
    @IBOutlet weak var filterView: UIScrollView!
    
    @IBOutlet weak var previewView: MoviePreviewView!
    
    
    @IBOutlet weak var upperMask: UIView!
    @IBOutlet weak var bottomMask: UIView!
    
    @IBOutlet weak var playProgress: UISlider!
    @IBOutlet weak var playBtn: UIButton!
    
    
    
    // MARK: Private variables
    
    var currentShowing: UIView?
    
    var player: AVQueuePlayer?
    var observer: AnyObject?
    
    var accumDurationArray = [CMTime]()
    var totalDuration = kCMTimeZero
    
    var isPlaying = false
    
    var allPlayItems = [AVPlayerItem]()
    
    // MARK: Override
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.accumDurationArray = [CMTime]()
        
        
        self.totalDuration = kCMTimeZero
        
        var testURL = Utils.getTestVideoUrl()
        var test2URL = Utils.getTestVideo2Url()
        self.loadMovieItems([testURL, test2URL])
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        
        if let player = self.player {
            
            if let obs: AnyObject = self.observer {
                player.removeTimeObserver(obs)
            }
            
            self.removeObserverToPlayEnding()
            
            player.pause()
            player.removeAllItems()
            self.player = nil
            
        }
        
        super.viewWillDisappear(animated)
    }
    
    


    // MARK: Selectors
    func lastPlayerItemDidReachEnd(notification: NSNotification){
        println("play to the end")
//        var item = notification.object as AVPlayerItem

        var items = self.player?.items() as [AVPlayerItem]
//        println("items:\(items)")
//        
//        println("allItems:\(self.allPlayItems)")
//
        
        
//        
//        self.allPlayItems[0].seekToTime(kCMTimeZero)
//        self.player?.seekToTime(kCMTimeZero)
//        
//        self.isPlaying = false
        
        self.player!.pause()
        self.player!.removeAllItems()
        

        for item in self.allPlayItems{
            if self.player!.canInsertItem(item, afterItem: nil){
                println("insert item:\(item)")
                self.player!.insertItem(item, afterItem: nil)
                item.seekToTime(kCMTimeZero)
            }else{
                println("cannot insert item:\(item)")
            }
            
        }
        
//        items = self.player?.items() as [AVPlayerItem]
//        println("items:\(items)")
        
        self.player?.seekToTime(kCMTimeZero)

        
        self.isPlaying = false
        
    }
   
    
    // MARK: Custom functions
    func removeObserverToPlayEnding(){
        // We assign the last play item will never change.
        if let player = self.player {
       
            var lastItem: AnyObject = self.allPlayItems[self.allPlayItems.count - 1]
            NSNotificationCenter.defaultCenter().removeObserver(self, name: AVPlayerItemDidPlayToEndTimeNotification, object: lastItem)
        }
        
    }
    
    func addObserverToPlayEnding(lastItem: AVPlayerItem){
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "lastPlayerItemDidReachEnd:", name: AVPlayerItemDidPlayToEndTimeNotification, object: lastItem)
        
    }
    
    func syncUI(){
        // TODO: CMTimeMake: to make more good
        
        self.player!.addPeriodicTimeObserverForInterval(CMTimeMake(3,30), queue: nil, usingBlock: {
            (t: CMTime) in
            
//            return
            
            var totalSecs = CMTimeGetSeconds( self.totalDuration )
//            var curSec = CMTimeGetSeconds(t)
            
            var leftPlayCount = self.player!.items().count
            var totalItemCount = self.allPlayItems.count
            
            var t2 = self.accumDurationArray[ totalItemCount - leftPlayCount ]
            
            var curSec = CMTimeGetSeconds( CMTimeAdd(t, t2) )
            
            let val = Float(curSec / totalSecs)
            
            self.playProgress.value = val
            
            return
            
        })
    }
    
    
    func loadMovieItems(urls: [NSURL]){
        
        println("load movie items")
        
        
        if urls.count == 0 {
            // TODO: Better hints to user
            println("urls count is 0, error")
            return
        }
        
        var group = dispatch_group_create()
        
        var items = [AVPlayerItem?](count: urls.count, repeatedValue: nil)
        var durations = [CMTime?](count: urls.count, repeatedValue: nil)
        
        self.accumDurationArray.append(kCMTimeZero)
        
        for (index,url) in enumerate(urls){

            dispatch_group_enter(group)
            
            var trackKey = "tracks"
            var durationKey = "duration"
            
            var asset = AVURLAsset(URL: url, options: nil)
            asset.loadValuesAsynchronouslyForKeys([durationKey, trackKey], completionHandler: {
                
                println("loaded key")
                var error: NSError?
                
                var durationStatus = asset.statusOfValueForKey(durationKey, error: &error)
                if durationStatus == AVKeyValueStatus.Loaded {
                    println("duration status loaded")
//                    
                    self.totalDuration = CMTimeAdd( asset.duration, self.totalDuration )
//                    self.accumDurationArray.append(self.totalDuration)
                    println("totalDuration :\(self.totalDuration)")
                    
                    
                    
                    durations[index] = asset.duration
                    
                    
                }else{
                    print("error load duration:")
                    println(error)
                }
                
                var status = asset.statusOfValueForKey(trackKey, error: &error)
                
                
                if status == AVKeyValueStatus.Loaded {
                    println("track status ok")
                    var item = AVPlayerItem(asset: asset)
                    items[index] = item
                    
                }else{
                    print("error load track:")
                    println(error)
                }
                dispatch_group_leave(group)
                
            })
        }
        


        
        dispatch_group_notify(group, dispatch_get_main_queue(), {
            
            println("construst AVQueuePlayer")
            
            println("accumDurationArray count:\(self.accumDurationArray.count)")
            
            self.allPlayItems.removeAll(keepCapacity: false)
            for item in items {
                if item != nil{
                    self.allPlayItems.append(item!)
                }
            }
            println("all items:\(items)" )
            
            self.accumDurationArray.removeAll(keepCapacity: false)
            self.accumDurationArray.append(kCMTimeZero)
            for dur in durations {
                if dur != nil{
                    
                    self.accumDurationArray.append(CMTimeAdd(self.accumDurationArray.last! , dur!) )
                }
            }
            self.totalDuration = self.accumDurationArray.last!
            println("accumDurationArray:\(self.accumDurationArray)" )
            
            var player = AVQueuePlayer(items: self.allPlayItems)
            player.actionAtItemEnd = AVPlayerActionAtItemEnd.Advance
            
            self.previewView.player = player
            
            self.player = player
            
            self.syncUI()
            
            self.addObserverToPlayEnding(self.allPlayItems[self.allPlayItems.count-1])
            
            self.doPlay()
        })
    }
    

    func doPlay(){
        println("doPlay")
        self.player?.play()
        self.isPlaying = true
    }
    
    func doPause(){
        println("doPause")
        self.player?.pause()
        self.isPlaying = false
    }
    
    
    // MARK: Actions
    
    var  masking = true
    
    @IBAction func playAction(sender: UIButton) {
        if self.isPlaying {
            self.doPause()
            
        }else{
            self.doPlay()
        }
        
    }
    
    @IBAction func maskAction(sender: UIButton) {
        
        self.upperMask.hidden = !self.upperMask.hidden
        self.bottomMask.hidden = !self.bottomMask.hidden
        
        
    }
    
    
    @IBAction func subtitleAction(sender: UIBarButtonItem) {
        
        if self.currentShowing != nil {
            self.currentShowing!.hidden = true
        }
        
        
        if self.currentShowing != self.subtitleView {
            self.subtitleView.hidden = false
            self.currentShowing = self.subtitleView
        }else{
            self.currentShowing = nil
        }
        
        
        
    }
    
    
    @IBAction func filerAction(sender: UIBarButtonItem) {

        if self.currentShowing != nil {
            self.currentShowing!.hidden = true
        }
        
        if self.currentShowing != self.filterView {
            self.filterView.hidden = false
            self.currentShowing = self.filterView
        }else{
            self.currentShowing = nil
        }
        
        
    }
    
    @IBAction func progressChange(sender: UISlider) {
        
        self.doPause()
        
        var val = Float64(sender.value)
        
        
        var seekTime = CMTimeMultiplyByFloat64(self.totalDuration, val)
        
        // accumDurationArray is like [0, 5s, 6.8s, 10s]
        
        println("accumDurationArray:\(self.accumDurationArray)")
        println("seekTime:\(CMTimeGetSeconds(seekTime))")
        
        
     
        for (index, timeStep) in enumerate(self.accumDurationArray){
            
            println("loop index:\(index)")
            println("loop timeStep:\(CMTimeGetSeconds(timeStep))")
            
            if index == 0 {
                continue
            }
            
            if CMTimeCompare(seekTime, timeStep) > 0 {
                println("Adance to next")
                self.player!.advanceToNextItem()
            }else{
                
                var it = self.allPlayItems[index-1]
                var beforeTimeline = self.accumDurationArray[index-1]
                var seekTo = CMTimeSubtract(seekTime, beforeTimeline)
                
                println("seekToTime:\(CMTimeGetSeconds(seekTo))")
                
                
                var toleranceBefore = CMTimeAbsoluteValue( CMTimeSubtract( seekTo, CMTimeMake(2, 30) ) )
                
                var toleranceAfter = CMTimeAdd(CMTimeMake(2, 30), seekTo)
             
                it.seekToTime(seekTo, toleranceBefore:toleranceBefore, toleranceAfter: toleranceAfter, completionHandler:{
                    (succeed: Bool) in
                    return
                })
                self.player!.seekToTime(seekTo, toleranceBefore:toleranceBefore, toleranceAfter: toleranceAfter, completionHandler:{
                    (succeed: Bool) in
                    return
                })
                break
                
//                it.seekToTime(seekTo)
//                self.player!.seekToTime(seekTo)
            }
        }
        
        
        
    }
    
}
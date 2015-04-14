//
//  SunetPlayerViewController.swift
//  UsetCoreImage
//
//  Created by Alex Chan on 15/4/1.
//  Copyright (c) 2015年 Alex Chan. All rights reserved.
//

import Foundation
import UIKit


protocol SunsetPlayerViewControllerDelegate {
    func playBtnClicked()
    func pauseBtnClicked()
}


class SunsetPlayerViewController : UIViewController{
    
    
    
    var MOVIE_DURATION_SET = "MOVIE_DURATION_SET"
    var MOVIE_PLAYED_TIME_PERCENT_CHANGE = "MOVIE_PLAYED_TIME_PERCENT_CHANGE"
    
    
//    @IBOutlet var playerView: UIView!
   
    @IBOutlet weak var playerView: SunsetView!
    @IBOutlet weak var playPauseBtn: UIButton!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var movieDuration: UILabel!
    @IBOutlet weak var currentTime: UILabel!
    
    var isPlaying = false
    
    var delegate : SunsetPlayerViewControllerDelegate?
    
    var movie: SunsetMovie?
    
    var duration: Double = 10.0 // Assign a default 10s incase for exception
    
    // MARK: Override methods
    override func loadView() {
        var views =  NSBundle.mainBundle().loadNibNamed("SunsetPlayerView", owner: self, options: nil)
        self.view = views[0] as UIView
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupUI()
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        println("player view will appear")
        
        self.addObserver(self, forKeyPath: "movie.duration", options: NSKeyValueObservingOptions.New, context: &MOVIE_DURATION_SET)
        self.addObserver(self, forKeyPath: "movie.playedTimePercent", options: NSKeyValueObservingOptions.New, context: &MOVIE_PLAYED_TIME_PERCENT_CHANGE)
        
        
        if let mov = self.movie {
            NSNotificationCenter.defaultCenter().addObserver(self, selector: "playItemDidReachEnd:", name: AVPlayerItemDidPlayToEndTimeNotification, object: mov.playerItem)
            
        }
        
        
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        
        if let mov = self.movie {
            NSNotificationCenter.defaultCenter().removeObserver(self, name: AVPlayerItemDidPlayToEndTimeNotification, object: mov.playerItem)
        }
        
        self.removeObserver(self, forKeyPath: "movie.duration")
        self.removeObserver(self, forKeyPath: "movie.playedTimePercent")
        
        
        super.viewWillDisappear(animated)
    }
    
    override func observeValueForKeyPath(keyPath: String, ofObject object: AnyObject, change: [NSObject : AnyObject], context: UnsafeMutablePointer<Void>) {
        
        
        if context == &MOVIE_DURATION_SET {
            var value = change[NSKeyValueChangeNewKey]! as NSNumber
            self.setupUIMovieDuration(value)
        
        }else if context == &MOVIE_PLAYED_TIME_PERCENT_CHANGE {
            
            var value = change[NSKeyValueChangeNewKey]! as NSNumber
            slider.setValue(Float(value.doubleValue), animated: true)
            currentTime.text = String(format:"%02d", Int( round(value.doubleValue * duration )))
                        
        }
        else{
            super.observeValueForKeyPath(keyPath, ofObject: object, change: change, context: context)
        }
    }
    
    // MARK: Custom methods
    func associateMovie(movie: SunsetMovie){
        println("associateMovie")
        self.movie = movie
        
        self.setupUIMovieDuration(movie.duration)
        
    }
    
    
    
    func setupUI(){
        
        slider.setThumbImage(UIImage(named: "sliderThumb"), forState: .Normal)
        slider.setThumbImage(UIImage(named: "sliderThumb"), forState: .Highlighted)
        
    }
    
    func setupUIMovieDuration(duration: NSNumber?){
        if duration != nil {
            self.duration = duration!.doubleValue
            var value = Int( round( duration!.doubleValue ) )
            movieDuration.text = String(format:"%02d", value)
        }
        
    }
    

    
    func play(){
        isPlaying = true
        playPauseBtn.setImage(UIImage(named:"pause"), forState: .Normal)
            
        if let delegate = delegate {
            delegate.playBtnClicked()
        }
        if let mov = movie {
            mov.play()
        }
        
    }
    func pause(){
        isPlaying = false
        playPauseBtn.setImage(UIImage(named: "play"), forState: .Normal)
        if let delegate = delegate {
            delegate.pauseBtnClicked()
        }
        if let mov = movie {
            mov.pause()
        }
    }
    
    func stop(){
        self.pause()
        if let mov = movie {
            mov.stop()
        }
    }
    
    // MARK: Selectors
    func playItemDidReachEnd(notification: NSNotification){
        self.stop()
    }
    
    // MARK: Actions
    
    @IBAction func playOrPause(sender: UIButton) {
        if isPlaying {
            self.pause()
        } else {
            self.play()
        }
    }

    @IBAction func progressChange(sender: UISlider) {
        
        var val = Double(sender.value)
        var sec = duration * val
        var seekTo = CMTimeMakeWithSeconds(sec, 32)
        
        var toleranceBefore = CMTimeMake(2, 30) //CMTimeAbsoluteValue( CMTimeSubtract( seekTo, CMTimeMake(2, 30) ) )
        
        var toleranceAfter = CMTimeMake(2, 30) // CMTimeAdd(CMTimeMake(2, 30), seekTo)
        
        if let mov = self.movie{

            mov.player!.seekToTime(seekTo, toleranceBefore:toleranceBefore, toleranceAfter: toleranceAfter, completionHandler:{
                (succeed: Bool) in
                return
            })
            mov.playerItem!.seekToTime(seekTo, toleranceBefore:toleranceBefore, toleranceAfter: toleranceAfter, completionHandler:{
                (succeed: Bool) in
                return
            })
        }
        self.pause()

    }
    
}